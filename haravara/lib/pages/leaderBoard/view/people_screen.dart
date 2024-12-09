import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';

class PersonsItem {
  PersonsItem({
    required this.personsName,
    required this.stampsNumber,
    required this.profileIcon,
  });

  String personsName;
  String stampsNumber;
  String profileIcon;
}

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  final List<String> imageAssets = [
    'assets/backgrounds/background.jpg',
    'assets/avatars/kasko.png',
  ];

  final List<PersonsItem> _PersonsItem = [
    PersonsItem(
      personsName: 'jankozlaty99',
      stampsNumber: '97',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'adamsim777',
      stampsNumber: '92',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'martinovak123',
      stampsNumber: '90',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'kristinalovely',
      stampsNumber: '88',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'andrejkovac01',
      stampsNumber: '86',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'lucia.hviezda',
      stampsNumber: '84',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'michalhero22',
      stampsNumber: '81',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'veronikasmile',
      stampsNumber: '79',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'peter.dobry',
      stampsNumber: '77',
      profileIcon: 'assets/avatars/kasko.png',
    ),
    PersonsItem(
      personsName: 'zuzanaqueeeeen',
      stampsNumber: '75',
      profileIcon: 'assets/avatars/kasko.png',
    ),
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
                  'Legendárny',
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
                _buildPersonsList(),
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

  Widget _buildPersonsList() {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.fromLTRB(5, 20, 0, 10),
      decoration: BoxDecoration(
          color: Color(0xFFA43CD2),
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(40.0)),
      child: Column(
        children: _PersonsItem.map((item) => _buildPersonsItem(item)).toList(),
      ),
    );
  }

  Widget _buildPersonsItem(PersonsItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0), // Outer wrapper padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align blocks
        crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
        children: [
          Container(
            margin: EdgeInsets.only(right: 3),
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(item.profileIcon),
                fit: BoxFit.cover,
                alignment: Alignment
                    .centerRight, // Focuses on the right part of the image
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          Container(
            width: 132.w,
            child: Text(
              item.personsName,
              style: GoogleFonts.titanOne(
                fontSize: 15.sp,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 7.0,
                    color: Colors.black,
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.stampsNumber,
                style: GoogleFonts.titanOne(
                  fontSize: 20.sp,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 10.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                margin: EdgeInsets.only(right: 3),
                height: 28.w,
                width: 28.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/PECIATKA.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment
                        .centerRight, // Focuses on the right part of the image
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
