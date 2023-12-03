// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/screens/activity_tracker.dart';
import 'package:haravara/screens/google_map_screen.dart';
import 'package:haravara/screens/map_screen.dart';
import 'package:haravara/screens/notification_screen.dart';
import 'package:haravara/screens/skills_screen.dart';
import 'package:haravara/widgets/animated_boy_widget.dart';

class MainScreen extends StatefulWidget {
  MainScreen(this.level, this.isFirstPhoto, {super.key});

  bool isFirstPhoto = true;
  String level = '1';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Position position;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  _getCurrentPosition() async {
    position = await Geolocator.getCurrentPosition();
  }

  void _navigateToMapScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => MapScreen()));
  }

  void _navigateToGoogleMapScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => GoogleMapScreen()));
  }

  int currentPageIndex = 1;

  static const IconData workspace_premium =
      IconData(0xf05ae, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    Widget data = Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('images/Laura.png'),
                          radius: 35,
                        ),
                        Container(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(height: 5),
                              Text(
                                "David Parker",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              Container(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    workspace_premium,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Premium',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 30),
                                  Icon(
                                    Icons.arrow_circle_up,
                                    color:
                                        const Color.fromARGB(255, 0, 61, 110),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '${widget.level} LEVEL',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(children: [
                Positioned(
                  left: 40,
                  child: AnimatedBoyWidget(
                      path: widget.isFirstPhoto
                          ? ['images/Stand1.jpeg', 'images/Stand12.png']
                          : ['images/Stand2.png', 'images/Stand23.png']),
                ),
                Positioned(
                  left: 0,
                  right: 350,
                  bottom: 0,
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => SkillsScreen()));
                    },
                    child:
                        Image(image: AssetImage('images/FirstAssetBook.png')),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 350,
                  bottom: MediaQuery.of(context).size.height * 0.30,
                  child: InkWell(
                    onTap: () {},
                    child:
                        Image(image: AssetImage('images/SecondAssetBook.png')),
                  ),
                ),
                Positioned(
                  left: 350,
                  right: 0,
                  bottom: 0,
                  top: MediaQuery.of(context).size.height * 0.1,
                  child: InkWell(
                    onTap: () {
                      _navigateToGoogleMapScreen();
                    },
                    child:
                        Image(image: AssetImage('images/FourthAssetBook.png')),
                  ),
                ),
                Positioned(
                  left: 350,
                  right: 0,
                  bottom: MediaQuery.of(context).size.height * 0.30,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => ActivityTrackerScreen()));
                    },
                    child:
                        Image(image: AssetImage('images/ThirdAssetBook.png')),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );

    if (currentPageIndex == 0) {
      data = NotificationScreen(
        showAppBar: false,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'TECH ',
              style: GoogleFonts.baloo2(fontWeight: FontWeight.bold),
            ),
            Text(
              'TERRA',
              style: GoogleFonts.baloo2(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 185, 0, 0),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => NotificationScreen()));
              },
              child: Badge(
                label: Text('3'),
                child: const Icon(Icons.notifications_none_sharp, size: 30),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Badge(child: Icon(Icons.person)),
            label: 'Me',
          ),
        ],
      ),
      body: data,
    );
  }
}
