import '../models/discogs.dart';
import '../models/spotify.dart';
import 'package:intl/intl.dart';

class Discs {
  String discNumber;
  String weight;
  List<String> matriz;

  Discs(this.discNumber, this.weight, this.matriz);

  factory Discs.fromJSON(Map<String, dynamic> parsedJson) {
    return Discs(
      parsedJson['discNumber'] ?? "",
      parsedJson['weight'] ?? "",
      List<String>.from(parsedJson['matriz'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discNumber': discNumber,
      'weight': weight,
      'matriz': matriz,
    };
  }
}

class Album {
  String id;
  int releaseYear;
  String artist;
  String title;
  String media;
  String purchase;
  String origin;
  int editionYear;
  String ifpiMastering;
  String ifpiMould;
  String barcode;
  String matriz;
  String lote;
  Discogs discogs;
  Spotify spotify;
  String obs;
  List<Discs> discs;

  Album(
    this.id,
    this.releaseYear,
    this.artist,
    this.title,
    this.media,
    this.purchase,
    this.origin,
    this.editionYear,
    this.ifpiMastering,
    this.ifpiMould,
    this.barcode,
    this.matriz,
    this.lote,
    this.discogs,
    this.spotify,
    this.obs,
    this.discs,
  );

  factory Album.fromJSON(Map<String, dynamic> parsedJson) {
    return Album(
      parsedJson['id'] ?? "",
      parsedJson['releaseYear'] ?? 0,
      parsedJson['artist'] ?? "",
      parsedJson['title'] ?? "",
      parsedJson['media'] ?? "",
      parsedJson['purchase'] ?? "",
      parsedJson['origin'] ?? "",
      parsedJson['editionYear'] ?? 0,
      parsedJson['ifpiMastering'] ?? "",
      parsedJson['ifpiMould'] == null ? "" :parsedJson['ifpiMould'].toString(),
      parsedJson['barcode'] ?? "",
      parsedJson['matriz'] ?? "",
      parsedJson['lote'] ?? "",
      Discogs.fromJSON(parsedJson['discogs'] ?? {}),
      Spotify.fromJSON(parsedJson['spotify'] ?? {}),
      parsedJson['obs'] ?? "",
      List<Discs>.from(
        parsedJson['discs'] != null
            ? parsedJson['discs'].map((disc) => Discs.fromJSON(disc)) ?? []
            : [],
      ),
    );
  }

  // serialize to json
  Map<String, dynamic> toJson() {
    String date = "";
    if (purchase != "") {
      try {
        date = DateFormat('yyyy-MM-dd')
            .format(DateFormat('dd/MM/yyyy').parse(purchase));
      } catch (e) {
        date = DateFormat('yyyy-MM-dd')
            .format(DateFormat('yyyy-MM-dd').parse(purchase));
      }
    }

    return {
      'id': id,
      'releaseYear': releaseYear,
      'artist': artist,
      'title': title,
      'media': media,
      'purchase': date,
      'origin': origin,
      'editionYear': editionYear,
      'ifpiMastering': ifpiMastering,
      'ifpiMould': ifpiMould,
      'barcode': barcode,
      'matriz': matriz,
      'lote': lote,
      'discogs': discogs.toJson(),
      'spotify': spotify.toJson(),
      'obs': obs,
      'discs': discs.map((disc) => disc.toJson()).toList(),
    };
  }
}
