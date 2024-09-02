import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haravara/pages/auth/models/user.dart' as local_user;
import 'package:haravara/pages/auth/repositories/auth_repository.dart';
import 'package:haravara/core/repositories/database_repository.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
final AuthRepository authRepository = AuthRepository();
final DatabaseRepository databaseRepository = DatabaseRepository();

const String DEFAULT_AVATAR = '0387c644-249c-4c1e-ac0b-bc6c861d580c';

class AuthService {
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;

      if (user != null && user.isAnonymous) {
        log("Signed in anonymously as: ${user.uid}");
        return user;
      } else {
        log("User sign-in failed or user is not anonymous.");
        return null;
      }
    } catch (e) {
      log("Failed to sign in anonymously: $e");
      return null;
    }
  }

  Future<local_user.User> registerUserByEmail(
      String email,
      String username,
      bool isFamilyType,
      int children,
      String location,
      bool isNeedToRemember) async {
    List<String> phoneDetail = await getDeviceDetails();
    final id = uuid.v4();
    final base64Id = generateBase64(email).toString();
    final local_user.User user = local_user.User(
      username: username,
      phones: isNeedToRemember ? [phoneDetail[0]] : [],
      userProfile: local_user.UserProfile(
        avatar: DEFAULT_AVATAR,
        profileType: isFamilyType ? local_user.ProfileType.family : local_user.ProfileType.individual,
        children: children,
        location: location,
      ),
      email: email,
      id: id,
    );
    await authRepository.registerUser(user, id, base64Id);
    setLoginPreferences(user);
    return user;
  }

  Future<String> findUserByEmail(String email) async {
  User? user = await signInAnonymously();
  if (user != null) {
    return authRepository.findUserByEmail(generateBase64(email));
  } else {
    log("Failed to authenticate anonymously.");
    return '';
  }
}


  Future<void> loginUserByEmail(
      String enteredEmail, bool isNeedToRememberPhone) async {
    List<String> phoneDetails = await getDeviceDetails();
    final userId = await findUserByEmail(enteredEmail);
    local_user.User? user = await getUserById(userId);
    if (user == null) {
      return;
    }
    local_user.User updatedUser = isNeedToRememberPhone
        ? user.copyWith(phones: [...user.phones, phoneDetails[0]])
        : user.copyWith(phones: [...user.phones]);
    await authRepository.updateUser(updatedUser);
    await setLoginPreferences(updatedUser);
    await getCollectedPlacesByUser(updatedUser.id!);
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

  Future<String> generateRandomNumbers() async {
    String code = '';
    final random = math.Random();
    for (int i = 0; i < 4; i++) {
      code += random.nextInt(10).toString();
    }
    return code;
  }

  Future<String> sendEmail(BuildContext context, String email) async {
    String code = await generateRandomNumbers();
    final smtpServer = SmtpServer('smtp.m1.websupport.sk',
        username: 'users@haravara.sk', password: 'H4r4v4r4!808');
    final message = Message()
      ..from = const Address('users@haravara.sk', 'Haravara')
      ..recipients.add(email)
      ..subject = 'Haravara Code'
      ..text = 'Hello, thanks for using Haravara,\n Your code is $code';

    try {
      final sendReport = await send(message, smtpServer);
      log('$code Message sent: $sendReport');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mail Sent Successfully")));
    } on MailerException catch (e) {
      print('Message not sent. $code');
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    return code;
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
}