class Spotify {
  String albumType;
  Map<String, dynamic> externalUrls;
  String href;
  String id;
  List<dynamic> images;
  String name;
  String releaseDate;
  String releaseDatePrecision;
  int totalTracks;
  String type;
  String uri;

  Spotify(
      this.albumType,
      this.externalUrls,
      this.href,
      this.id,
      this.images,
      this.name,
      this.releaseDate,
      this.releaseDatePrecision,
      this.totalTracks,
      this.type,
      this.uri);

  factory Spotify.fromJSON(Map<String, dynamic> parsedJson) {
    return Spotify(
      parsedJson['albumType'] ?? "",
      parsedJson['external_urls'] ?? {},
      parsedJson['href'] ?? "",
      parsedJson['id'] ?? "",
      parsedJson['images'] ?? [],
      parsedJson['name'] ?? "",
      parsedJson['release_date'] ?? "",
      parsedJson['release_date_precision'] ?? "",
      parsedJson['total_tracks'] ?? 0,
      parsedJson['type'] ?? "",
      parsedJson['uri'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'albumType': albumType,
      'external_urls': externalUrls,
      'href': href,
      'id': id,
      'images': images,
      'name': name,
      'release_date': releaseDate,
      'release_date_precision': releaseDatePrecision,
      'total_tracks': totalTracks,
      'type': type,
      'uri': uri,
    };
  }
}
