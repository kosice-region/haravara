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
  final ValueChanged<String> onLocationSelected;
  const LocationField({
    Key? key,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<AutocompletePrediction> preds = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();
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
    Response response = await dio.get(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      queryParameters: {
        'input': query,
        'key': 'AIzaSyAxCBF1tTD9zqryMa7j-AWxDwdLpOTQcN8',
      },
    );
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
    preds.forEach((element) {
      log(element.structuredFormatting?.mainText.toString() ?? '');
      log(element.structuredFormatting?.secondaryText.toString() ?? '');
      log(element.types.toString());
      log(element.description.toString());
      log('------------------');
    });
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
                color: Colors.white,
                width: 2,
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 150),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: preds.map((suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.description!,
                      style: GoogleFonts.titanOne(
                        color: Color.fromARGB(255, 24, 191, 186),
                      ),
                    ),
                    onTap: () {
                      _controller.text = suggestion.description!;
                      _focusNode.unfocus();
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                      widget.onLocationSelected(suggestion.description!);
                    },
                  );
                }).toList(),
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
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166.w,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        autocorrect: true,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.none,
        style: GoogleFonts.titanOne(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: "ODKIAĽ SI?",
          hintStyle: GoogleFonts.titanOne(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 11.sp,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SvgPicture.asset(
              "assets/icons/location_pin.svg",
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 3,
            ),
          ),
        ),
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          autocomplete(value);
        },
      ),
    );
  }
}
