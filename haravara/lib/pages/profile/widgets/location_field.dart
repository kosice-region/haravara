import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/auth/models/autocomplete_production.dart';
import 'package:haravara/pages/auth/models/place_auto_complate_response.dart';

final dio = Dio();

class LocationField extends StatefulWidget {
  const LocationField({
    super.key,
    required this.onLocationSelected,
  });
  final ValueChanged<String> onLocationSelected;

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<AutocompletePrediction> preds = [];

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> autocomplete(String query) async {
    if (query.isEmpty) {
      setState(() {
        preds.clear();
      });
      _showOverlay();
      return;
    }

    Response response;
    response = await dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': 'AIzaSyAxCBF1tTD9zqryMa7j-AWxDwdLpOTQcN8',
        });

    PlaceAutocompleteResponse placeResponse =
        PlaceAutocompleteResponse.parseAutocompleteResult(response.toString());

    if (placeResponse.predictions != null) {
      setState(() {
        preds = placeResponse.predictions!
            .where((prediction) =>
                prediction.structuredFormatting?.secondaryText
                    ?.contains('Slovakia') ??
                false)
            .where((prediction) =>
                prediction.types?.contains('political') ?? false)
            .where(
                (prediction) => prediction.types?.contains('geocode') ?? false)
            .toList();
      });
      _showOverlay();
    }
    preds.forEach(
      (element) {
        log(element.structuredFormatting?.mainText.toString() ?? '');
        log(element.structuredFormatting?.secondaryText.toString() ?? '');
        log(element.types.toString());
        log(element.description.toString());
        log('------------------');
      },
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color.fromARGB(255, 188, 95, 190),
                width: 2,
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 150.h,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: preds
                    .map(
                      (suggestion) => ListTile(
                        title: Text(
                          suggestion.description!,
                          style: GoogleFonts.titanOne(
                            color: Color.fromARGB(255, 188, 95, 190),
                          ),
                        ),
                        onTap: () {
                          _controller.text = suggestion.description!;
                          _focusNode.unfocus();
                          _overlayEntry?.remove();
                          _overlayEntry = null;
                          widget.onLocationSelected(suggestion.description!);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Adjust the width as needed
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        autocorrect: true,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.none,
        style: GoogleFonts.titanOne(
          color: Color.fromARGB(255, 188, 95, 190),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: "Odkiaľ si?",
          hintStyle: GoogleFonts.titanOne(
            color: Color.fromARGB(255, 188, 95, 190),
            fontWeight: FontWeight.w300,
            fontSize: 11.sp,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SvgPicture.asset(
              "assets/icons/location_pin.svg",
              color: Color.fromARGB(255, 188, 95, 190),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 188, 95, 190),
              width: 3.w,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 188, 95, 190),
              width: 3.w,
            ),
          ),
        ),
        textInputAction: TextInputAction.search,
        onChanged: (String value) {
          autocomplete(value);
        },
      ),
    );
  }
}
