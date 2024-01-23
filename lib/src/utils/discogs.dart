import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/album.dart';
import '../models/discogs.dart';

class DiscogsAPI {
  final tokenDiscogs = dotenv.get("DISCOGS_TOKEN");

  Future<http.Response> discogsRequest(queryParameters) async {
    return await http
        .get(
          Uri.https('api.discogs.com', '/database/search', queryParameters),
        )
        .timeout(const Duration(seconds: 30));
  }

  Future<List<Tracks>> getTracks(Discogs data) async {
    final tracks = await http
        .get(
          Uri.https('api.discogs.com', '/${data.type}s/${data.id}'),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    final result = jsonDecode(utf8.decode(tracks.bodyBytes))["tracklist"];

    List<Tracks> tracksList = [];

    for (var i = 0; i < result.length; i++) {
      tracksList.add(
        Tracks.fromJSON(result[i]),
      );
    }
    return tracksList;
  }

  Future<Discogs> get(Album album) async {
    final queryParameters = {
      "token": tokenDiscogs,
      "artist": album.artist,
      "release_title": album.title,
      "barcode": album.barcode,
      "year": album.releaseYear.toString()
    };
    queryParameters.removeWhere((key, value) => value.isEmpty);

    final response = await discogsRequest(queryParameters);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)["results"];

      if (data.isEmpty) {
        final queryParametersFiltered = {
          "token": tokenDiscogs,
          "artist": album.artist,
          "release_title": album.title,
        };
        final responseFiltered = await discogsRequest(queryParametersFiltered);
        var dataFiltered =
            jsonDecode(responseFiltered.body)["results"];
        if (dataFiltered.isEmpty) {
          return Discogs.fromJSON({});
        }
        data = dataFiltered;
      }
      Discogs discogsData = Discogs.fromJSON(data[0]);

      discogsData.urls = [];
      discogsData.len = data.length;

      for (var i = 0; i < data.length; i++) {
        discogsData.urls.add(
          Urls(data[i]["id"], data[i]["uri"]),
        );
      }

      discogsData.tracks = await getTracks(discogsData);

      return discogsData;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
