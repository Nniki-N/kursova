
/// A class that represents general data of Nominatim API's response for location details.
class NominatimResponseModel {
  final String? city;
  final String? neighbourhood;
  final String? road;
  final String? houseNumber;
  final String? countryCode;
  final double latitude;
  final double longitude;

  NominatimResponseModel({
    required this.city,
    required this.neighbourhood,
    required this.road,
    required this.houseNumber,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });
}
