import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/widgets/close_button.dart';
import 'package:haravara/core/widgets/footer.dart';

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/pozadie8.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'O aplikácii',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                      color: Colors.white54,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            width: 100.w,
                            height: 100.h,
                            child: Image.asset(
                              'assets/company-logo/KRT_bw_sk-removebg.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            width: 40.w,
                            height: 40.h,
                            child: Image.asset(
                              imageAssets[4],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 43.h,
                right: 30.w,
                child: Close_Button(screenType: ScreenType.news,),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}