import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:wo_form/wo_form.dart';

class PlaceRepositoryImpl extends PlaceRepository {
  PlaceRepositoryImpl() {
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

  @override
  Future<PlaceDetailsResponse> getPlaceDetails(String placeId) => _callable
      .httpsCallable('requestedPlaceDetails')
      .call<Map<String, dynamic>>({'placeId': placeId}).then(
          (response) => PlaceDetailsResponse.fromJson(response.data));
}
