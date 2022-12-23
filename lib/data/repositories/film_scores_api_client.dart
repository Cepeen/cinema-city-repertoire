import 'package:dio/dio.dart';

import './api_client.dart';

class FilmScoresApiClient extends ApiClient {
  final Dio client;

  FilmScoresApiClient({required this.client});

  static const String filmWebBaseUrl = 'https://www.filmweb.pl/api/v1';

  Future<int> getFilmId(String filmName) async {
    var response = await client.get(
      "$filmWebBaseUrl/live/search?query=${Uri.encodeComponent(filmName.toLowerCase())}",
    );

    return response.data['searchHits'][0]['id'];
  }

  Future<String> getFilmScore(int filmId) async {
    var response = await client.get(
      '$filmWebBaseUrl/film/$filmId/rating',
    );

    return response.data['rate'].toString().substring(0, 3);
  }
}
