import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/home_body.dart';
import '../constants/color_constant.dart';
import '../models/wallpaper_model.dart';
import '../widgets/custom_app_bar.dart';
import '../controller/controller.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    CustomAppBar customAppBar = Get.put(CustomAppBar());
    ColorConstant colorConstant = Get.put(ColorConstant());
    HomeBody homeBody = Get.put(HomeBody());
    return SafeArea(
      child: Scaffold(
        body: Container(
            color: colorConstant.kPrimary,
            padding: const EdgeInsets.only(bottom: 5),
            child: Obx(() {
              return Column(
                children: [
                  customAppBar.customHomeAppBar(),
                  Expanded(
                      child: controller.searchQuery.value != "" &&
                              controller.pageNumber.value > 0
                          ? FutureBuilder<List<WallpaperModel>>(
                              future: controller.wallpaperData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.active ||
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    debugPrint('Got error');
                                    controller.loadingItems(false);
                                    return Text(snapshot.error.toString());
                                  } else {
                                    debugPrint("Got data");
                                    controller.addItemsToList(
                                        context, snapshot.data!);
                                    controller.loadingItems(false);
                                    debugPrint("Finished adding data to List");
                                    return homeBody.getHomeBody();
                                  }
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  debugPrint("Waiting for data");
                                  if (controller.items == null) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    debugPrint(
                                        "Showing Bottom Progress Indicator");
                                    controller.loadingItems(true);
                                    return homeBody.getHomeBody();
                                  }
                                } else {
                                  debugPrint("Got nothing to show");
                                  return Container();
                                }
                              })
                          : Container()),
                  Container(
                      height: 40,
                      width: Get.mediaQuery.size.width,
                      color: colorConstant.kPrimary,
                      child: TextButton(
                          child: const Text("Load More"),
                          onPressed: () {
                            controller.loadMore();
                          }))
                ],
              );
            })),
      ),
    );
  }
}
