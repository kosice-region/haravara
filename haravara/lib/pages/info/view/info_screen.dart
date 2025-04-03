import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/close_button.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/core/widgets/header.dart';

import '../../../router/router.dart';

class InfoScreen extends StatelessWidget {
  InfoScreen({super.key});

  final List<String> imageAssets = [
    'assets/backgrounds/background_news.png',
    'assets/company-logo/KRT_bw_sk.jpg',
    'assets/company-logo/T_logo_rgb_k.png',
    'assets/company-logo/T_logo_rgb_n.png',
    'assets/company-logo/T_logo_rgb_p.png',
    'assets/logo-haravara.png'
  ];

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/backgrounds/pozadie8.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              const Header(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'O APLIKÁCII',
                    style: GoogleFonts.titanOne(
                      fontSize: 15.sp,
                      color: const Color(0xFFF94040),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      color: Colors.white54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Vaša obľúbená zberateľská súťaž pokračuje so starými pravidlami, ale v novom formáte. '
                              'Dreveným pečiatkam je koniec, vďaka spolupráci s Kaškovými kamarátmi z DT IT Solutions Slovakia ste práve vstúpili '
                              'do novej, farebnej a veselej aplikácie Haravara pátračka! Pečiatky odteraz môžete zbierať hravo v mobile, kde na vás '
                              'okrem miest s ukrytými pečiatkami čaká aj vlastný zberateľský profil a rebríček všetkých pátračov, v ktorom si prehľadne '
                              'môžete sledovať svoje skóre. Registrujte sa ako pátrač jednotlivec alebo ako celá rodina, vydajte sa pátrať po pečiatkach '
                              'dobrého ducha Kaška a súťažte o vecné ceny, ako aj zážitky v kraji!',
                              style: GoogleFonts.titanOne(
                                fontSize: 10.sp,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 60.w,
                                  height: 60.h,
                                  child: Image.asset(
                                    'assets/company-logo/KSK_logo_hor_ver.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Container(
                                  width: 80.w,
                                  height: 80.h,
                                  child: Image.asset(
                                    'assets/company-logo/KRT_bw_sk-removebg.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Container(
                                  width: 30.w,
                                  height: 30.h,
                                  child: Image.asset(
                                    imageAssets[4],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 35.h,
            right: 30.w,
            child: Close_Button(screenType: ScreenType.news),
          ),
        ],
      ),
      bottomNavigationBar: Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}
