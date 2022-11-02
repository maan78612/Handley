class Location {
 late double lat;
 late double long;

  Location({required this.lat, required this.long});

  Location.fromJson(dynamic json) {
    lat = json["lat"];
    long = json["long"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["lat"] = lat;
    map["long"] = long;
    return map;
  }
}