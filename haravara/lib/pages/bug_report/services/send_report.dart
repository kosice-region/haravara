import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/providers/version_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> sendReport(String title, String description, String expected,
    List<XFile>? images, context, WidgetRef ref) async {
  String appVersion = await getAppVersion();

  final uploadTasks = <Future>[];
  String time = DateTime.now().day.toString() +"-"+ DateTime.now().month.toString() +"-"+ DateTime.now().year.toString();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('email');

  final newBugKey = FirebaseDatabase.instance.ref('/bugReports').push().key;
  if(images != null){
    for (var image in images) {
      final imageId = DateTime.now().millisecondsSinceEpoch.toString();

      uploadTasks.add(FirebaseStorage.instance
          .ref('images/bug-reports/$newBugKey/$imageId.jpg')
          .putFile(File(image.path)));
    }
    try {
      await Future.wait(uploadTasks);
    } on FirebaseException catch (e) {
      log('error while adding image $e');
    }
  }


  final postData = {
    'author': userId,
    'title': title,
    'images': "images/bug-reports/$newBugKey/",
    'description': description,
    'expected': expected,
    'date': time,
    'timestamp': ServerValue.timestamp,
    'solved': false,
    'appVersion': appVersion,
  };

  FirebaseDatabase.instance.ref('/bugReports/' + newBugKey!).update(postData);
}
