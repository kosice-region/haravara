import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/pages/LeaderBoardLevels/widgets/widgets.dart';

class FaqItem {
  FaqItem({required this.question, required this.answer});

  String question;
  String answer;
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
    'assets/budik.png',
  ];

  final List<FaqItem> _faqItems = [
    FaqItem(
      question: 'Pro',
      answer: '60',
    ),
    FaqItem(
      question: 'Pokrocily',
      answer: '30',
    ),
    FaqItem(
      question: 'Middle',
      answer: '20',
    ),
    FaqItem(
      question: 'Zaciatocnik',
      answer: '10',
    ),
    FaqItem(
      question: 'Nula',
      answer: '0',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/background.jpg'),
                fit: BoxFit.cover, // Ensures the image covers the container
                alignment: Alignment
                    .centerRight, // Focuses on the right part of the image
              ),
            ),
          ),
          Column(
            children: [
              8.verticalSpace,
              const Header(),
              5.verticalSpace,
              Text(
                'Leader board',
                style: GoogleFonts.titanOne(
                    fontSize: 30.sp,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w500),
              ),
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: _buildFaqList(),
                ),
              ),
            ],
          ),
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

  Widget _buildFaqList() {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 80.h), // Added bottom padding
      child: Column(
        children: _faqItems.map((item) => _buildFaqItem(item)).toList(),
      ),
    );
  }

  Widget _buildFaqItem(FaqItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0), // Outer wrapper padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Align inner blocks to left and right
        crossAxisAlignment:
            CrossAxisAlignment.center, // Vertically center the blocks
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.question,
                style: GoogleFonts.titanOne(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Right block
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            width: 0.2.sw,
            height: 0.2.sw, // Adjust width as needed
            decoration: BoxDecoration(
              color: Color(0xFFC748FF),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              // Center the number text inside the circle
              child: Text(
                item.answer.toString(),
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
    );
  }
}
