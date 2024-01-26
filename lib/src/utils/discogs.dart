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
        var dataFiltered = jsonDecode(responseFiltered.body)["results"];
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

  Future<Discogs> getById(String discogsId) async {
    final queryParameters = {
      "token": tokenDiscogs,
    };
    try {
      discogsId = discogsId.replaceAll(RegExp(r'[^0-9]'), '');

      final response = await http
          .get(
            Uri.https(
                'api.discogs.com', '/releases/$discogsId', queryParameters),
          )
          .timeout(const Duration(seconds: 30));

      var data = jsonDecode(response.body);

      if (data["message"] != null) {
        throw Exception(data["message"]);
      }

      Discogs discogsData = Discogs(
        data["country"] ?? "",
        data["id"] ?? 0,
        data["type"] ?? "",
        data["master_id"] ?? 0,
        data["master_url"] ?? "",
        data["uri"] ?? "",
        data["catno"] ?? "",
        data["title"] ?? "",
        data["thumb"] ?? "",
        data["images"][0]["uri"] ?? "",
        data["resource_url"] ?? "",
        data["format_quantity"] ?? 0,
        [],
        1,
        [],
      );

      discogsData.urls = [
        Urls(
          data["id"],
          "/release${data["uri"].substring(data["uri"].lastIndexOf("/"))}",
        )
      ];

      for (var i = 0; i < data["tracklist"].length; i++) {
        discogsData.tracks.add(
          Tracks.fromJSON(data["tracklist"][i]),
        );
      }

      return discogsData;
    } catch (e) {
      return Discogs.fromJSON({});
    }
  }
}
