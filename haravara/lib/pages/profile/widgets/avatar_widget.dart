import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/auth/repositories/auth_repository.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/pages/profile/service/profile_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

final AuthRepository authRepository = AuthRepository();

class AvatarWidget extends ConsumerStatefulWidget {
  const AvatarWidget();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends ConsumerState<AvatarWidget> {
  late List<UserAvatar> avatars;
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
    double deviceHeight = MediaQuery.of(context).size.height;

    double imageSize = 100.h;

    if (deviceHeight < 850) {
      imageSize = 100.h;
    }
    if (deviceHeight < 700) {
      imageSize = 100.h;
    }
    if (deviceHeight < 650) {
      imageSize = 100.h;
    }

    UserAvatar avatar = ref.watch(avatarsProvider.notifier).getCurrentAvatar();

    return GestureDetector(
      onTap: () {
        _showAvatarDialog(context, ref);
      },
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: avatar.location != null && File(avatar.location!).existsSync()
              ? Image.file(
                  File(avatar.location!),
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/avatars/kasko.png',
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Future<void> _updateUserProfile(UserAvatar userAvatar) async {
    try {
      ref.read(avatarsProvider.notifier).updateAvatar(userAvatar.id!);
      String userProfileType =
          ref.watch(userInfoProvider).isFamily ? 'family' : 'individual';
      int children = ref.watch(userInfoProvider).children;
      String location = ref.watch(userInfoProvider).location;
      await authRepository.updateUserProfile(
          userId, userAvatar.id!, userProfileType, location, children);
    } catch (e) {
      log('Error updating user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  void _showAvatarDialog(BuildContext context, WidgetRef ref) async {
    avatars = ref.watch(avatarsProvider).avatars;

    UserAvatar currentAvatar =
        ref.watch(avatarsProvider.notifier).getCurrentAvatar();
    int initialPage =
        avatars.indexWhere((avatar) => avatar.id == currentAvatar.id);
    if (initialPage == -1) initialPage = 0;

    final PageController pageController =
        PageController(initialPage: initialPage);
    _currentPageNotifier.value = initialPage;

    Future<void> _pickImage() async {
      try {
        final isPermissionCameraGranted = await requestPermissionCamera();
        final isPermissionMediaGranted = await requestPermissionCamera();
        log('is permission granted: $isPermissionCameraGranted, $isPermissionMediaGranted');
        log('Opening image picker...');
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        if (image == null) {
          log('No image selected');
          return;
        }
        log('Image picked: ${image.path}');
        final CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Crop Image',
              aspectRatioLockEnabled: true,
            ),
          ],
        );
        if (croppedImage == null) {
          log('Image cropping cancelled');
          return;
        }
        log('Image cropped: ${croppedImage.path}');

        final compressedFile = await FlutterImageCompress.compressAndGetFile(
          croppedImage.path,
          "${croppedImage.path}_compressed.jpg",
          quality: 85,
          minWidth: 512,
          minHeight: 512,
        );

        if (compressedFile == null) {
          log('Image compression failed');
          return;
        }

        log('Image compressed: ${compressedFile.path}');
        final imageId = DateTime.now().millisecondsSinceEpoch.toString();
        await DatabaseService()
            .uploadAvatar(XFile(compressedFile.path), userId, imageId);
        final newAvatar = UserAvatar(
            id: imageId, location: compressedFile.path, isDefaultAvatar: false);
        ref.read(avatarsProvider.notifier).addAvatar(newAvatar);
        await _updateUserProfile(newAvatar);
        log('Avatar updated successfully');
        Navigator.of(context).pop();
      } catch (e) {
        log('Error in _pickImage: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }

    Future<void> _deleteImage(UserAvatar avatar) async {
      try {
        if (avatar.isDefaultAvatar! == 1) {
          return;
        }
        await DatabaseService().deleteAvatar(userId, avatar.id!);
        ref.read(avatarsProvider.notifier).deleteAvatar(avatar);
        avatars = ref.watch(avatarsProvider).avatars;
        setState(() {
          avatars = avatars.where((a) => a.id != avatar.id).toList();
        });
        if (ref.watch(avatarsProvider.notifier).getCurrentAvatar().location ==
            avatar.location) {
          await _updateUserProfile(avatars[0]);
        }
      } catch (e) {
        log('Error deleting image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete image: $e')),
        );
      }
    }

    double pageViewHeight =
        MediaQuery.of(context).size.height < 700 ? 170.h : 150.h;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vyber si profilovku'),
          content: SizedBox(
            width: 400.w,
            height: 220.h,
            child: Column(
              children: [
                SizedBox(
                  height: pageViewHeight,
                  child: PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: avatars.length + 1,
                    itemBuilder: (context, index) {
                      if (index == avatars.length) {
                        return GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Icon(Icons.add_a_photo, size: 100),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: avatars.length + 1,
                      effect: const ExpandingDotsEffect(
                        spacing: 6.0,
                        dotWidth: 10.0,
                        dotHeight: 10.0,
                        expansionFactor: 1.5,
                        dotColor: Colors.grey,
                        activeDotColor: Color.fromRGBO(205, 19, 175, 1),
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _currentPageNotifier,
                  builder: (context, currentPage, child) {
                    if (currentPage >= avatars.length ||
                        (currentPage < avatars.length &&
                            avatars[currentPage].isDefaultAvatar == true)) {
                      return const SizedBox(height: 10);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: IconButton(
                        onPressed: () async {
                          await _deleteImage(avatars[currentPage]);
                          Navigator.of(context).pop();
                          _showAvatarDialog(context, ref);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                        iconSize: 24,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
