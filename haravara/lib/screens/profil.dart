import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/repositories/auth_repository.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AuthRepository authRepository = AuthRepository();

class ProfilScreen extends ConsumerStatefulWidget {
  const ProfilScreen({super.key});

  @override
  ConsumerState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends ConsumerState<ProfilScreen> {
  late SharedPreferences _prefs;
  String defaultImage = '0387c644-249c-4c1e-ac0b-bc6c861d580c';
  String userName = 'Tvoje Meno';
  String selectedProfileImage = 'assets/kasko.png';
  late AuthNotifier authNotifier;
  late List<UserAvatar> avatars;
  bool isInit = false;
  late String userId;
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
    userId = _prefs.getString('id')!;
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
    await authRepository.updateUserName(userName, userId);
    authNotifier.setEnteredUsername(userName);
    await _prefs.setString('username', userName);
  }

  _updateUserProfile(UserAvatar userAvatar) async {
    String userProfileType = _prefs.getString('profileType') ?? 'family';
    await authRepository.updateUserProfile(
        userId, userAvatar.id!, userProfileType);
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
                      _showAvatarDialog(context, ref);
                    },
                    child: ClipOval(
                      child: Image.file(
                        File(selectedProfileImage),
                        height: 120.h,
                        width: 120.w,
                        fit: BoxFit.fill,
                      ),
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

  void _showAvatarDialog(BuildContext context, WidgetRef ref) {
    final ImagePicker _picker = ImagePicker();
    avatars = ref.watch(avatarsProvider);

    Future<void> _pickImage() async {
      final isPermissionCameraGranted = await requestPermissionCamera();
      final isPermissionMediaGranted = await requestPermissionCamera();
      log('is persmission granted $isPermissionCameraGranted');

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final imageId = DateTime.now().millisecondsSinceEpoch.toString();
      await DatabaseService().uploadAvatar(image, userId, imageId);
      final newAvatar =
          UserAvatar(id: imageId, location: image.path, isDefaultAvatar: false);
      ref.read(avatarsProvider.notifier).addAvatar(newAvatar);
      _updateUserProfile(newAvatar);
      Navigator.of(context).pop();
    }

    Future<void> _deleteImage(UserAvatar avatar) async {
      if (avatar.isDefaultAvatar! == 1) {
        return;
      }
      await DatabaseService().deleteAvatar(userId, avatar.id!);
      ref.read(avatarsProvider.notifier).deleteAvatar(avatar);
      avatars = ref.watch(avatarsProvider);
      setState(() {
        avatars = avatars.where((a) => a.id != avatar.id).toList();
      });
      if (selectedProfileImage == avatar.location!) {
        _updateUserProfile(avatars[0]);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vyberte si profilovku'),
          content: SizedBox(
            width: 150.w,
            height: 80.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...avatars
                      .map(
                        (avatar) => Dismissible(
                          direction: avatar.isDefaultAvatar!
                              ? DismissDirection.none
                              : DismissDirection.down,
                          key: Key(avatar.id!),
                          onDismissed: (direction) {
                            _deleteImage(avatar);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: Center(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20.dg,
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _updateUserProfile(avatar);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: avatar.location != null &&
                                      avatar.location!.isNotEmpty
                                  ? ClipOval(
                                      child: Image.file(
                                        File(avatar.location!),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/max.png',
                                      width: 100,
                                      height: 100,
                                    ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.add_a_photo, size: 100),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> requestPermissionCamera() async {
    final permission = Permission.camera;
    final result = await permission.request();
    if (await result.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> requestPermissionMedia() async {
    final permission = Permission.mediaLibrary;
    final result = await permission.request();
    if (await result.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        return true;
      }
    }
    return false;
  }
}
