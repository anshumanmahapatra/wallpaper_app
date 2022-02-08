class SuggestionsModel {
  final List data;

  SuggestionsModel({
    required this.data,
  });

  factory SuggestionsModel.fromJson(Map json) {
    return SuggestionsModel(data: json['data']['results']);
  }
}
