import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../constants/color_constant.dart';
import '../widgets/error_widget.dart';
import '../views/image_view.dart';
import '../controller/controller.dart';

class HomeBody {
  Controller controller = Get.put(Controller());
  ColorConstant colorConstant = Get.put(ColorConstant());
  GetErrorWidget errorWidget = Get.put(GetErrorWidget());
  Column getHomeBody() {
    return Column(
      children: [
        controller.wallpaperData == null
            ? Container()
            : Expanded(
                flex: 4,
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: controller.items!.isEmpty ? 1 : 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        childAspectRatio:
                            controller.items!.isEmpty ? 9 / 16 : 0.75),
                    shrinkWrap: true,
                    itemCount: controller.items!.isEmpty
                        ? 1
                        : controller.items!.length,
                    itemBuilder: (context, index) {
                      if (controller.items!.isEmpty) {
                        return errorWidget.getErrorWidget();
                      } else {
                        return Hero(
                          tag: "wallpaper-image$index",
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => ImageView(
                                  wallpaperModel: controller.items![index],
                                  index: index));
                            },
                            child: CachedNetworkImage(
                                imageUrl: controller.items![index].tinyImgUrl,
                                fit: BoxFit.cover),
                          ),
                        );
                      }
                    }),
              ),
        controller.isLoadingHomePageItems.value == true
            ? const Expanded(
                flex: 1, child: Center(child: CircularProgressIndicator()))
            : Container(),
      ],
    );
  }
}
