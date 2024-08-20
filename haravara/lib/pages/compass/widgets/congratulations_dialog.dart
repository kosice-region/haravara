import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CongratulationsDialog extends StatelessWidget {
  final String pickedPlaceName;

  const CongratulationsDialog({required this.pickedPlaceName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = screenHeight / 2.3;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: containerHeight,
            width: 224.w,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 140, 192, 225),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                12.verticalSpace,
                Text(
                  'GRATULUJEME!',
                  style: GoogleFonts.titanOne(
                      color: Colors.black, fontSize: 20.sp),
                ),
                12.verticalSpace,
                Text(
                  'Dosiahli ste',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.titanOne(
                    color: Colors.black,
                    fontSize: 15.sp,
                  ),
                ),
                5.verticalSpace,
                Text(
                  pickedPlaceName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.titanOne(
                      color: Colors.black, fontSize: 15.sp),
                ),
                30.verticalSpace,
                Container(
                  width: 100.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 22, 102, 177),
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                  child: TextButton(
                    child: Text(
                      'Získať pečiatku',
                      style: GoogleFonts.titanOne(
                        color: Colors.white,
                        fontSize: 15.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
