import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import '../models/wallpaper_model.dart';
import '../services/wallpaper_api.dart';

class Controller extends GetxController {
  @override
  void onInit() {
    getWallpaperData(searchQuery.value, pageNumber.value);
    super.onInit();
  }

  var pageNumber = 1.obs;
  var searchQuery = "Nature".obs;
  var isLoadingHomePageItems = false.obs;

  List<WallpaperModel>? items;
  Future<List<WallpaperModel>>? wallpaperData;

  searchForTheTerm() {
    items!.clear();
    items = null;
    pageNumber.value = 1;
    getWallpaperData(searchQuery.value, pageNumber.value);
  }

  loadMore() {
    debugPrint("Load More");
    changePageNumber();
    debugPrint(pageNumber.value.toString());
    getWallpaperData(searchQuery.value, pageNumber.value);
  }

  loadingItems(bool val) {
    isLoadingHomePageItems.value = val;
  }

  addItemsToList(List<WallpaperModel> data) {
    if (items == null) {
      debugPrint("Assigning data to list");
      items = data;
    } else {
      debugPrint("Adding data to list");
      items!.addAll(data);
    }
  }

  changePageNumber() {
    pageNumber.value = pageNumber.value + 1;
  }

  saveSearchQuery(val) {
    searchQuery.value = val;
  }

  getWallpaperData(String query, int pageNumber) {
    wallpaperData = WallpaperApi().getWallpaperForHome(query, pageNumber);
  }
}
