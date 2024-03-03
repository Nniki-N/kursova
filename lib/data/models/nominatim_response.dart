class NominatimResponse {
  final String? city;
  final String? neighbourhood;
  final String? road;
  final String? houseNumber;
  final String? countryCode;
  final double latitude;
  final double longitude;

  NominatimResponse({
    required this.city,
    required this.neighbourhood,
    required this.road,
    required this.houseNumber,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });
}
