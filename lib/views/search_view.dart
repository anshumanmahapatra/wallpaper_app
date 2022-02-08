import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/suggestions_model.dart';
import '../services/storage.dart';
import '../controller/controller.dart';
import '../constants/color_constant.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorConstant colorConstant = Get.put(ColorConstant());
    Controller controller = Get.put(Controller());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SafeArea(
        child: Scaffold(
            body: Container(
      color: colorConstant.kPrimary,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            color: colorConstant.kSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: Get.mediaQuery.size.width,
            height: 60,
            child: Form(
              key: formKey,
              child: TextFormField(
                controller:
                    TextEditingController(text: controller.searchQuery.value),
                style: TextStyle(color: colorConstant.secondaryTextColor),
                cursorColor: colorConstant.secondaryTextColor,
                textInputAction: TextInputAction.search,
                autofocus: true,
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
                          controller.resetOnChangedNumber();
                          controller
                              .addRecentSearch(controller.searchQuery.value);
                          controller.setClearSearch();
                          Get.back();
                        }
                      }),
                ),
                onChanged: (val) {
                  controller.updateOnChangedNumber();
                  if (val != "") {
                    controller.getSuggestionsData(val);
                    controller.suggestionsData!.then((value) {
                      debugPrint(value.data.toString());
                    });
                  } else {
                    controller.resetOnChangedNumber();
                  }
                },
                onSaved: (val) {
                  controller.saveSearchQuery(val!);
                },
                onFieldSubmitted: (val) {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    controller.searchForTheTerm();
                    controller.resetOnChangedNumber();
                    controller.addRecentSearch(controller.searchQuery.value);
                    controller.setClearSearch();
                    Get.back();
                  }
                },
                validator: (val) {
                  int i;
                  int count = 0;
                  for (i = 0; i < val!.length; i++) {
                    if (val.substring(i, i + 1) == " ") {
                      count = count + 1;
                    }
                  }
                  debugPrint(count.toString());
                  if (count == val.length) {
                    return 'Please enter something';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        Obx(() {
          if (controller.onChangedNumber.value > 0) {
            return Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: Text(
                      "Suggestions",
                      style: TextStyle(color: colorConstant.secondaryTextColor),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<SuggestionsModel>(
                        future: controller.suggestionsData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            if (snapshot.hasError) {
                              debugPrint("Error Occured");
                              return Container();
                            } else {
                              return ListView.builder(
                                  itemCount: snapshot.data!.data.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Icon(Icons.search,
                                          color:
                                              colorConstant.primaryTextColor),
                                      title: Text(
                                        snapshot.data!.data.elementAt(index),
                                        style: TextStyle(
                                            color:
                                                colorConstant.primaryTextColor),
                                      ),
                                      onTap: () {
                                        controller.saveSearchQuery(snapshot
                                            .data!.data
                                            .elementAt(index));
                                        controller.searchForTheTerm();
                                        controller.resetOnChangedNumber();
                                        controller.addRecentSearch(
                                            controller.searchQuery.value);
                                        controller.setClearSearch();
                                        Get.back();
                                      },
                                    );
                                  });
                            }
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            debugPrint("Waiting for Suggestions");
                            return Container();
                          } else {
                            debugPrint("Got nothing");
                            return Container();
                          }
                        }),
                  ),
                ],
              ),
            );
          } else {
            return Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: Text(
                      controller.clearSearch.value == true
                          ? "Recent Searches"
                          : "No Recent Searches",
                      style: TextStyle(color: colorConstant.secondaryTextColor),
                    ),
                    trailing: InkWell(
                        child: Text(
                          "Clear Searches",
                          style: TextStyle(
                              color: controller.clearSearch.value == true
                                  ? colorConstant.primaryTextColor
                                  : colorConstant.kPrimary),
                        ),
                        onTap: controller.clearSearch.value == true
                            ? () {
                                controller.clearRecentSearch();
                              }
                            : null),
                  ),
                  controller.clearSearch.value == true
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: box.read('controller') == 0
                                  ? 1
                                  : box.read('controller'),
                              itemBuilder: (context, index) {
                                if (box.read('controller') == 0) {
                                  return Container();
                                } else {
                                  return ListTile(
                                    leading: Icon(
                                      Icons.history_sharp,
                                      color: colorConstant.primaryTextColor,
                                    ),
                                    title: Text(
                                      box.read(
                                          '${box.read('controller') - index}'),
                                      style: TextStyle(
                                          color:
                                              colorConstant.primaryTextColor),
                                    ),
                                    onTap: () {
                                      controller.saveSearchQuery(box.read(
                                          '${box.read('controller') - index}'));
                                      controller.searchForTheTerm();
                                      controller.resetOnChangedNumber();
                                      controller.addRecentSearch(
                                          controller.searchQuery.value);
                                      controller.setClearSearch();
                                      Get.back();
                                    },
                                  );
                                }
                              }),
                        )
                      : Container()
                ],
              ),
            );
          }
        }),
      ]),
    )));
  }
}
