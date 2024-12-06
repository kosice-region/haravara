import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';

class LevelsItems {
  LevelsItems(
      {required this.levelName,
      required this.stampsNumber,
      required this.isOpened,
      required this.levelColor,
      required this.profileIcons});

  String levelName;
  String stampsNumber;
  bool isOpened;
  int levelColor;
  List<String> profileIcons;
}

class LeaderBoardLevelsScreen extends StatefulWidget {
  const LeaderBoardLevelsScreen({Key? key}) : super(key: key);

  @override
  _LeaderBoardLevelsScreenState createState() =>
      _LeaderBoardLevelsScreenState();
}

class _LeaderBoardLevelsScreenState extends State<LeaderBoardLevelsScreen> {
  final List<String> imageAssets = [
    'assets/backgrounds/background.jpg',
    'assets/avatars/kasko.png',
  ];

  final List<LevelsItems> _levelsItems = [
    LevelsItems(
        levelName: 'Pro',
        stampsNumber: '60',
        isOpened: false,
        levelColor: 0xFF000000,
        profileIcons: [
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
        ]),
    LevelsItems(
        levelName: 'Pokrocily',
        stampsNumber: '30',
        isOpened: true,
        levelColor: 0xFFD22B35,
        profileIcons: [
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
        ]),
    LevelsItems(
        levelName: 'Middle',
        stampsNumber: '20',
        isOpened: true,
        levelColor: 0xFFFFB800,
        profileIcons: [
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
        ]),
    LevelsItems(
        levelName: 'Zaciatocnik',
        stampsNumber: '10',
        isOpened: true,
        levelColor: 0xFF49E500,
        profileIcons: [
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
        ]),
    LevelsItems(
        levelName: 'Starter',
        stampsNumber: '5',
        isOpened: true,
        levelColor: 0xFF00A3FF,
        profileIcons: [
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
          'assets/avatars/kasko.png',
        ]),
  ];
  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          // Background layer
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/background.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment
                    .centerRight, // Focuses on the right part of the image
              ),
            ),
          ),
          // Foreground scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                8.verticalSpace,
                const Header(),
                5.verticalSpace,
                Text(
                  'Leader board',
                  style: GoogleFonts.titanOne(
                    fontSize: 30.sp,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 40.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Padding(
                  padding:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.h),
                  child: Column(
                    children: _levelsItems
                        .map((item) => _buildLevelsItems(item))
                        .toList(),
                  ),
                ),
                SizedBox(height: 40.h), // Space for footer
              ],
            ),
          ),
          // Footer positioned at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Footer(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelsList() {
    return Column(
      children: _levelsItems.map((item) => _buildLevelsItems(item)).toList(),
    );
  }

  Widget _buildLevelsItems(LevelsItems item) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Line connecting to the next circle
        Positioned(
          top: 0.2.sw, // Start from the middle of the current circle
          left: 0.80.sw, // Align with the center of the circle
          child: Container(
            width: 2.w, // Width of the line
            height: 200.h, // Length of the line
            color: const Color.fromARGB(255, 255, 255, 255), // Line color
          ),
        ),
        // Main row for the item
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          padding:
              EdgeInsets.symmetric(horizontal: 8.0), // Outer wrapper padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align blocks
            crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
            children: [
              // Left block
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                height: 67.h,
                width: 0.6.sw, // Adjust width as needed
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xFFC748FF),
                      Color(0xFF772B99),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 3.h,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(children: [
                  Text(
                    item.levelName,
                    style: GoogleFonts.titanOne(
                      fontSize: 20.sp,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 0),
                          blurRadius: 4.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 30.h,
                    width: 0.6.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: item.profileIcons
                              .map(
                                (item) => Container(
                                  margin: EdgeInsets.only(right: 3),
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(item),
                                      fit: BoxFit.cover,
                                      alignment: Alignment
                                          .centerRight, // Focuses on the right part of the image
                                    ),
                                    borderRadius: BorderRadius.circular(50.0),
                                    border: Border.all(color: Colors.black),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        Text(
                          '+5',
                          style: GoogleFonts.titanOne(
                            fontSize: 20.sp,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 4.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),

              // Right block
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                width: 0.2.sw,
                height: 0.2.sw, // Adjust width as needed
                decoration: BoxDecoration(
                  color: item.isOpened
                      ? Color(item.levelColor)
                      : Color.fromARGB(255, 145, 145, 145),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  // Center the number text inside the circle
                  child: Text(
                    item.stampsNumber.toString(),
                    style: GoogleFonts.titanOne(
                      fontSize: 22.sp,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
