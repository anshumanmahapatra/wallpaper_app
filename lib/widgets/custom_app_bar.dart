import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaper_app/views/search_view.dart';

import '../controller/controller.dart';
import '../constants/color_constant.dart';

class CustomAppBar {
  ColorConstant colorConstant = Get.put(ColorConstant());
  Controller controller = Get.put(Controller());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Container customHomeAppBar() {
    return Container(
      width: Get.mediaQuery.size.width,
      height: 75,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text("Wallpaper App",
                  style: TextStyle(
                      color: colorConstant.primaryTextColor, fontSize: 19))),
          Expanded(
            flex: 4,
            child: Container(
              color: colorConstant.kSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller:
                      TextEditingController(text: controller.searchQuery.value),
                  readOnly: true,
                  style: TextStyle(color: colorConstant.secondaryTextColor),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search,
                            color: colorConstant.primaryTextColor),
                        onPressed: () {}),
                  ),
                  onTap: () {
                    Get.to(() => const SearchView());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      color: colorConstant.kPrimary,
    );
  }
}
