import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../views/image_view.dart';
import '../controller/controller.dart';
import 'package:flutter/material.dart';

class HomeBody {
  Controller controller = Get.put(Controller());
  Column getHomeBody() {
    return Column(
      children: [
        controller.wallpaperData == null
            ? Container()
            : Expanded(
                flex: 4,
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 0.75),
                    shrinkWrap: true,
                    itemCount: controller.items!.length,
                    itemBuilder: (context, index) {
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
