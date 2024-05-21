import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/repositories/auth_repository.dart';
import 'package:haravara/repositories/database_repository.dart';
import 'package:haravara/screens/auth.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/services/init_service.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
final AuthRepository authRepository = AuthRepository();
final DatabaseRepository databaseRepository = DatabaseRepository();

class AuthService {
  registerUserByEmail(String email, String username, bool isFamilyType) async {
    List<String> phoneDetail = await getDeviceDetails();
    final id = uuid.v4();
    final base64Id = generateBase64(email).toString();
    final user = User(
      username: username,
      phones: [phoneDetail[0]],
      userProfile: UserProfile(
        avatar: '0387c644-249c-4c1e-ac0b-bc6c861d580c',
        profileType: isFamilyType ? ProfileType.family : ProfileType.individual,
      ),
      email: email,
      id: id,
    );
    await authRepository.registerUser(user, id, base64Id);
    setLoginPreferences(user);
  }

  registerUserByPhoneNumber(String enteredCode, String enteredUsername) async {
    // TODO: MAKE REGISTER BY NUMBER
  }

  Future<String> findUserByEmail(String email) async {
    return authRepository.findUserByEmail(generateBase64(email));
  }

  loginUserByPhoneNumber(String enteredPhone) async {}

  loginUserByEmail(String enteredEmail) async {
    List<String> phoneDetail = await getDeviceDetails();
    final userId = await findUserByEmail(enteredEmail);
    User? user = await getUserById(userId);
    if (user != null) {
      User updatedUser =
          user.copyWith(phones: [...user.phones, phoneDetail[0]]);
      await authRepository.updateUser(updatedUser);
      await setLoginPreferences(updatedUser);
      await getCollectedPlacesByUser(user.id!);
    }
  }

  Future<void> getCollectedPlacesByUser(String id) async {
    await DatabaseService().getCollectedPlacesByUser(id);
  }

  getUserById(String userId) async {
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
      ..text = 'Hello thanks for using Haravara,\n Your code is $code';

    try {
      final sendReport = await send(message, smtpServer);
      print('$code Message sent: $sendReport');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mail Send Successfully")));
    } on MailerException catch (e) {
      print('Message not sent. $code');
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    return code;
  }

  setLoginPreferences(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setString('email', user.email!);
    prefs.setString('id', user.id!);
    prefs.setString('username', user.username);
    prefs.setString(
        'profileType',
        user.userProfile!.profileType == ProfileType.family
            ? 'family'
            : 'individual');
    prefs.setString('profile_image', user.userProfile!.avatar ?? '');
  }
}
