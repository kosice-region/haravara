import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/pages/leaderBoard/view/people_screen.dart';

// Import the file where LevelsData, Level, PersonsItem, usersNotifierProvider are defined
import '../leaderBoardLevels.dart';

class LevelsItems {
  LevelsItems({
    required this.levelName,
    required this.stampsNumber,
    required this.isOpened,
    required this.levelColor,
    required this.profileIcons,
    required this.amountOfPeople,
  });

  String levelName;
  String stampsNumber;
  bool isOpened;
  int levelColor;
  List<String> profileIcons;
  int amountOfPeople;
}

class LeaderBoardLevelsScreen extends ConsumerWidget {
  const LeaderBoardLevelsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAssets = [
      'assets/backgrounds/background.jpg',
      'assets/avatars/kasko.png',
    ];

    for (var image in imageAssets) {
      precacheImage(AssetImage(image), context);
    }

    // Watch the levels data from the provider
    final levelsDataAsync = ref.watch(usersNotifierProvider);

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
                alignment: Alignment.centerRight,
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
                // Build UI based on LevelsData state
                levelsDataAsync.when(
                  data: (levelsData) {
                    // Convert the Level objects to LevelsItems objects
                    // stampsNumber was originally the minimum stamp count as a string
                    // You can decide how to show stampsNumber. Let's show the minimum stamps required
                    // or the range min-max. Here we'll just show the min for simplicity.
                    final levelsItems = levelsData.levels.map((lvl) {
                      return LevelsItems(
                        levelName: lvl.name,
                        stampsNumber: lvl.min.toString(),
                        isOpened: lvl.isOpened ?? false,
                        levelColor: lvl.levelColor,
                        profileIcons: lvl.profileIcons ?? [],
                        amountOfPeople: lvl.amountOfPeople ?? 0,
                      );
                    }).toList();

                    return Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 20.h),
                      child: Column(
                        children: levelsItems
                            .map((item) =>
                                _buildLevelsItems(context, levelsItems, item))
                            .toList(),
                      ),
                    );
                  },
                  loading: () => Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, stackTrace) => Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Center(
                      child: Text(
                        'Error: $error',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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

  Widget _buildLevelsItems(
      BuildContext context, List<LevelsItems> items, LevelsItems item) {
    return GestureDetector(
      onTap: () {
        int chosenLevelIndex = items.indexOf(item) + 1;
        // Navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LeaderBoardScreen(chosenLevel: chosenLevelIndex),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Line connecting to the next circle (optional, adjust as needed)
          Positioned(
            top: 0.2.sw,
            left: 0.80.sw,
            child: Container(
              width: 2.w,
              height: 200.h,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          // Main row for the item
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left block
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: 0.6.sw,
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
                      textAlign: TextAlign.center,
                      style: GoogleFonts.titanOne(
                        fontSize: 15.sp,
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
                            children: item.profileIcons.map((icon) {
                              return Container(
                                margin: EdgeInsets.only(right: 1),
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(icon),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                          Text(
                            item.amountOfPeople == 0
                                ? 'Nikto tu nie je'
                                : ((item.amountOfPeople -
                                                item.profileIcons.length) ==
                                            0
                                        ? ''
                                        : '+') +
                                    ((item.amountOfPeople -
                                                item.profileIcons.length) ==
                                            0
                                        ? ''
                                        : (item.amountOfPeople -
                                                item.profileIcons.length)
                                            .toString()),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.titanOne(
                              fontSize:
                                  item.amountOfPeople == 0 ? 16.sp : 20.sp,
                              color: item.amountOfPeople == 0
                                  ? const Color.fromARGB(255, 226, 152, 255)
                                  : const Color.fromARGB(255, 255, 255, 255),
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
                  height: 0.2.sw,
                  decoration: BoxDecoration(
                    color: item.isOpened
                        ? Color(item.levelColor)
                        : Color.fromARGB(255, 145, 145, 145),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
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
      ),
    );
  }
}
