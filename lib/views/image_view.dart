import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/draggable_widget.dart';
import '../models/wallpaper_model.dart';
import '../constants/color_constant.dart';

class ImageView extends StatelessWidget {
  final WallpaperModel wallpaperModel;
  final int index;
  const ImageView({Key? key, required this.wallpaperModel, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorConstant colorConstant = Get.put(ColorConstant());
    double h = Get.mediaQuery.size.height;
    double w = Get.mediaQuery.size.width;
    return Scaffold(
      backgroundColor: colorConstant.kPrimary,
      body: SingleChildScrollView(
        child: Container(
          height: h,
          color: colorConstant.kPrimary,
          child: Stack(
            children: [
              Hero(
                tag: "wallpaper-image$index",
                child: CachedNetworkImage(
                  imageUrl: wallpaperModel.largeImgUrl,
                  fit: BoxFit.cover,
                  height: h,
                ),
              ),
              DraggableScrollableSheet(
                  initialChildSize: 0.11,
                  minChildSize: 0.11,
                  maxChildSize: 0.45,
                  builder: (context, controller) => DraggableWidget(
                        width: w * 0.95,
                        height: 330,
                        scrollController: controller,
                        wallpaperModel: wallpaperModel,
                      ))
              // Positioned(
              //     left: 15,
              //     bottom: 30,
              //     child: ),
            ],
          ),
        ),
      ),
    );
  }
}
