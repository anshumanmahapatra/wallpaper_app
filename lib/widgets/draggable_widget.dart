import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';
import '../models/wallpaper_model.dart';
import '../constants/color_constant.dart';

class DraggableWidget extends StatelessWidget {
  final double width, height;
  final ScrollController scrollController;
  final WallpaperModel wallpaperModel;
  const DraggableWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.scrollController,
    required this.wallpaperModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorConstant colorConstant = Get.put(ColorConstant());
    Controller controller = Get.put(Controller());
    return ListView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 1.0),
                    color: colorConstant.kSecondary,
                  ),
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Icon(Icons.keyboard_arrow_up_sharp,
                        color: Colors.white),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Set this Picture as Wallpaper in",
                        style: TextStyle(
                          color: colorConstant.primaryTextColor,
                          fontSize: 15,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      child: const Text("Home Screen"),
                      onPressed: () {
                         controller.setWallpaper(1, wallpaperModel.largeImgUrl);
                      },
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 75,
                            vertical: 15,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      child: const Text("Lock Screen"),
                      onPressed: () {
                        controller.setWallpaper(2, wallpaperModel.largeImgUrl);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 75,
                          vertical: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      child: const Text("Both"),
                      onPressed: () {
                        controller.setWallpaper(3, wallpaperModel.largeImgUrl);
                      },
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 15,
                          )),
                    ),
                  ])),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
