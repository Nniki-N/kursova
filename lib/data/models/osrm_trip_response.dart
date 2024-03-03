class OsrmTripResponse {
  OsrmTripResponse({
    required this.code,
    required this.trips,
    required this.waypoints,
  });

  final String code;
  final List<Trip> trips;
  final List<Waypoint> waypoints;

  factory OsrmTripResponse.fromJson(Map<String, dynamic> json) {
    return OsrmTripResponse(
      code: json['code'],
      trips: json['trips'] == null
          ? []
          : List<Trip>.from(json['trips']!.map((x) => Trip.fromJson(x))),
      waypoints: json['waypoints'] == null
          ? []
          : List<Waypoint>.from(
              json['waypoints']!.map((x) => Waypoint.fromJson(x))),
    );
  }
}

class Trip {
  Trip({
    required this.geometry,
    required this.legs,
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
  });

  final Geometry geometry;
  final List<Leg> legs;
  final String weightName;
  final double weight;
  final double duration;
  final double distance;

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      geometry: Geometry.fromJson(json['geometry']),
      legs: json['legs'] == null
          ? []
          : List<Leg>.from(json['legs']!.map((x) => Leg.fromJson(x))),
      weightName: json['weight_name'],
      weight: json['weight'],
      duration: json['duration'],
      distance: json['distance'],
    );
  }
}

class Geometry {
  Geometry({
    required this.coordinates,
    required this.type,
  });

  final List<List<double>> coordinates;
  final String type;

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      coordinates: json['coordinates'] == null
          ? []
          : List<List<double>>.from(json['coordinates']!.map(
              (x) => x == null ? [] : List<double>.from(x!.map((x) => x)))),
      type: json['type'],
    );
  }
}

class Leg {
  Leg({
    required this.steps,
    required this.summary,
    required this.weight,
    required this.duration,
    required this.distance,
  });

  final List<dynamic> steps;
  final String summary;
  final double weight;
  final double duration;
  final double distance;

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      steps: json['steps'] == null
          ? []
          : List<dynamic>.from(json['steps']!.map((x) => x)),
      summary: json['summary'],
      weight: json['weight'],
      duration: json['duration'],
      distance: json['distance'],
    );
  }
}

class Waypoint {
  Waypoint({
    required this.waypointIndex,
    required this.tripsIndex,
    required this.hint,
    required this.distance,
    required this.name,
    required this.location,
  });

  final int waypointIndex;
  final int tripsIndex;
  final String hint;
  final double distance;
  final String name;
  final List<double> location;

  factory Waypoint.fromJson(Map<String, dynamic> json) {
    return Waypoint(
      waypointIndex: json['waypoint_index'],
      tripsIndex: json['trips_index'],
      hint: json['hint'],
      distance: json['distance'],
      name: json['name'],
      location: json['location'] == null
          ? []
          : List<double>.from(json['location']!.map((x) => x)),
    );
  }
}
