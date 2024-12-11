import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart'; // Adjust based on your project structure
import 'package:haravara/core/widgets/footer.dart'; // Adjust based on your project structure
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart'; // Adjust path
import '../leaderBoard.dart'; // The file with providers, PersonsItem, and level definitions

class LeaderBoardScreen extends ConsumerWidget {
  final int chosenLevel;

  const LeaderBoardScreen({Key? key, required this.chosenLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use chosenLevel here to show the correct level's users
    final usersAsync = ref.watch(usersNotifierProvider);

    return Scaffold(
      endDrawer: HeaderMenu(), // Your custom drawer if needed
      body: Stack(
        children: [
          // Background layer
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/background.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),
          ),
          // Foreground content
          SingleChildScrollView(
            child: Column(
              children: [
                8.verticalSpace,
                const Header(),
                5.verticalSpace,
                // Display the chosen level name from the levels list
                Text(
                  levels[chosenLevel - 1].name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.titanOne(
                    fontSize: 30.sp,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w500,
                    shadows: [
                      const Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 40.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                _buildBody(usersAsync, ref),
                SizedBox(height: 40.h), // Space for footer
              ],
            ),
          ),
          // Footer positioned at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Footer(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(AsyncValue<List<PersonsItem>> usersAsync, WidgetRef ref) {
    return usersAsync.when(
      data: (users) {
        // Once data is loaded, filter for chosen level
        final filteredUsers = ref
            .read(usersNotifierProvider.notifier)
            .getUsersForLevel(chosenLevel);

        if (filteredUsers.isEmpty) {
          return Center(
            child: Text(
              'Nikto tu nie je',
              style: GoogleFonts.titanOne(
                fontSize: 24.sp,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 7.0,
                    color: Colors.black,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return _buildPersonsList(filteredUsers);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
    );
  }

  Widget _buildPersonsList(List<PersonsItem> users) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.fromLTRB(5, 20, 0, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFA43CD2),
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        children: users.map((item) => _buildPersonsItem(item)).toList(),
      ),
    );
  }

  Widget _buildPersonsItem(PersonsItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 3),
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(item.profileIcon),
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          SizedBox(
            width: 132.w,
            child: Text(
              item.personsName,
              style: GoogleFonts.titanOne(
                fontSize: 15.sp,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 7.0,
                    color: Colors.black,
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.stampsNumber.toString(),
                style: GoogleFonts.titanOne(
                  fontSize: 20.sp,
                  color: Colors.white,
                  shadows: [
                    const Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 10.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                margin: const EdgeInsets.only(right: 3),
                height: 28.w,
                width: 28.w,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/PECIATKA.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
