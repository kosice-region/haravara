class AutocompletePrediction {
  final String? description;
  final List<String>? types;
  final StructuredFormatting? structuredFormatting;

  AutocompletePrediction(
      {this.description, this.types, this.structuredFormatting});

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      types: json['types'] != null ? List<String>.from(json['types']) : null,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}
