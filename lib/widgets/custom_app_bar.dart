import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
                  initialValue: controller.searchQuery.value,
                  style: TextStyle(color: colorConstant.secondaryTextColor),
                  cursorColor: colorConstant.secondaryTextColor,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: colorConstant.hintTextColor),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search,
                            color: colorConstant.primaryTextColor),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            controller.searchForTheTerm();
                          }
                        }),
                  ),
                  onSaved: (val) {
                    controller.saveSearchQuery(val!);
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter Search Term';
                    } else if (val.isPhoneNumber) {
                      return 'Please enter a Search Term instead of a Phone Number';
                    } else if (val.isEmail) {
                      return 'Please enter a Search Term instead of an Email';
                    } else if (val.isNumericOnly) {
                      return 'Please enter a Search Term instead of a Number';
                    } else {
                      int i;
                      int count = 0;
                      for (i = 0; i < val.length; i++) {
                        if (val.substring(i, i + 1) == " ") {
                          count = count + 1;
                        }
                      }
                      debugPrint(count.toString());
                      if (count == val.length) {
                        return 'Please enter a Search Term';
                      }
                    }
                    return null;
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