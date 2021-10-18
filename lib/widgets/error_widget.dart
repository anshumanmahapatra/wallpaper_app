import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';
import '../constants/color_constant.dart';

class GetErrorWidget {
  getErrorWidget() {
    ColorConstant colorConstant = Get.put(ColorConstant());
    Controller controller = Get.put(Controller());
    return SizedBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(
        height: 40,
      ),
      Image.asset(
        'assets/in_app_gif/not_found.gif',
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "No results found for the term ",
                style: TextStyle(
                  color: colorConstant.primaryTextColor,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: "\"${controller.searchQuery.value}\"",
                    style: TextStyle(
                        color: colorConstant.primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ])),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Text(
          "Suggested Search Terms:",
          style: TextStyle(
            color: colorConstant.primaryTextColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Greece, ",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    controller.saveSearchQuery("Greece");
                    controller.searchForTheTerm();
                  },
                style: TextStyle(
                  color: colorConstant.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "Christmas, ",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.saveSearchQuery("Christmas");
                        controller.searchForTheTerm();
                      },
                  ),
                  TextSpan(
                    text: "Entertainment, ",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.saveSearchQuery("Entertainment");
                        controller.searchForTheTerm();
                      },
                  ),
                  const TextSpan(
                      text: "etc.",
                      style: TextStyle(fontWeight: FontWeight.normal))
                ])),
      )
    ]));
  }
}
