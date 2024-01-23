class Urls {
  int id;
  String uri;

  Urls(this.id, this.uri);

  factory Urls.fromJSON(Map<String, dynamic> parsedJson) {
    return Urls(
      parsedJson['id'],
      parsedJson['uri'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uri': uri,
    };
  }
}

class Tracks {
  String position;
  String type;
  String title;
  String duration;

  Tracks(this.position, this.type, this.title, this.duration);

  factory Tracks.fromJSON(Map<String, dynamic> parsedJson) {
    return Tracks(
      parsedJson['position'],
      parsedJson['type_'],
      parsedJson['title'],
      parsedJson['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'type_': type,
      'title': title,
      'duration': duration,
    };
  }
}

class Discogs {
  String country;
  int id;
  String type;
  int masterID;
  String masterURL;
  String uri;
  String catno;
  String title;
  String thumb;
  String coverImage;
  String resourceURL;
  int formatQuantity;
  List<Urls> urls;
  int len;
  List<Tracks> tracks;

  Discogs(
      this.country,
      this.id,
      this.type,
      this.masterID,
      this.masterURL,
      this.uri,
      this.catno,
      this.title,
      this.thumb,
      this.coverImage,
      this.resourceURL,
      this.formatQuantity,
      this.urls,
      this.len,
      this.tracks);

  bool isInteger(num value) => value is int || value == value.roundToDouble();

  factory Discogs.fromJSON(Map<String, dynamic> parsedJson) {
    List<Urls> urls = [];
    if (parsedJson['urls'] == null) {
      parsedJson['urls'] = [];
    }
    for (int i = 0; i < parsedJson['urls'].length; i++) {
      urls.add(Urls.fromJSON(parsedJson['urls'][i]));
    }

    List<Tracks> tracks = [];
    if (parsedJson['tracks'] == null) {
      parsedJson['tracks'] = [];
    }
    for (int i = 0; i < parsedJson['tracks'].length; i++) {
      tracks.add(Tracks.fromJSON(parsedJson['tracks'][i]));
    }

    parsedJson['id'] == "" ? parsedJson['id'] = 0 : parsedJson['id'];

    if (parsedJson['id'] is String) {
      parsedJson['id'] = int.parse(parsedJson['id']);
    }

    return Discogs(
      parsedJson['country'] ?? "",
      parsedJson['id'] ?? 0,
      parsedJson['type'] ?? "",
      parsedJson['master_id'] ?? 0,
      parsedJson['master_url'] ?? "",
      parsedJson['uri'] ?? "",
      parsedJson['catno'] ?? "",
      parsedJson['title'] ?? "",
      parsedJson['thumb'] ?? "",
      parsedJson['cover_image'] ?? "",
      parsedJson['resource_url'] ?? "",
      parsedJson['format_quantity'] ?? 0,
      urls,
      parsedJson['len'] ?? 0,
      tracks,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> urlsMap = [];
    for (int i = 0; i < urls.length; i++) {
      urlsMap.add(urls[i].toJson());
    }

    List<Map<String, dynamic>> tracksMap = [];
    for (int i = 0; i < tracks.length; i++) {
      tracksMap.add(tracks[i].toJson());
    }

    return {
      'country': country,
      'id': id,
      'type': type,
      'master_id': masterID,
      'master_url': masterURL,
      'uri': uri,
      'catno': catno,
      'title': title,
      'thumb': thumb,
      'cover_image': coverImage,
      'resource_url': resourceURL,
      'format_quantity': formatQuantity,
      'urls': urlsMap,
      'len': len,
      'tracks': tracksMap,
    };
  }
}
