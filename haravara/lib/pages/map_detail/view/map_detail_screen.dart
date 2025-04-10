import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/models/place.dart';
import 'package:haravara/core/widgets/close_button.dart';
import 'package:haravara/pages/map_detail/services/screen_service.dart';
import 'package:haravara/pages/map_detail/widgets/widgets.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/core/services/event_bus.dart';
import 'package:haravara/router/screen_router.dart';

import '../map_detail.dart';

class MapDetailScreen extends ConsumerStatefulWidget {
  const MapDetailScreen({Key? key}) : super(key: key);

  static String? _activeInstanceId;

  @override
  ConsumerState<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends ConsumerState<MapDetailScreen> {
  List<Offset> tapPositions = [];
  final TransformationController _controller = TransformationController();
  GlobalKey imageKey = GlobalKey();
  final eventBus = EventBus();
  bool isMarkerPicking = true;
  bool isMarkerPicked = false;
  late Place pickedLocation;
  double targetLat = 0;
  double targetLng = 0;

  late final PickedPlaceNotifier _pickedPlaceNotifier;
  bool _isPreviewShown = false;
  late StreamSubscription<dynamic> _eventBusSubscription;
  final String _instanceId = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    MapDetailScreen._activeInstanceId = _instanceId;
    _pickedPlaceNotifier = ref.read(pickedPlaceProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMapPosition();
      _handleInitialPreview();
    });

    _eventBusSubscription = eventBus.on<String>().listen((tappedMarker) {
      if (tappedMarker != null &&
          mounted &&
          !_isPreviewShown &&
          MapDetailScreen._activeInstanceId == _instanceId) {
        if (tappedMarker is String) {
          _showPreviewForMarker(tappedMarker);
        }
      }
    });
  }

  void _initializeMapPosition() {
    final selectedPlace = ref.read(pickedPlaceProvider);

    if (selectedPlace.placeId != 'null' && selectedPlace.centerOnPlace) {
      pickedLocation = ref
          .read(placesProvider)
          .firstWhere((place) => place.id == selectedPlace.placeId);

      Offset targetPosition = Offset(
        pickedLocation.geoData.primary.pixelCoordinates[0],
        pickedLocation.geoData.primary.pixelCoordinates[1],
      );

      _controller.value = setInitialTransformation(
        0.6,
        Offset(
          -targetPosition.dx + MediaQuery.of(context).size.width / 2,
          -targetPosition.dy + MediaQuery.of(context).size.height / 2,
        ),
      );
    } else {
      const double initialScale = 0.23;
      const Offset initialPosition = Offset(-2970.0, 10.0);
      _controller.value =
          setInitialTransformation(initialScale, initialPosition);
    }
  }

  void _handleInitialPreview() {
    final selectedPlace = ref.read(pickedPlaceProvider);
    if (selectedPlace.placeId != 'null' &&
        selectedPlace.showPreview &&
        !_isPreviewShown) {
      pickedLocation = ref
          .read(placesProvider)
          .firstWhere((place) => place.id == selectedPlace.placeId);
      isMarkerPicked = true;
      _showPreview(pickedLocation);
      _pickedPlaceNotifier.resetPreview();
    }
  }

  void _showPreviewForMarker(String tappedMarker) {
    setState(() {
      pickedLocation = ref
          .read(placesProvider)
          .firstWhere((place) => place.id == tappedMarker);
      isMarkerPicked = true;
    });
    _showPreview(pickedLocation);
  }

  @override
  void dispose() {
    _eventBusSubscription.cancel();
    _controller.dispose();
    if (_isPreviewShown && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    if (MapDetailScreen._activeInstanceId == _instanceId) {
      MapDetailScreen._activeInstanceId = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/places-map.jpg'), context);
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return PopScope(
      onPopInvoked: (bool didPop) {
        _pickedPlaceNotifier.resetPlace();
        if (_isPreviewShown && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            InteractiveViewer(
              key: imageKey,
              constrained: false,
              minScale: 0.01,
              maxScale: 1.1,
              scaleEnabled: true,
              panEnabled: true,
              transformationController: _controller,
              child: GestureDetector(
                onTapUp: (details) {
                  setState(() {
                    tapPositions.add(Offset(
                        details.globalPosition.dx, details.globalPosition.dy));
                  });
                },
                child: Consumer(
                  builder: (context, ref, child) {
                    List<Place> places = ref.watch(placesProvider);
                    final selectedPlaceId =
                        ref.watch(pickedPlaceProvider).placeId;

                    return Stack(
                      children: [
                        Image.asset(
                          'assets/places-map.jpg',
                          fit: BoxFit.cover,
                        ),
                        ...places.asMap().entries.map((entry) {
                          Place place = entry.value;
                          return Positioned(
                            left: place.geoData.primary.pixelCoordinates[0],
                            top: place.geoData.primary.pixelCoordinates[1],
                            child: MapMarker(
                              isCollected: place.isReached,
                              index: place.order,
                              placeId: place.id!,
                              isSelected: place.id == selectedPlaceId,
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 43.h,
              right: 30.w,
              child: Close_Button(
                screenType: ScreenType.map,
                shouldPop: true,
              ),
            ),Positioned( //Info button
              top: 35.h,
              left: 20.w,
              child: IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white, size: 65.0),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                        return AlertDialog(
                        backgroundColor: const Color.fromARGB(255, 224, 186, 60),
                        title: const Text(
                          'POZOR!',
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          'Google maps pomôžu s navigáciou na cestách. V teréne sa prosím orientuj lokálnym značením.\nKlikní na ZAMERAJ MA a aplikácia ti napovie, ako ďaleko si od miesta pečiatky.',
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0, // Adjusted line height for smaller gap
                          ),
                        ),
                        actions: [
                          TextButton(
                          child: const Text(
                            'OK',
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          height: 0.5,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          ),
                        ],
                        );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void routeToCompassScreen() {
    ref.read(routerProvider.notifier).changeScreen(ScreenType.compass);
    String id = pickedLocation.id!;
    ref.read(pickedPlaceProvider.notifier).setNewPlace(id);
    if (_isPreviewShown && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    ScreenRouter().routeToNextScreen(
        context, ScreenRouter().getScreenWidget(ScreenType.compass));
  }

  void _showPreview(Place location) {
    if (_isPreviewShown && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    _isPreviewShown = true; // Kamenec - ce1687bb-df1e-4c5c-b539-7e6094e692e1 Velaty - c81f4329-8b49-4a01-8a73-9da4d42f1b6f

    // Add info on how to get there based on specific IDs
    if (location.id == 'ce1687bb-df1e-4c5c-b539-7e6094e692e1') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 224, 186, 60),
          title: const Text(
          'Info: Kamenec',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          ),
          content: const Text(
          'Follow the trail markers to reach the destination.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          ),
          actions: [
          TextButton(
            child: const Text(
            'OK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            ),
            onPressed: () {
            Navigator.of(context).pop();
            },
          ),
          ],
        );
        },
      );
      });
    } else if (location.id == 'c81f4329-8b49-4a01-8a73-9da4d42f1b6f') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 224, 186, 60),
          title: const Text(
          'Info: Velaty',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          ),
          content: const Text(
          'Use the local signs to navigate to the spot.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          ),
          actions: [
          TextButton(
            child: const Text(
            'OK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            ),
            onPressed: () {
            Navigator.of(context).pop();
            },
          ),
          ],
        );
        },
      );
      });
    }

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (context) {
        return PreviewBottomSheet(
          context: context,
          pickedLocation: location,
          routeToCompassScreen: routeToCompassScreen,
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          _isPreviewShown = false;
        });
      }
    });
  }
}
