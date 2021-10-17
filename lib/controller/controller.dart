import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Future cacheAllImage(BuildContext context) async {
    await Future.wait(
        items!.map((item) => cacheImage(context, item.tinyImgUrl)));
    await Future.wait(
        items!.map((item) => cacheImage(context, item.largeImgUrl)));
    debugPrint("Cached all Images");
  }

  Future cacheImage(BuildContext context, String urlImage) =>
      precacheImage(CachedNetworkImageProvider(urlImage), context);

  addItemsToList(BuildContext context, List<WallpaperModel> data) {
    if (items == null) {
      debugPrint("Assigning data to list");
      items = data;
      cacheAllImage(context);
    } else {
      debugPrint("Adding data to list");
      items!.addAll(data);
      cacheAllImage(context);
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

  Future<void> setWallpaper(int wallpaperType, String imgUrl) async {
     String? msg;
    try {
      int location;
      if (wallpaperType == 1) {
        location = WallpaperManager.HOME_SCREEN;
        msg = "Home Screen ";
      } else if (wallpaperType == 2) {
        location = WallpaperManager.LOCK_SCREEN;
        msg = "Lock Screen ";
      } else {
        location = WallpaperManager.BOTH_SCREEN;
        msg = "Home Screen and Lock Screen ";
      }
      var file = await DefaultCacheManager().getSingleFile(imgUrl);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      debugPrint(result.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    Fluttertoast.showToast(
        msg: msg! + "Wallpaper set successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
