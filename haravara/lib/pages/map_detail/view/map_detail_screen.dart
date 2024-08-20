import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/models/place.dart';
import 'package:haravara/pages/map_detail/services/screen_service.dart';
import 'package:haravara/pages/map_detail/widgets/widgets.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/core/services/event_bus.dart';
import 'package:haravara/router/screen_router.dart';

import '../map_detail.dart';

class MapDetailScreen extends ConsumerStatefulWidget {
  const MapDetailScreen({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedPlace = ref.read(pickedPlaceProvider);

      if (selectedPlace.placeId != 'null' && selectedPlace.centerOnPlace) {
        Place pickedLocation = ref
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
        _controller.value = setInitialTransformation(initialScale, initialPosition);
      }
    });

    eventBus.on<String>().listen((tappedMarker) {
      if (tappedMarker != null && mounted) {
        setState(() {
          pickedLocation = ref.watch(placesProvider).where((place) => place.id == tappedMarker).first;
          isMarkerPicked = true;
        });
        showPreview(context, pickedLocation, routeToCompassScreen);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedPlace = ref.read(pickedPlaceProvider);
      if (selectedPlace.placeId != 'null' && selectedPlace.showPreview) {
        setState(() {
          pickedLocation = ref.watch(placesProvider).where((place) => place.id == selectedPlace.placeId).first;
          isMarkerPicked = true;
        });
        showPreview(context, pickedLocation, routeToCompassScreen);
        ref.read(pickedPlaceProvider.notifier).resetPreview();
      }
    });
  }


  @override
  void dispose() {
    ref.read(pickedPlaceProvider.notifier).resetPlace();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/places-map.jpg'), context);
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return PopScope(
      onPopInvoked: (result) {
        ref.read(pickedPlaceProvider.notifier).resetPlace();
        return;
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
                    print('${details.globalPosition.dx}, ${details.globalPosition.dy}');
                    tapPositions.add(Offset(details.globalPosition.dx, details.globalPosition.dy));
                  });
                },
                child: Consumer(
                  builder: (context, ref, child) {
                    List<Place> places = ref.watch(placesProvider);
                    final selectedPlaceId = ref.watch(pickedPlaceProvider).placeId;

                    return Stack(
                      children: [
                        Image.asset(
                          'assets/places-map.jpg',
                          fit: BoxFit.cover,
                        ),
                        ...places.asMap().entries.map((entry) {
                          int index = entry.key;
                          Place place = entry.value;
                          return Positioned(
                            left: place.geoData.primary.pixelCoordinates[0],
                            top: place.geoData.primary.pixelCoordinates[1],
                            child: MapMarker(
                              isCollected: place.isReached,
                              index: index,
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
            Positioned(top: 40.h, left: 10.w, child: ExitButton()),
          ],
        ),
      ),
    );
  }

  void routeToCompassScreen() {
    ref.read(routerProvider.notifier).changeScreen(ScreenType.compass);
    String id = pickedLocation.id!;
    ref.read(pickedPlaceProvider.notifier).setNewPlace(id);
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(context, ScreenRouter().getScreenWidget(ScreenType.compass));
  }

  Future<dynamic> showPreview(BuildContext context, Place pickedLocation, Function routeToCompassScreen) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return PreviewBottomSheet(
          context: context,
          pickedLocation: pickedLocation,
          routeToCompassScreen: routeToCompassScreen,
        );
      },
    );
  }
}

