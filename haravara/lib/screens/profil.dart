import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late SharedPreferences _prefs;
  String userName = 'Tvoje Meno';
  String selectedProfileImage =
      'assets/profil.png';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  void _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    String? storedName = _prefs.getString('userName');
    if (storedName != null) {
      setState(() {
        userName = storedName;
      });
    }
  }

  void _saveUserData() {
    _prefs.setString('userName', userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HeaderMenu(),
      body: Stack(
        children: [
          Image.asset(
            'assets/clovece.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              8.verticalSpace,
              const Header(),
              10.verticalSpace,
              Text(
                'PROFIL PATRACA',
                style: GoogleFonts.titanOne(
                  fontSize: 18.sp,
                  color: const Color.fromRGBO(41, 141, 116, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              10.verticalSpace,
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Vyberte si profilovú fotku'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedProfileImage =
                                      'assets/profil.png';
                                });
                                Navigator.of(context).pop(); 
                              },
                              child: Image.asset(
                                'assets/profil.png',
                                width: 100.w,
                                height: 100.h,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedProfileImage =
                                      'assets/mayka_shows.png';
                                });
                                Navigator.of(context).pop();
                              },
                              child: Image.asset(
                                'assets/mayka_shows.png',
                                width: 100.w,
                                height: 100.h,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Image.asset(
                  selectedProfileImage, 
                  width: 120.w,
                  height: 120.h,
                ),
              ),
              5.verticalSpace,
              Text(
                userName,
                style: GoogleFonts.titanOne(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(
                      41, 141, 116, 1),
                  onPrimary: Colors.white, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Upraviť meno',
                          style: GoogleFonts.titanOne(),
                        ),
                        content: TextField(
                          autofocus: true,
                          onChanged: (value) {
                            setState(() {
                              userName =
                                  value;
                            });
                          },
                          decoration: InputDecoration(hintText: 'Nové meno'),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Zrušiť'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _saveUserData(); 
                              Navigator.of(context).pop();
                            },
                            child: Text('Uložiť'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Upraviť',
                  style: GoogleFonts.titanOne(), 
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: const Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}
