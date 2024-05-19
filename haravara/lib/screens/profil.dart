import 'dart:developer';
import 'dart:io';

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
  late List<UserAvatar> avatars;
  bool isInit = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authNotifier = ref.read(authNotifierProvider.notifier);
    avatars = ref.watch(avatarsProvider);
  }

  void _loadUserData() async {
    _prefs = await SharedPreferences.getInstance();
    String? storedName = _prefs.getString('username');
    UserAvatar currentAvatar =
        ref.watch(avatarsProvider.notifier).getCurrentAvatar();
    if (storedName != null) {
      setState(() {
        userName = storedName;
        selectedProfileImage = currentAvatar.location!;
        isInit = true;
      });
    }
  }

  _updateUsername() async {
    var userId = _prefs.getString('id');
    await authRepository.updateUserName(userName, userId!);
    authNotifier.setEnteredUsername(userName);
    await _prefs.setString('username', userName);
  }

  _updateUserProfile(UserAvatar userAvatar) async {
    var userId = _prefs.getString('id');
    String userProfileType = _prefs.getString('profileType') ?? 'family';
    await authRepository.updateUserProfile(
        userId!, userAvatar.id!, userProfileType);
    ref.read(avatarsProvider.notifier).updateAvatar(userAvatar.id!);
    setState(() {
      selectedProfileImage = userAvatar.location!;
    });
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
              if (isInit)
                GestureDetector(
                    onTap: () {
                      _showAvatarDialog(context, avatars);
                    },
                    child: Image.file(
                      File(selectedProfileImage),
                      height: 120.h,
                      width: 120.w,
                    )),
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
                              userName = value;
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
                              _updateUsername();
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

  void _showAvatarDialog(BuildContext context, List<UserAvatar> avatars) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vyberte si profilovku'),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: avatars.isNotEmpty
                  ? avatars
                      .map((avatar) => GestureDetector(
                            onTap: () {
                              _updateUserProfile(avatar);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: avatar.location != null &&
                                      avatar.location!.isNotEmpty
                                  ? Image.file(
                                      File(avatar.location!),
                                      width: 100,
                                      height: 100,
                                    )
                                  : Image.asset(
                                      'assets/max.png',
                                      width: 100,
                                      height: 100,
                                    ),
                            ),
                          ))
                      .toList()
                  : [Text("No avatars available")],
            ),
          ),
        );
      },
    );
  }
}
