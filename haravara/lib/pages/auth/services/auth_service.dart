import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/providers/auth_provider.dart';
import 'package:haravara/core/providers/login_provider.dart';
import 'package:haravara/haravara_app_phone.dart';
import 'package:haravara/pages/auth/models/user.dart' as local_user;
import 'package:haravara/pages/auth/models/user.dart';
import 'package:haravara/pages/auth/repositories/auth_repository.dart';
import 'package:haravara/core/repositories/database_repository.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
final AuthRepository authRepository = AuthRepository();
final DatabaseRepository databaseRepository = DatabaseRepository();

const String DEFAULT_AVATAR = '0387c644-249c-4c1e-ac0b-bc6c861d580c';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendSignInWithEmailLink(String email) async {
    ActionCodeSettings actionCodeSettings = ActionCodeSettings(
      url: 'https://haravara.page.link/XwD9?email=$email',
      handleCodeInApp: true,
      androidPackageName: 'sk.kosiceregion.haravara',
      androidInstallApp: true,
      iOSBundleId: 'sk.kosiceregion.haravara',
    );

    try {
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      log('Email link sent to $email');
    } catch (e) {
      print('Failed to send email link: $e');
    }
  }

  Future<void> signInWithEmailLink(String email, String link) async {
    try {
      if (_firebaseAuth.isSignInWithEmailLink(link)) {
        await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
        print('Successfully signed in with email link.');
      } else {
        print('Invalid sign-in link.');
      }
    } catch (e) {
      print('Error signing in with email link: $e');
    }
  }

  Future<local_user.User> registerUserByEmail(
    String email,
    String username,
    bool isFamilyType,
    int children,
    String location,
    bool isNeedToRemember,
  ) async {
    List<String> phoneDetail = await getDeviceDetails();
    final id = uuid.v4();
    final base64Id = generateBase64(email);
    final local_user.User user = local_user.User(
      username: username,
      phones: isNeedToRemember ? [phoneDetail[0]] : [],
      userProfile: local_user.UserProfile(
        avatar: DEFAULT_AVATAR,
        profileType: isFamilyType
            ? local_user.ProfileType.family
            : local_user.ProfileType.individual,
        children: children,
        location: location,
      ),
      email: email,
      id: id,
    );
    await authRepository.registerUser(user, id, base64Id);
    await setLoginPreferences(user);
    return user;
  }

  Future<String> findUserByEmail(String emailInput) async {
    String email = emailInput.trim().toLowerCase();
    log('AuthService: Looking up user by email: $email');
    return authRepository.findUserByEmail(email);
  }

  Future<local_user.User?> loginUserByEmail(
    String enteredEmail,
    bool isNeedToRememberPhone,
  ) async {
    List<String> phoneDetails = await getDeviceDetails();
    final userId = await findUserByEmail(enteredEmail);
    if (userId.isEmpty) {
      return null;
    }
    local_user.User? user = await getUserById(userId);
    if (user == null) {
      return null;
    }
    final updatedUser = isNeedToRememberPhone
        ? user.copyWith(phones: [...user.phones, phoneDetails[0]])
        : user.copyWith(phones: [...user.phones]);
    await authRepository.updateUser(updatedUser);
    await setLoginPreferences(updatedUser);
    await getCollectedPlacesByUser(updatedUser.id!);
    return updatedUser;
  }

  Future<void> getCollectedPlacesByUser(String id) async {
    await DatabaseService().getCollectedPlacesByUser(id);
  }

  Future<local_user.User?> getUserById(String userId) async {
    return authRepository.getUserById(userId);
  }

  String generateBase64(String input) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(input);
    return encoded;
  }

  Future<List<String>> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      return [build.id, 'Android'];
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      return [data.identifierForVendor!, 'IOS'];
    }
    return ['empty'];
  }

  setLoginPreferences(local_user.User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setString('email', user.email!);
    prefs.setString('id', user.id!);
    prefs.setString('username', user.username);
    prefs.setString('location', user.userProfile!.location!);
    prefs.setString(
        'profileType',
        user.userProfile!.profileType == local_user.ProfileType.family
            ? 'family'
            : 'individual');
    prefs.setInt('children', user.userProfile!.children ?? -1);
    prefs.setString('profile_image', user.userProfile!.avatar ?? '');
  }

  Future<void> handleRegistrationOrLogin(
      String email, WidgetRef ref, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isAdmin = await DatabaseService().isAdmin(email);
    log('Admin check result for $email: $isAdmin');
    if (isAdmin) {
      routeToAdminScreen();
      return;
    }

    final userId = await findUserByEmail(email);
    log('$userId');

    if (userId.isNotEmpty) {
      log('userId.isNotEmpty so logging in');
      await loginUserByEmail(
          email, ref.read(authNotifierProvider).isNeedToRemeber);
      await fetchUserDataAndUpdateProviders(userId, ref);

      final authState = ref.read(authNotifierProvider);
      log('LOGIN - enteredUsername: ${authState.enteredUsername}');
      log('LOGIN - enteredEmail: ${authState.enteredEmail}');
      log('LOGIN - userId: $userId');
      log('LOGIN - children: ${authState.children ?? -1}');
      log('LOGIN - location: ${authState.location ?? ''}');

      ref.read(loginNotifierProvider.notifier).login(
            authState.enteredUsername!,
            authState.enteredEmail!,
            userId,
            authState.children ?? -1,
            authState.location ?? '',
          );

      ref.read(userInfoProvider.notifier).build();
      ref
          .read(userInfoProvider.notifier)
          .updateUsername(authState.enteredUsername!);

      log('navigating to ScreenType.news');
      routeToNewsScreen();
    } else {
      final storedEmail = prefs.getString('email');
      if (storedEmail == email) {
        final storedUsername = prefs.getString('username') ?? '';
        final storedLocation = prefs.getString('location') ?? '';
        final storedIsFamily = prefs.getBool('isFamily') ?? false;
        final storedChildren = prefs.getInt('childrenCount') ?? -1;
        final storedRememberPhone = prefs.getBool('rememberPhone') ?? false;

        ref
            .read(authNotifierProvider.notifier)
            .setEnteredUsername(storedUsername);
        ref.read(authNotifierProvider.notifier).setEnteredEmail(email);
        ref
            .read(authNotifierProvider.notifier)
            .setEnteredChildren(storedChildren);
        ref.read(authNotifierProvider.notifier).setLocation(storedLocation);
        ref
            .read(authNotifierProvider.notifier)
            .toggleFamilyState(storedIsFamily);
        ref
            .read(authNotifierProvider.notifier)
            .toggleRememberState(storedRememberPhone);

        log('REGISTER - Restored data from SharedPreferences');
        log('REGISTER - enteredUsername: $storedUsername');
        log('REGISTER - enteredEmail: $email');
        log('REGISTER - children: $storedChildren');
        log('REGISTER - location: $storedLocation');

        final user = await registerUserByEmail(
          email,
          storedUsername,
          storedIsFamily,
          storedChildren,
          storedLocation,
          storedRememberPhone,
        );

        ref.read(loginNotifierProvider.notifier).login(
              storedUsername,
              email,
              user.id!,
              storedChildren,
              storedLocation,
            );

        ref.read(userInfoProvider.notifier).build();
        ref.read(userInfoProvider.notifier).updateUsername(storedUsername);

        // await prefs.clear();

        log('navigating to ScreenType.news');
        routeToNewsScreen();
      } else {
        log('No stored data found for $email, treating as new registration');
      }
    }
  }

  Future<void> fetchUserDataAndUpdateProviders(
      String userId, WidgetRef ref) async {
    local_user.User? user = await getUserById(userId);
    if (user == null) {
      log('User not found after authentication.');
      return;
    }

    log('User retrieved: ${user.username} - ${user.email}');

    await getCollectedPlacesByUser(userId);

    bool isFamily = user.userProfile!.profileType == ProfileType.family;
    String location = user.userProfile!.location ?? '';
    int children = user.userProfile!.children ?? -1;

    await ref.read(userInfoProvider.notifier).updateUserId(userId);
    log('FETCHING - update userId: $userId');

    await ref.read(userInfoProvider.notifier).updateUsername(user.username);
    log('FETCHING - username: ${user.username}');

    await ref.read(userInfoProvider.notifier).updateProfileType(isFamily);
    log('FETCHING - profileType: ${isFamily ? 'family' : 'individual'}');

    await ref.read(userInfoProvider.notifier).updateCountOfChildren(children);
    log('FETCHING - children: $children');

    ref.read(authNotifierProvider.notifier).setEnteredUsername(user.username);
    log('FETCHING - enteredUsername: ${user.username}');

    ref.read(authNotifierProvider.notifier).setEnteredEmail(user.email);
    log('FETCHING - enteredEmail: ${user.email}');

    ref.read(authNotifierProvider.notifier).setUserId(user.id);
    log('FETCHING - userId: ${user.id}');

    ref.read(authNotifierProvider.notifier).setLocation(location);
    log('FETCHING - location: $location');

    ref.read(authNotifierProvider.notifier).setEnteredChildren(children);
    log('FETCHING - enteredChildren: $children');

    ref.read(authNotifierProvider.notifier).toggleFamilyState(isFamily);
    log('FETCHING - familyState: ${isFamily ? 'family' : 'individual'}');

    await DatabaseService().saveUserAvatarsLocally(userId);
    final List<UserAvatar> avatars = await DatabaseService().loadAvatars();
    ref.read(avatarsProvider.notifier).addAvatars(avatars);
    log('FETCHING - avatars loaded and updated.');

    log('User data fetched and providers updated.');
  }

  void routeToNewsScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => ScreenRouter().getScreenWidget(ScreenType.news),
        ),
      );
    });
  }

  void routeToAdminScreen() {
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 200));
      if (navigatorKey.currentState == null) {
        return true;
      }
      log('Navigating to Admin Screen...');
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              ScreenRouter().getScreenWidget(ScreenType.admin),
        ),
      );
      return false;
    });
  }
}
