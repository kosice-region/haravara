
import 'dart:async';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:haravara/pages/admin/view/screens/special_rewards/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


var excel = Excel.createExcel();

Future<List<int>?> exportEmailsToExcel(int rewardLevel) async {

  Sheet sheetObject = excel['Sheet1'];


  List<String> headerRow = ["User", "Claimed"];
  sheetObject.appendRow(headerRow.map((e) => TextCellValue(e)).toList());
  List<String> emails = await getUserEmailsByRewardLevelOnce(rewardLevel);
    for (String email in emails) {
      List<CellValue> dataRow = [
        TextCellValue(email),
        TextCellValue('')
      ];
      sheetObject.appendRow(dataRow);
    }


  return excel.save();
}


Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    else {
      directory = Directory('/storage/emulated/0/Documents');
    }
  } catch (err) {
    print("Cannot get download path: $err");
  }
  return directory?.path;
}

Future<bool> saveExcelFile(List<int> fileBytes, String filePath) async {
  try {
    final file = File(filePath);

    await file.writeAsBytes(fileBytes, flush: true);
    print("File saved successfully at: $filePath");
    return true;
  } catch (e) {
    print("Error saving file: $e");
    return false;
  }
}

Future<void> exportDataToExcel(BuildContext context, int rewardLevel) async {
  await Permission.storage.request();;

  String? downloadPath = await getDownloadPath();
  if (downloadPath == null) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get save location.'))
    );
    return;
  }

  String fileName = "Special_Rewards_${DateTime.now().millisecondsSinceEpoch}.xlsx";
  String fullPath = "$downloadPath/$fileName";


  List<int>? fileBytes = await exportEmailsToExcel(rewardLevel);

  if (fileBytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate Excel data.'))
    );
    print("Excel generation returned null bytes.");
    return;
  }

  print("Saving file to: $fullPath");
  bool saved = await saveExcelFile(fileBytes, fullPath);


  if (saved) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel file saved successfully! Path: $fullPath'))
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving Excel file.'))
    );
  }
}