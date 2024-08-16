import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryItem extends StatelessWidget {
  const SummaryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 0.85.sw,
          maxHeight: 250.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          color: const Color.fromARGB(150, 255, 93, 93),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(150, 255, 93, 93).withOpacity(0.7),
              spreadRadius: 4.r,
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(19.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 249, 64, 64),
                    ),
                    radius: Radius.circular(10.r),
                    thickness: MaterialStateProperty.all(8.w),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: SingleChildScrollView(
                        child: Text(
                          'Pátračka po Kaškovych pečiatkach funguje veľmi jednoducho. Stačí si stiahnuť aplikáciu Haravara Pátračka, zaregistrovať sa pod '
                          'svojim špeciálnym pátračským menom a môžeš vyraziť na dobrodružnú túru po krajine Haravara! '
                          'K tomu, aby si nezišiel z cesty, ti bude pomáhať Kaškov kompas, ktorý ťa bude navigovať k presnému miestu, '
                          'kde môžeš získať jednu z jeho pečiatok. V sekcii "Rebríček" si môžeš sledovať, na akej úrovni zberateľstva '
                          'sa práve nachádzaš medzi ostatnými pátračmi. Výhra ťa neminie za každých 15 pečiatok! Ak získaš 30 a viac pečiatok, '
                          'budeš zaradený do žrebovania o skvelý zážitok v kraji!',
                          style: GoogleFonts.titanOne(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
