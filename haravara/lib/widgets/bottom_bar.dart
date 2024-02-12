// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:haravara/models/place.dart';
// import 'package:flutter/widgets.dart' as Flutter;
// import 'package:map_launcher/map_launcher.dart';
// import 'package:flutter/cupertino.dart';

// class BottomBar extends StatefulWidget {
//   const BottomBar({
//     super.key,
//     required this.onPressed,
//     required this.place,
//   });
//   final Place place;
//   final void Function() onPressed;

//   @override
//   State<BottomBar> createState() => _BottomBarState();
// }

// class _BottomBarState extends State<BottomBar> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   lauchMap() async {
//     MapType map = MapType.apple;
//     bool isMapSelected = true;

//     if (Platform.isIOS) {
//       await showCupertinoModalPopup(
//         context: context,
//         builder: (BuildContext context) => CupertinoActionSheet(
//           title: const Text('Choose Map'),
//           actions: <Widget>[
//             CupertinoActionSheetAction(
//               child: const Text('Google Maps'),
//               onPressed: () {
//                 Navigator.pop(context, 'Google Maps');
//                 map = MapType.google;
//               },
//             ),
//             CupertinoActionSheetAction(
//               child: const Text('Apple Maps'),
//               onPressed: () {
//                 Navigator.pop(context, 'Apple Maps');
//                 map = MapType.apple;
//               },
//             ),
//           ],
//           cancelButton: CupertinoActionSheetAction(
//             isDefaultAction: true,
//             onPressed: () {
//               Navigator.pop(context, 'Cancel');
//               isMapSelected = false;
//             },
//             child: const Text('Cancel'),
//           ),
//         ),
//       );
//     }
//     if (isMapSelected) {
//       await MapLauncher.showMarker(
//         mapType: map,
//         coords: Coords(widget.place.geoData.primary.coordinates[0],
//             widget.place.geoData.primary.coordinates[1]),
//         title: widget.place.name,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, designSize: const Size(255, 516));
//     return showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SizedBox();
//       },
//     );
//   }
// }
