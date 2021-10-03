import 'package:get/get.dart';
import '../controller/controller.dart';
import 'package:flutter/material.dart';

class HomeBody {
  Controller controller = Get.put(Controller());
  Column getHomeBody() {
    return Column(
      children: [
        controller.wallpaperData == null
            ? Container()
            :  Expanded(
              child: GridView.builder(
                // controller: controller.scrollController.value,
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
                        return Image.network(controller.items![index].tinyImgUrl,
                            fit: BoxFit.cover);
                      }),
            ),
              
        controller.isLoadingHomePageItems.value == true ? const CircularProgressIndicator() : Container(),
      ],
    );
  }
}
