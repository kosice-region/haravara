import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/auth/repositories/auth_repository.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/pages/profile/service/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/auth/models/user.dart';

final AuthRepository authRepository = AuthRepository();

class AvatarWidget extends ConsumerStatefulWidget {
  const AvatarWidget();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends ConsumerState<AvatarWidget> {
  late List<UserAvatar> avatars;
  final PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final ImagePicker _picker = ImagePicker();
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
    avatars = ref.watch(avatarsProvider).avatars;
  }

  void _loadUserData() async {
    userId = ref.watch(userInfoProvider).id;
  }

  @override
  Widget build(BuildContext context) {
    UserAvatar avatar = ref.watch(avatarsProvider.notifier).getCurrentAvatar();
    return GestureDetector(
        onTap: () {
          _showAvatarDialog(context, ref);
        },
        child: ClipOval(
          child: Image.file(
            File(avatar.location!),
            height: 100.h,
            width: 100.w,
            fit: BoxFit.fill,
          ),
        ));
  }

  _updateUserProfile(UserAvatar userAvatar) async {
    ref.read(avatarsProvider.notifier).updateAvatar(userAvatar.id!);
    String userProfileType =
        ref.watch(userInfoProvider).isFamily ? 'family' : 'individual';
    int children = ref.watch(userInfoProvider).children;
    String location = ref.watch(userInfoProvider).location;
    await authRepository.updateUserProfile(
        userId, userAvatar.id!, userProfileType, location, children);
  }

  void _showAvatarDialog(BuildContext context, WidgetRef ref) async {
    avatars = ref.watch(avatarsProvider).avatars;

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
      avatars = ref.watch(avatarsProvider).avatars;
      setState(() {
        avatars = avatars.where((a) => a.id != avatar.id).toList();
      });
      if (ref.watch(avatarsProvider.notifier).getCurrentAvatar() ==
          avatar.location!) {
        _updateUserProfile(avatars[0]);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vyberte si profilovku'),
          content: SizedBox(
            width: 400.w,
            height: 200.h,
            child: Column(
              children: [
                SizedBox(
                  height: 150.h,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: avatars.length + 1,
                    itemBuilder: (context, index) {
                      if (index == avatars.length) {
                        return GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.add_a_photo, size: 100),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              _updateUserProfile(avatars[index]);
                              Navigator.of(context).pop();
                            },
                            child: ClipOval(
                              child: Image.file(
                                File(avatars[index].location!),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    onPageChanged: (index) {
                      _currentPageNotifier.value = index;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: avatars.length + 1,
                    effect: SlideEffect(
                      spacing: 8.0,
                      radius: 4.0,
                      dotWidth: 20.0,
                      dotHeight: 8.0,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: const Color.fromRGBO(205, 19, 175, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/*import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/auth/repositories/auth_repository.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/pages/profile/service/profile_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/auth/models/user.dart';

final AuthRepository authRepository = AuthRepository();

class AvatarWidget extends ConsumerStatefulWidget {
  const AvatarWidget();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends ConsumerState<AvatarWidget> {
  late List<UserAvatar> avatars;
  final PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final ImagePicker _picker = ImagePicker();
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
    avatars = ref.watch(avatarsProvider).avatars;
  }

  void _loadUserData() async {
    userId = ref.watch(userInfoProvider).id;
  }

  @override
  Widget build(BuildContext context) {
    UserAvatar avatar = ref.watch(avatarsProvider.notifier).getCurrentAvatar();
    return GestureDetector(
        onTap: () {
          _showAvatarDialog(context, ref);
        },
        child: ClipOval(
          child: avatar.location != null && File(avatar.location!).existsSync()
              ? Image.file(
                  File(avatar.location!),
                  height: 100.h,
                  width: 100.w,
                  fit: BoxFit.fill,
                )
              : Image.asset(
                  'assets/avatars/kasko.png',
                  height: 100.h,
                  width: 100.w,
                  fit: BoxFit.fill,
                ),
        ));
  }

  _updateUserProfile(UserAvatar userAvatar) async {
    ref.read(avatarsProvider.notifier).updateAvatar(userAvatar.id!);
    String userProfileType =
        ref.watch(userInfoProvider).isFamily ? 'family' : 'individual';
    int children = ref.watch(userInfoProvider).children;
    String location = ref.watch(userInfoProvider).location;
    await authRepository.updateUserProfile(
        userId, userAvatar.id!, userProfileType, location, children);
  }

  void _showAvatarDialog(BuildContext context, WidgetRef ref) async {
    avatars = ref.watch(avatarsProvider).avatars;

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
      avatars = ref.watch(avatarsProvider).avatars;
      setState(() {
        avatars = avatars.where((a) => a.id != avatar.id).toList();
      });
      if (ref.watch(avatarsProvider.notifier).getCurrentAvatar() ==
          avatar.location!) {
        _updateUserProfile(avatars[0]);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vyberte si profilovku'),
          content: SizedBox(
            width: 400.w,
            height: 200.h,
            child: Column(
              children: [
                SizedBox(
                  height: 150.h,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: avatars.length + 1,
                    itemBuilder: (context, index) {
                      if (index == avatars.length) {
                        return GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(Icons.add_a_photo, size: 100),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              _updateUserProfile(avatars[index]);
                              Navigator.of(context).pop();
                            },
                            child: ClipOval(
                              child: avatars[index].location != null &&
                                      File(avatars[index].location!)
                                          .existsSync()
                                  ? Image.file(
                                      File(avatars[index].location!),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/avatars/kasko.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        );
                      }
                    },
                    onPageChanged: (index) {
                      _currentPageNotifier.value = index;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: avatars.length + 1,
                    effect: SlideEffect(
                      spacing: 8.0,
                      radius: 4.0,
                      dotWidth: 20.0,
                      dotHeight: 8.0,
                      paintStyle: PaintingStyle.fill,
                      strokeWidth: 1.5,
                      dotColor: Colors.grey,
                      activeDotColor: const Color.fromRGBO(205, 19, 175, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/
