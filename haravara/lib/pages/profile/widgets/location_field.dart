import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haravara/pages/auth/models/autocomplete_production.dart';
import 'package:haravara/pages/auth/models/place_auto_complate_response.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';

final dio = Dio();

class LocationField extends ConsumerStatefulWidget {
  final ValueChanged<String> onLocationSelected;
  const LocationField({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  ConsumerState<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends ConsumerState<LocationField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<AutocompletePrediction> preds = [];
  String? _savedLocation;

  @override
  void initState() {
    super.initState();
    _loadLocationFromPrefs();
  }

  Future<void> _loadLocationFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getString('userLocation') ?? '';
    if (location.isNotEmpty) {
      final parts = location.split(',');
      final city = parts.isNotEmpty ? "" : "";
      setState(() {
        _savedLocation = city;
        _controller.text = city;
      });
    }
  }

  void _showOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> autocomplete(String query) async {
    if (query.isEmpty) {
      setState(() => preds.clear());
      _showOverlay();
      return;
    }
    final response = await dio.get(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      queryParameters: {
        'input': query,
        'key': 'AIzaSyAxCBF1tTD9zqryMa7j-AWxDwdLpOTQcN8',
      },
    );
    final placeResponse =
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
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
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
                color: const Color.fromARGB(255, 188, 95, 190),
                width: 2,
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 150.h),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: preds.map((suggestion) {
                  return ListTile(
                    title: Text(
                      suggestion.description!,
                      style: GoogleFonts.titanOne(
                          color: const Color.fromARGB(255, 188, 95, 190)),
                    ),
                    onTap: () async {
                      _controller.text = suggestion.description!;
                      await _saveLocationToPrefs(suggestion.description!);
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

  Future<void> _saveLocationToPrefs(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userLocation', location);
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
    final rawLocation = ref.watch(userInfoProvider).location;
    final processedLocation = rawLocation.split(',').first.trim();
    final savedLoc = _savedLocation?.split(',').first.trim() ?? '';
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        autocorrect: true,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.none,
        style: GoogleFonts.titanOne(
          color: const Color.fromARGB(255, 188, 95, 190),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: processedLocation.isNotEmpty
              ? processedLocation
              : (savedLoc.isNotEmpty ? savedLoc : "Odkiaľ si?"),
          hintStyle: GoogleFonts.titanOne(
            color: const Color.fromARGB(255, 188, 95, 190),
            fontWeight: FontWeight.w300,
            fontSize: 11.sp,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SvgPicture.asset(
              "assets/icons/location_pin.svg",
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(255, 188, 95, 190),
                BlendMode.srcIn,
              ),
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 188, 95, 190),
              width: 3,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 188, 95, 190),
              width: 3,
            ),
          ),
        ),
        textInputAction: TextInputAction.search,
        onChanged: autocomplete,
      ),
    );
  }
}
