import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:wo_form/wo_form.dart';
import 'package:wo_form_example/utils/place/place_details.dart';

class PlaceRepository with PlaceRepositoryMixin {
  PlaceRepository() {
    if (kDebugMode) _callable.useFunctionsEmulator('localhost', 5001);
  }
  final FirebaseFunctions _callable =
      FirebaseFunctions.instanceFor(region: 'europe-west1');

  @override
  Future<PlacesAutocompleteResponse> getPlacePredictions(String input) =>
      _callable
          .httpsCallable('requestedPlacePredictions')
          .call<Map<String, dynamic>>({'input': input}).then(
              (response) => PlacesAutocompleteResponse.fromJson(response.data));

  /// Your proxy for longitude and latitude of addresses.
  ///
  /// Do not implement this method if you don't need details of an address.
  ///
  /// The provided [placeId] is a string to add in the body. You also need
  /// to add you own google api key. Example :
  /// 'https://maps.googleapis.com/maps/api/place/details/json?key=${widget.googleAPIKey}&placeid=' + placeId
  Future<PlaceDetailsResponse> getPlaceDetails(String placeId) => _callable
      .httpsCallable('requestedPlaceDetails')
      .call<Map<String, dynamic>>({'placeId': placeId}).then(
          (response) => PlaceDetailsResponse.fromJson(response.data));
}
