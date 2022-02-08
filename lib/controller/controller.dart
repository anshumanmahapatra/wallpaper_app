import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:wallpaper_app/services/suggestions_api.dart';
import '../models/wallpaper_model.dart';
import '../models/suggestions_model.dart';
import '../services/wallpaper_api.dart';
import '../services/storage.dart';

class Controller extends GetxController {
  @override
  void onInit() {
    if (box.read('controller') == 0 || !box.hasData('controller')) {
      box.write('controller', 0);
      box.write('clearSearch', false);
      clearSearch.value = false;
    } else {
      box.write('clearSearch', true);
      clearSearch.value = true;
    }
    getWallpaperData(searchQuery.value, pageNumber.value);
    super.onInit();
  }

  var pageNumber = 1.obs;
  var searchQuery = "Nature".obs;
  var isLoadingHomePageItems = false.obs;
  var onChangedNumber = 0.obs;
  var clearSearch = false.obs;

  List<WallpaperModel>? items;
  Future<List<WallpaperModel>>? wallpaperData;
  Future<SuggestionsModel>? suggestionsData;

  addRecentSearch(String searchTerm) {
    for (int i1 = 0; i1 <= 10; i1++) {
      if (box.read('controller') < 10) {
        if (box.read('controller') == i1) {
          box.write('${i1 + 1}', searchTerm);
          box.write('controller', i1 + 1);
          break;
        }
      } else {
        for (int i2 = 1; i2 < 10; i2++) {
          box.write('$i2', box.read('${i2 + 1}'));
        }
        box.write('10', searchTerm);
        break;
      }
    }
  }

  clearRecentSearch() {
    box.erase();
    box.write('controller', 0);
    box.write('clearSearch', false);
    clearSearch.value = false;
  }

  searchForTheTerm() {
    items!.clear();
    items = null;
    pageNumber.value = 1;
    box.write('clearSearch', true);
    getWallpaperData(searchQuery.value, pageNumber.value);
  }

  setClearSearch() {
    clearSearch.value = true;
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

  getSuggestionsData(String query) {
    suggestionsData = SuggestionsApi().getSuggestionsApi(query);
  }

  updateOnChangedNumber() {
    onChangedNumber.value = onChangedNumber.value + 1;
  }

  resetOnChangedNumber() {
    onChangedNumber.value = 0;
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
