import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/models/place.dart';
import 'package:haravara/providers/map_providers.dart';
import 'package:haravara/repositories/location_repository.dart';
import 'package:haravara/services/init_service.dart';
import 'package:haravara/services/places_service.dart';

class Api extends ConsumerStatefulWidget {
  const Api({super.key});

  @override
  ConsumerState<Api> createState() => _ApiState();
}

class _ApiState extends ConsumerState<Api> {
  List<Place> places = [];
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Init.initialize(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Api Testing')),
      body: Column(children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              placesService.listFiles();
            },
            child: const Text('press'),
          ),
        ),
        20.verticalSpace,
        if (places.isNotEmpty)
          Column(
            children: [
              Image.file(
                File(places[0].placeImages!.location),
                height: 200.0,
                width: 200.0,
              ),
              30.verticalSpace,
              Image.file(
                File(places[0].placeImages!.stamp),
                height: 200.0,
                width: 200.0,
              ),
            ],
          ),
      ]),
    );
  }
}

// flutter: /Users/A200278143/Library/Developer/CoreSimulator/Devices/3BD8ABC6-B57D-4CDC-BB33-DCD40BDDCFF6/data/Containers/Data/Application/7905A748-2FB8-4A6A-8993-807B672C22FE/Documents/images/locations/vodny_mlyn_kovacova_main.png
// flutter: /Users/A200278143/Library/Developer/CoreSimulator/Devices/3BD8ABC6-B57D-4CDC-BB33-DCD40BDDCFF6/data/Containers/Data/Application/7905A748-2FB8-4A6A-8993-807B672C22FE/Documents/images/locations/gombasecka_jaskyna.jpg