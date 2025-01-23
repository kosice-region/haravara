import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/map_detail/providers/picked_place_provider.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';
import 'package:haravara/pages/map_detail/view/map_detail_screen.dart';
import 'package:diacritic/diacritic.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class PlacesListScreen extends ConsumerStatefulWidget {
  @override
  _PlacesListScreenState createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).state = '';
    });
  }

  String normalize(String input) {
    return removeDiacritics(input.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final placesAsyncValue = ref.watch(placesFutureProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.white,
        width: 3.0,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Zoznam pečiatok',
          style: GoogleFonts.titanOne(
      color: Colors.white, 
    ),
        ),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(
    color: Colors.white,
  ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgrounds/pozadie8.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Vyhľadať',
                    labelStyle: GoogleFonts.titanOne(color: Colors.white),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle,
                  ),
                  style: GoogleFonts.titanOne(
                    color: Colors.white, 
                  ),
                ),
              ),
              Expanded(
                child: placesAsyncValue.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text(
                      'Error: $err',
                      style: TextStyle(color: Colors.white), 
                    ),
                  ),
                  data: (places) {
                    places.sort((a, b) => a.order.compareTo(b.order));

                    final normalizedSearchQuery = normalize(searchQuery);

                    final filteredPlaces = places.where((place) {
                      return normalize(place.name)
                          .contains(normalizedSearchQuery);
                    }).toList();

                    return Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: filteredPlaces.length,
                        itemBuilder: (context, index) {
                          final place = filteredPlaces[index];
                          final placeOrder = place.order;

                          return ListTile(
                            title: Text(
                              '$placeOrder. ${place.name}',
                              style: GoogleFonts.titanOne(
                                color: Colors.white, 
                                fontSize: 16.0,
                              ),
                            ),
                            onTap: () {
                              ref
                                  .read(pickedPlaceProvider.notifier)
                                  .setNewPlace(place.id!, centerOnPlace: true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapDetailScreen(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
