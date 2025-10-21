// Credits : https://pub.dev/packages/google_places_flutter

enum PlaceType {
  geocode('geocode'),
  address('address'),
  establishment('establishment'),
  region('(region)'), // TODO : Broken ?
  cities('(cities)');

  const PlaceType(this.apiString);

  final String apiString;
}
