import '../models/wallpaper_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WallpaperApi {
  Future<List<WallpaperModel>> getWallpaperForHome(
      String query, int pageNumber) async {
    final response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=20&page=$pageNumber"),
        headers: {
          'Authorization':
              '563492ad6f9170000100000167196385141144e0ab5afb00b20456f1'
        });

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      List wallpaperDetails = result['photos'];
      return WallpaperModel.getWallpaperDetails(wallpaperDetails);
    } else {
      throw Exception('Sorry we could not fetch your query');
    }
  }
}
