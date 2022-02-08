import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/suggestions_model.dart';

class SuggestionsApi {
  Future<SuggestionsModel> getSuggestionsApi(String query) async {
    final response = await http.get(
        Uri.parse(
            "https://webit-keyword-search.p.rapidapi.com/autosuggest?q=$query&language=en"),
        headers: {
          'x-rapidapi-host': 'webit-keyword-search.p.rapidapi.com',
          'x-rapidapi-key': '70bfea94e6msh12cf39772a4db46p1991c1jsn008a8d80df0e'
        });

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return SuggestionsModel.fromJson(result);
    } else {
      throw Exception('Failed to load any suggestions');
    }
  }
}
