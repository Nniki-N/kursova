import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  /// Returns current location of the device.
  Future<LatLng> getCurrentPosition() async {
    final Position position = await Geolocator.getCurrentPosition();

    return LatLng(
      position.latitude,
      position.longitude,
    );
  }

  /// Checks if location services are enabled on the device.
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }
}
