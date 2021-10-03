class WallpaperModel {
  final String photographer;
  final String tinyImgUrl;
  final String largeImgUrl;

  WallpaperModel(
      {required this.photographer,
      required this.tinyImgUrl,
      required this.largeImgUrl});

  factory WallpaperModel.fromJson(Map json) {
    return WallpaperModel(
      photographer: json['photographer'],
      tinyImgUrl: json['src']['tiny'],
      largeImgUrl: json['src']['large2x'],
    );
  }

  static List<WallpaperModel> getWallpaperDetails(List data) {
    return data.map((e) => WallpaperModel.fromJson(e)).toList();
  }
}
