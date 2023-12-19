import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_imei/device_imei.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AuthService {
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

  Future<bool> findUserByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Stream<bool> findUserByPhoneId() {
    return getDeviceDetails()
        .then((deviceInfo) => FirebaseFirestore.instance
            .collection('users')
            .where('phone_id', isEqualTo: deviceInfo[0])
            .get())
        .then((querySnapshot) => querySnapshot.docs.isNotEmpty)
        .asStream(); // Convert Future to Stream
  }
}
