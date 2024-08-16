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
        color: Colors.black, 
        width: 3.0, 
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Zoznam pečiatok',
          style: GoogleFonts.titanOne(),
        ),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgrounds/pozadie8.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                    labelStyle: GoogleFonts.titanOne(),
                    prefixIcon: Icon(Icons.search),
                    enabledBorder: borderStyle,
                    focusedBorder: borderStyle,
                  ),
                  style: GoogleFonts.titanOne(), 
                ),
              ),
              Expanded(
                child: placesAsyncValue.when(
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  data: (places) {
                    final indexedPlaces = places.asMap().entries.map((entry) {
                      return MapEntry(entry.key + 1, entry.value);
                    }).toList();

                    final normalizedSearchQuery = normalize(searchQuery);

                    final filteredPlaces = indexedPlaces.where((entry) {
                      return normalize(entry.value.name)
                          .contains(normalizedSearchQuery);
                    }).toList();

                    return Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: filteredPlaces.length,
                        itemBuilder: (context, index) {
                          final entry = filteredPlaces[index];
                          final placeIndex = entry.key;
                          final place = entry.value;

                          return ListTile(
                            title: Text(
                              '$placeIndex. ${place.name}',
                              style: GoogleFonts.titanOne(
                                color: Colors.black, 
                                fontSize:
                                    16.0, 
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
