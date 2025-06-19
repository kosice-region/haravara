import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/auth/repositories/auth_repository.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
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
    log('AvatarWidget: Loaded userId: $userId');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double imageSize = 100.h;

    if (deviceHeight < 850) imageSize = 100.h;
    if (deviceHeight < 700) imageSize = 100.h;
    if (deviceHeight < 650) imageSize = 100.h;

    UserAvatar avatar = ref.watch(avatarsProvider.notifier).getCurrentAvatar();
    log('AvatarWidget: Rendering avatar with location: ${avatar.location}, Exists: ${avatar.location != null && File(avatar.location!).existsSync()}');

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
          child: _buildAvatarImage(avatar, imageSize),
        ),
      ),
    );
  }

  Widget _buildAvatarImage(UserAvatar avatar, double imageSize) {
    if (avatar.location == null || !File(avatar.location!).existsSync()) {
      log('AvatarWidget: Falling back to default avatar due to invalid location or non-existent file');
      return Image.asset(
        'assets/avatars/kasko.png',
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
      );
    }
    try {
      return Image.file(
        File(avatar.location!),
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          log('AvatarWidget: Image.file error: $error, falling back to default avatar');
          return Image.asset(
            'assets/avatars/kasko.png',
            width: imageSize,
            height: imageSize,
            fit: BoxFit.cover,
          );
        },
      );
    } catch (e) {
      log('AvatarWidget: Exception loading avatar: $e, falling back to default avatar');
      return Image.asset(
        'assets/avatars/kasko.png',
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
      );
    }
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
      log('AvatarWidget: Updated user profile with avatar ID: ${userAvatar.id}');
    } catch (e) {
      log('AvatarWidget: Error updating user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<bool> requestPermissionCamera() async {
    return true;
  }

  Future<void> _pickImage() async {
    try {
      final isPermissionCameraGranted = await requestPermissionCamera();
      final isPermissionMediaGranted = await requestPermissionCamera();
      log('AvatarWidget: Permissions granted: $isPermissionCameraGranted, $isPermissionMediaGranted');
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Orezať profilovku',
            toolbarColor: Colors.deepPurpleAccent,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.grey[850]!,
            cropFrameColor: Colors.white,
            cropGridColor: Colors.white70,
            dimmedLayerColor: Colors.black54,
            activeControlsWidgetColor: Colors.deepPurple,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            showCropGrid: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: 'Orezať profilovku',
            cancelButtonTitle: 'Zrušiť',
            doneButtonTitle: 'Uložiť',
            aspectRatioLockEnabled: true,
            showCancelConfirmationDialog: true,
            rotateButtonsHidden: false,
            resetButtonHidden: false,
          ),
        ],
      );
      if (croppedImage == null) return;
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        croppedImage.path,
        "${croppedImage.path}_compressed.jpg",
        quality: 85,
        minWidth: 512,
        minHeight: 512,
      );
      if (compressedFile == null) return;
      final imageId = DateTime.now().millisecondsSinceEpoch.toString();
      await DatabaseService()
          .uploadAvatar(XFile(compressedFile.path), userId, imageId);
      final newAvatar = UserAvatar(
          id: imageId, location: compressedFile.path, isDefaultAvatar: false);
      ref.read(avatarsProvider.notifier).addAvatar(newAvatar);
      await _updateUserProfile(newAvatar);
      Navigator.of(context).pop();
    } catch (e) {
      log('AvatarWidget: Error picking/uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  Future<void> _deleteImage(UserAvatar avatar) async {
    try {
      if (avatar.isDefaultAvatar! == 1) return;
      await DatabaseService().deleteAvatar(userId, avatar.id!);
      ref.read(avatarsProvider.notifier).deleteAvatar(avatar);
      avatars = ref.watch(avatarsProvider).avatars;
      setState(() {
        avatars = avatars.where((a) => a.id != avatar.id).toList();
      });
      if (ref.watch(avatarsProvider.notifier).getCurrentAvatar().location ==
          avatar.location) {
        await _updateUserProfile(avatars.isNotEmpty
            ? avatars[0]
            : UserAvatar(
                id: '0387c644-249c-4c1e-ac0b-bc6c861d580c',
                location: 'assets/avatars/kasko.png',
                isDefaultAvatar: true));
      }
    } catch (e) {
      log('AvatarWidget: Error deleting image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
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

    double pageViewHeight =
        MediaQuery.of(context).size.height < 700 ? 170.h : 150.h;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vyber si profilovku'),
          content: SizedBox(
            width: 400.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                child: _buildAvatarImage(avatars[index], 100),
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
                        return const Padding(
                          padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: SizedBox(height: 48),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
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
          ),
        );
      },
    );
  }
}
