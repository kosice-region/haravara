import 'dart:convert';

import 'package:haravara/pages/auth/models/autocomplete_production.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
          ? List<AutocompletePrediction>.from(
              json['predictions']
                  .map((x) => AutocompletePrediction.fromJson(x)),
            )
          : null,
    );
  }

  static PlaceAutocompleteResponse parseAutocompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}
