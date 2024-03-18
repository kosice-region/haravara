import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/repositories/auth_repository.dart';
import 'package:haravara/repositories/location_repository.dart';
import 'package:haravara/screens/auth.dart';
import 'package:haravara/services/init_service.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

final AuthRepository authRepository = AuthRepository();
final LocationRepository locationRepository = LocationRepository();

class AuthService {
  registerUserByEmail(String email, String username, WidgetRef ref) async {
    List<String> phoneDetail = await getDeviceDetails();
    print(phoneDetail[0]);
    final user =
        User(username: username, phones: [phoneDetail[0]], email: email);
    final id = uuid.v4();
    final base64Id = generateBase64(email).toString();
    await authRepository.registerUser(user, id, base64Id);
    setLoginPreferences(email, id, username);
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
      await setLoginPreferences(user.email!, userId, user.username);
      await getCollectedPlacesByUser(user.id!);
    }
  }

  Future<void> getCollectedPlacesByUser(String id) async {
    await placesService.getCollectedPlacesByUser(id);
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
      return [build.id, 'Android']; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;

      return [data.identifierForVendor!, 'IOS']; // UUID for IOS
    }
    return ['empty'];
  }

  Future<String> generateRandomNumbers() async {
    String code = '';
    final random = Random();
    for (int i = 0; i < 4; i++) {
      code += random.nextInt(10).toString();
    }
    return code;
  }

  Future<String> sendEmail(BuildContext context, String email) async {
    String code = await generateRandomNumbers();
    String username = 'asusnik241201@gmail.com';
    String password = 'vaqr tmcn ecgy rksf';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Danil Zdoryk')
      ..recipients.add(email)
      ..subject = 'Mail from Mailer'
      ..text =
          'Hello, thanks for register in our application.\n Your code is $code';

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

  setLoginPreferences(String email, String id, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setString('email', email);
    prefs.setString('id', id);
    prefs.setString('username', username);
  }
}
