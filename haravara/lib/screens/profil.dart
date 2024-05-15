import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/repositories/auth_repository.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AuthRepository authRepository = AuthRepository();

class ProfilScreen extends ConsumerStatefulWidget {
  const ProfilScreen({super.key});

  @override
  ConsumerState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends ConsumerState<ProfilScreen> {
  late SharedPreferences _prefs;
  String userName = 'Tvoje Meno';
  String selectedProfileImage = 'assets/kasko.png';
  late AuthNotifier authNotifier;

  @override
  void initState() {
    authNotifier = ref.read(authNotifierProvider.notifier);
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    String? storedName = _prefs.getString('username');
    String? storedImage = _prefs.getString('profile_image');
    if (storedName != null) {
      setState(() {
        userName = storedName;
        selectedProfileImage = storedImage ??
            'assets/kasko.png'; // Ak nie je uložený obrázok, použije sa predvolený
      });
    }
  }

  _saveUserData() async {
    var userId = _prefs.getString('id');
    await authRepository.updateUserName(userName, userId!);
    authNotifier.setEnteredUsername(userName);
    await _prefs.setString('username', userName);
    await _prefs.setString('profile_image',
        selectedProfileImage); // Uložiť vybraný obrázok do zdieľaných preferencií
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Image.asset(
            'assets/HARAVARA_profil.jpg',
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
                        title: Text('Vyberte si profilovku'),
                        content: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedProfileImage =
                                        'assets/sprievodca.png';
                                  });
                                  _saveUserData(); // Uložiť vybraný obrázok
                                  Navigator.of(context).pop();
                                },
                                child: Image.asset(
                                  'assets/sprievodca.png',
                                  width: 100.w,
                                  height: 100.h,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedProfileImage = 'assets/kasko.png';
                                  });
                                  _saveUserData(); // Uložiť vybraný obrázok
                                  Navigator.of(context).pop();
                                },
                                child: Image.asset(
                                  'assets/kasko.png',
                                  width: 100.w,
                                  height: 100.h,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedProfileImage = 'assets/max.png';
                                  });
                                  _saveUserData(); // Uložiť vybraný obrázok
                                  Navigator.of(context).pop();
                                },
                                child: Image.asset(
                                  'assets/max.png',
                                  width: 100.w,
                                  height: 100.h,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedProfileImage = 'assets/majka.png';
                                  });
                                  _saveUserData(); // Uložiť vybraný obrázok
                                  Navigator.of(context).pop();
                                },
                                child: Image.asset(
                                  'assets/majka.png',
                                  width: 100.w,
                                  height: 100.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Image.asset(
                  selectedProfileImage, // Zobraziť aktuálny profilový obrázok
                  width: 120.w,
                  height: 120.h,
                ),
              ),
              5.verticalSpace,
              Text(
                userName, // Používateľské meno
                style: GoogleFonts.titanOne(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromRGBO(41, 141, 116, 1),
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
                                  value; // Aktualizovať používateľské meno
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
