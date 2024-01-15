import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/screens/auth.dart';
import 'package:haravara/services/database_service.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final dbService = DatabaseService();

  registerUserByEmail(String email, String username) async {
    List<String> phoneDetail = await getDeviceDetails();
    final user =
        User.regEmail(email: email, phoneIds: [phoneDetail[0]], name: username);
    final id = uuid.v4();
    final base64Id = generateBase64(email).toString();
    await dbService.registerUser(user, id, base64Id);
    await setLoginPreferences(email, id);
  }

  registerUserByPhoneNumber(String enteredCode, String enteredUsername) async {
    // TODO MAKE REGISTER BY NUMBER
  }

  Future<String> findUserByEmail(String email) async {
    return DatabaseService().findUserByEmail(generateBase64(email));
  }

  loginUserByPhoneNumber(String enteredPhone) async {}

  loginUserByEmail(String enteredEmail) async {
    List<String> phoneDetail = await getDeviceDetails();
    final userId = await findUserByEmail(enteredEmail);
    User user = await getUserById(userId);
    user.phoneIds = [...user.phoneIds, phoneDetail[0]];
    await dbService.updateUser(user);
    await setLoginPreferences(enteredEmail, userId);
  }

  setLoginPreferences(String email, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setString('email', email);
    prefs.setString('id', id);
  }

  getUserById(String userId) async {
    return databaseService.getUserById(userId);
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

  Future<String> sendEmail(BuildContext context //For showing snackbar
      ) async {
    String code = await generateRandomNumbers();
    String username = 'asusnik241201@gmail.com'; //Your Email
    String password =
        'vaqr tmcn ecgy rksf'; // 16 Digits App Password Generated From Google Account

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.

    final message = Message()
          ..from = Address(username, 'Danil Zdoryk')
          ..recipients.add('danilzdoryk@gmail.com')
          // ..ccRecipients.addAll(['abc@gmail.com', 'xyz@gmail.com']) // For Adding Multiple Recipients
          // ..bccRecipients.add(Address('a@gmail.com')) For Binding Carbon Copy of Sent Email
          ..subject = 'Mail from Mailer'
          ..text =
              'Hello, thanks for register in our application.\n Your code is ${code}'
        // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>"; // For Adding Html in email
        // ..attachments = [
        //   FileAttachment(File('image.png'))  //For Adding Attachments
        //     ..location = Location.inline
        //     ..cid = '<myimg@3.141>'
        // ]
        ;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Mail Send Successfully")));
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    return code;
  }
}
