import 'dart:developer';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/providers/version_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendReport(
  String title,
  String description,
  String expected,
  List<XFile> images,
  BuildContext context,
  WidgetRef ref,
) async {
  log('Starting sendReport...', name: 'BugReport');


  String appVersion = await getAppVersion();
  log('App version: $appVersion', name: 'BugReport');

  final uploadTasks = <Future>[];
  String time =
      '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('email');
  log('User ID: $userId, Date: $time', name: 'BugReport');

  final newBugKey = FirebaseDatabase.instance.ref('/bugReports').push().key;
  log('Generated new bug key: $newBugKey', name: 'BugReport');

  for (var image in images) {
    final imageId = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance
        .ref('images/bug-reports/$newBugKey/$imageId.jpg');
    log('Uploading image to: ${storageRef.fullPath}', name: 'BugReport');

    try {
      final file = File(image.path);
      if (!file.existsSync()) {
        log('Image file does not exist: ${image.path}', name: 'BugReport');
        throw Exception('Image file not found: ${image.path}');
      }

      final uploadTask = storageRef.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      uploadTasks.add(uploadTask);
      log('Upload task added for image: $imageId', name: 'BugReport');
    } catch (e) {
      log('Error preparing upload for image $imageId: $e',
          name: 'BugReport', error: e);
      rethrow;
    }
  }

  try {
    log('Waiting for ${uploadTasks.length} image uploads to complete',
        name: 'BugReport');
    await Future.wait(uploadTasks);
    log('All images uploaded successfully', name: 'BugReport');
  } on FirebaseException catch (e) {
    log('FirebaseException during image upload: ${e.message}',
        name: 'BugReport', error: e);
    throw e;
  } catch (e) {
    log('Unexpected error during image upload: $e',
        name: 'BugReport', error: e);
    throw e;
  }


  final postData = {
    'author': userId,
    'title': title,
    'images': 'images/bug-reports/$newBugKey/',
    'description': description,
    'expected': expected,
    'date': time,
    'timestamp': ServerValue.timestamp,
    'solved': false,
    'appVersion': appVersion,
  };
  log('Prepared post data: $postData', name: 'BugReport');

  try {
    await FirebaseDatabase.instance
        .ref('/bugReports/$newBugKey')
        .update(postData);
    log('Report successfully sent to Firebase', name: 'BugReport');
  } catch (e) {
    log('Error updating Firebase Database: $e', name: 'BugReport', error: e);
    throw e;
  }
}
