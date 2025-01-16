import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminAssignStampsScreen extends ConsumerStatefulWidget {
  const AdminAssignStampsScreen({Key? key}) : super(key: key);

  @override
  _AdminAssignStampsScreenState createState() =>
      _AdminAssignStampsScreenState();
}

class _AdminAssignStampsScreenState
    extends ConsumerState<AdminAssignStampsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<_LocationListState> locationListKey =
      GlobalKey<_LocationListState>();
  String _searchQuery = '';
  String? selectedEmail;

  int totalCount = 0;
  int collectedCount = 0;

  int selectedCount = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/backgrounds/verification_background.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 22.h),
              child: const Header(),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 150.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedEmail == null) ...[
                      Container(
                        width: 210.w,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.trim();
                            });
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Search by email',
                            hintStyle: GoogleFonts.titanOne(
                              fontSize: 16.sp,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF9260A8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                          ),
                          style: GoogleFonts.titanOne(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: 210.w,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9260A8),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Center(
                          child: Text(
                            selectedEmail!,
                            style: GoogleFonts.titanOne(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 15.h),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 4.0,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                selectedEmail == null
                                    ? EmailSuggestionsList(
                                        searchQuery: _searchQuery,
                                        onEmailSelected: (email) {
                                          setState(() {
                                            selectedEmail = email;
                                          });
                                        },
                                      )
                                    : LocationList(
                                        key: locationListKey,
                                        email: selectedEmail!,
                                        onTotalCountFetched: (count) {
                                          setState(() {
                                            totalCount = count;
                                          });
                                        },
                                        onCollectedCountFetched: (count) {
                                          setState(() {
                                            collectedCount = count;
                                          });
                                        },
                                        onSelectedLocationsCountFetched:
                                            (count) {
                                          setState(() {
                                            selectedCount = count;
                                          });
                                        },
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            height: 4.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    if (selectedEmail != null)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(25),
                                border:
                                    Border.all(color: Colors.white, width: 5),
                              ),
                              child: Text(
                                '$collectedCount / $totalCount',
                                style: GoogleFonts.titanOne(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(25),
                                border:
                                    Border.all(color: Colors.white, width: 5),
                              ),
                              child: Text(
                                '$selectedCount',
                                style: GoogleFonts.titanOne(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            ElevatedButton(
                              onPressed: () {
                                _showConfirmationDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4CAF50),
                                side: BorderSide(color: Colors.white, width: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 10.h),
                              ),
                              child: Text(
                                'Confirm',
                                style: GoogleFonts.titanOne(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 50.h,
              right: 30.w,
              child: GestureDetector(
                onTap: () {
                  if (selectedEmail != null) {
                    setState(() {
                      selectedEmail = null;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.transparent,
                  ),
                  child: Image.asset(
                    'assets/menu-icons/backbutton.png',
                    width: 36.w,
                    height: 36.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Changes',
            style: GoogleFonts.titanOne(),
          ),
          content: Text(
            'You are about to assign ${selectedCount} locations to $selectedEmail. Do you want to proceed?',
            style: GoogleFonts.titanOne(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.titanOne(),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (selectedEmail != null) {
                  locationListKey.currentState?._confirmSelectedLocations();
                }
              },
              child: Text(
                'Confirm',
                style: GoogleFonts.titanOne(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EmailSuggestionsList extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onEmailSelected;

  const EmailSuggestionsList({
    required this.searchQuery,
    required this.onEmailSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: getUserEmailsBySearchQuery(searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No users found.',
              style: GoogleFonts.titanOne(fontSize: 14.sp, color: Colors.white),
            ),
          );
        }
        final userEmails = snapshot.data!;
        return Center(
          child: Container(
            width: double.infinity,
            height: 300.h,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.separated(
                itemCount: userEmails.length,
                itemBuilder: (context, index) {
                  final email = userEmails[index];
                  double dynamicFontSize = (18 - (email.length * 0.25))
                      .clamp(6.0, 16.0); 
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 220.w),
                        child: GestureDetector(
                          onTap: () => onEmailSelected(email),
                          child: Container(
                            height: 45.h, 
                            decoration: BoxDecoration(
                              color: Color(0xFF59B84A).withOpacity(0.9),
                              borderRadius:
                                  BorderRadius.circular(25), 
                              border: Border.all(
                                  color: Colors.white,
                                  width: 4),
                            ),
                            child: Center(
                              child: Text(
                                email,
                                style: GoogleFonts.titanOne(
                                  fontSize: dynamicFontSize.sp,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white.withOpacity(0.5),
                  thickness: 2.5,
                  indent: 40.w,
                  endIndent: 40.w,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Stream<List<String>> getUserEmailsBySearchQuery(String searchQuery) async* {
    final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
    final usersStream = usersRef.onValue;
    await for (final userEvent in usersStream) {
      final users = userEvent.snapshot.value as Map<dynamic, dynamic>?;
      if (users != null) {
        List<String> emails = [];
        users.forEach((_, userData) {
          if (userData['email'] != null &&
              userData['email']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase())) {
            emails.add(userData['email']);
          }
        });
        yield emails;
      } else {
        yield [];
      }
    }
  }
}

class LocationList extends StatefulWidget {
  final String email;
  final ValueChanged<int> onTotalCountFetched;
  final ValueChanged<int> onCollectedCountFetched;
  final ValueChanged<int> onSelectedLocationsCountFetched;

  const LocationList({
    Key? key,
    required this.email,
    required this.onTotalCountFetched,
    required this.onCollectedCountFetched,
    required this.onSelectedLocationsCountFetched,
  }) : super(key: key);

  @override
  _LocationListState createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  Map<String, bool> locationStatus = {};
  Map<String, bool> checkboxStatus = {};
  Map<String, String> locationNames = {};
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchLocationData();
  }

  int get selectedLocationsCount {
    return checkboxStatus.values.where((isSelected) => isSelected).length;
  }

  Future<void> fetchLocationData() async {
    userId = await getUserIdByEmail(widget.email);
    if (userId == null) {
      log("User ID not found for email ${widget.email}");
      return;
    }
    log("User ID found: $userId");
    try {
      final data = await getAllLocationNamesWithCollectedStatus(userId!);
      final names = await getLocationNames();

      int totalLocations = data.length;
      int collectedLocations =
          data.values.where((isCollected) => isCollected).length;

      widget.onTotalCountFetched(totalLocations);
      widget.onCollectedCountFetched(collectedLocations);

      setState(() {
        locationStatus = data;
        checkboxStatus = Map.from(data);
        locationNames = names;
      });

      int initialSelectedCount =
          checkboxStatus.values.where((isSelected) => isSelected).length;
      widget.onSelectedLocationsCountFetched(initialSelectedCount);
    } catch (e) {
      log("Error fetching locations: $e");
    }
  }

  Future<String?> getUserIdByEmail(String email) async {
    final usersRef = FirebaseDatabase.instance.ref('users');
    final snapshot = await usersRef.orderByChild('email').equalTo(email).get();
    if (snapshot.exists) {
      return snapshot.children.first.key;
    }
    return null;
  }

  Future<Map<String, bool>> getAllLocationNamesWithCollectedStatus(
      String userId) async {
    final collectedPlacesRef = FirebaseDatabase.instance
        .ref('collectedLocationsByUsers')
        .child(userId);
    final locationsRef = FirebaseDatabase.instance.ref('locations');
    final collectedLocationsSnapshot = await collectedPlacesRef.get();
    List<dynamic> collectedLocationIds = [];
    if (collectedLocationsSnapshot.exists) {
      collectedLocationIds = collectedLocationsSnapshot.value as List<dynamic>;
    }
    final locationsSnapshot = await locationsRef.get();
    Map<String, bool> locationStatus = {};
    if (locationsSnapshot.exists) {
      final locationsData = locationsSnapshot.value as Map<dynamic, dynamic>;
      locationsData.forEach((locationId, locationData) {
        final isCollected = collectedLocationIds.contains(locationId);
        locationStatus[locationId] = isCollected;
      });
    }
    return locationStatus;
  }

  Future<Map<String, String>> getLocationNames() async {
    final locationsRef = FirebaseDatabase.instance.ref('locations');
    final locationsSnapshot = await locationsRef.get();
    Map<String, String> locationNames = {};
    if (locationsSnapshot.exists) {
      final locationsData = locationsSnapshot.value as Map<dynamic, dynamic>;
      locationsData.forEach((locationId, locationData) {
        final locationName = locationData['name'] as String;
        locationNames[locationId] = locationName;
      });
    }
    return locationNames;
  }

  Future<void> addCollectedPlacesForUser(List<String> placeIds) async {
    if (userId == null) {
      log("User ID is null, cannot add collected places");
      return;
    }
    DatabaseReference placesRef = FirebaseDatabase.instance
        .ref('collectedLocationsByUsers')
        .child(userId!);
    final existingData = (await placesRef.get()).value;
    List<String> existingPlaces =
        (existingData is List) ? List<String>.from(existingData) : [];
    final updatedPlaces = {...existingPlaces, ...placeIds}.toList();
    try {
      await placesRef.set(updatedPlaces);
      log("Successfully updated places for user $userId: $updatedPlaces");
    } catch (e) {
      log("Error updating places for user $userId: $e");
    }
  }

  Future<void> removeCollectedPlacesForUser(List<String> placeIds) async {
    if (userId == null) {
      log("User ID is null, cannot remove collected places");
      return;
    }
    DatabaseReference placesRef = FirebaseDatabase.instance
        .ref('collectedLocationsByUsers')
        .child(userId!);
    final existingData = (await placesRef.get()).value;
    List<String> existingPlaces =
        (existingData is List) ? List<String>.from(existingData) : [];
    final updatedPlaces =
        existingPlaces.where((placeId) => !placeIds.contains(placeId)).toList();
    try {
      await placesRef.set(updatedPlaces);
      log("Successfully removed places for user $userId: $placeIds");
    } catch (e) {
      log("Error removing places for user $userId: $e");
    }
  }

  void _confirmSelectedLocations() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Changes',
            style: GoogleFonts.titanOne(),
          ),
          content: Text(
            'Are you sure you want to save these selected locations?',
            style: GoogleFonts.titanOne(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.titanOne(),
              ),
            ),
            TextButton(
              onPressed: () async {
                final selectedPlaceIds = checkboxStatus.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();
                final unselectedPlaceIds = checkboxStatus.entries
                    .where((entry) =>
                        !entry.value && locationStatus[entry.key] == true)
                    .map((entry) => entry.key)
                    .toList();
                await addCollectedPlacesForUser(selectedPlaceIds);
                await removeCollectedPlacesForUser(unselectedPlaceIds);
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: GoogleFonts.titanOne(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (locationStatus.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemCount: locationStatus.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withOpacity(0.5),
              thickness: 1.0,
            ),
            itemBuilder: (context, index) {
              final locationId = locationStatus.keys.elementAt(index);
              final locationName = locationNames[locationId] ?? '';
              final isCollected = locationStatus[locationId] ?? false;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}.   ',
                      style: GoogleFonts.titanOne(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        locationName,
                        style: GoogleFonts.titanOne(
                          color: isCollected ? Color.fromARGB(255, 27, 218, 33) : Colors.white, 
                          fontSize: 21.0,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: checkboxStatus[locationId] ?? false,
                      onChanged: (value) {
                        setState(() {
                          checkboxStatus[locationId] = value ?? false;
                        });
                        widget.onSelectedLocationsCountFetched(
                            selectedLocationsCount);
                      },
                      activeColor: Color.fromARGB(255, 27, 199, 33),
                      checkColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
