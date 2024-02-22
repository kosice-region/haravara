import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/place.dart';

class Achievement extends StatelessWidget {
  const Achievement({
    super.key,
    this.isClosed = true,
    required this.place,
  });

  final Place place;
  final bool isClosed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isClosed)
          Container(
            width: 99.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(26)).r,
              color: const Color.fromARGB(255, 91, 187, 75),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.7,
                child: Image.asset('assets/Icon.jpeg', fit: BoxFit.fill),
              ),
            ),
          ),
        if (!isClosed)
          SizedBox(
            width: 140.w,
            height: 100.h,
            child: Image.file(
              File(place.placeImages!.stamp),
              fit: BoxFit.contain,
            ),
          ),
        5.verticalSpace,
        Container(
          width: 109.w,
          height: 36.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: const Color.fromARGB(255, 155, 221, 153)),
          child: Center(
            child: Text(
              place.name,
              style: GoogleFonts.titanOne(color: Colors.black, fontSize: 11.sp),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

//  return Column(
//       children: [
//         Container(
//           width: 99.w,
//           height: 100.h,
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(26)),
//             color: Color.fromARGB(255, 91, 187, 75),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Center(
//             child: FractionallySizedBox(
//               widthFactor: 0.5,
//               heightFactor: 0.7,
//               child: Image.asset('assets/Icon.jpeg', fit: BoxFit.fill),
//             ),
//           ),
//         ),
//       ],
//     );
//   }


//  5.verticalSpace,
//         FractionallySizedBox(
//           widthFactor: 1,
//           heightFactor: 0.1,
//           child: Container(
//             width: 10.w,
//             height: 1.h,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15.r),
//                 color: const Color.fromARGB(255, 155, 221, 153)),
//             child: Center(
//               child: Text(
//                 'Dom sv.Alzbety',
//                 style:
//                     GoogleFonts.titanOne(color: Colors.black, fontSize: 8.sp),
//                 maxLines: 2,
//               ),
//             ),
//           ),
//         ),
