import 'package:latlong2/latlong.dart';

enum LocationType {
  currentLocation,
  locationOnMap,
  locationFromSearch,
}

class Location {
  final String uid;
  final String primaryLocationName;
  final String? detailedLocationAddress;
  final LatLng coordinate;
  final LocationType locationType;

  Location({
    required this.uid,
    required this.primaryLocationName,
    required this.detailedLocationAddress,
    required this.coordinate,
    required this.locationType,
  });

  Location copyWith({
    String? uid,
    String? primaryLocationName,
    String? detailedLocationAddress,
    LatLng? coordinate,
    LocationType? locationType,
  }) {
    return Location(
      uid: uid ?? this.uid,
      primaryLocationName: primaryLocationName ?? this.primaryLocationName,
      detailedLocationAddress:
          detailedLocationAddress ?? this.detailedLocationAddress,
      coordinate: coordinate ?? this.coordinate,
      locationType: locationType ?? this.locationType,
    );
  }

  @override
  String toString() {
    return 'Location(uid: $uid, primaryLocationName: $primaryLocationName, detailedLocationAddress: $detailedLocationAddress, coordinate: $coordinate, locationType: $locationType)';
  }
}
