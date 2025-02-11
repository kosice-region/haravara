import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/close_button.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import '../leaderBoard.dart';
import 'package:haravara/pages/profile/providers/avatars.provider.dart';

class LeaderBoardScreen extends ConsumerWidget {
  final int chosenLevel;

  const LeaderBoardScreen({Key? key, required this.chosenLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAvatars =
        ref.watch(avatarsProvider).getAllUserIdsAndAvatarLocations();
    final usersAsync = ref.watch(usersNotifierProvider(usersAvatars));

    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
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

                // Display the chosen level name from the levels list
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      10.horizontalSpace,
                      Positioned(
                        top: -25,
                        left: -10,
                        child: Container(
                          width: 0.35.sw,
                          height: 0.35.sw,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Original PNG Image
                              Image.asset(
                                levels[chosenLevel - 1].badgeImage,
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              const BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 40.0,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                      Container(
                        width: 0.55.sw,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          levels[chosenLevel - 1].name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.titanOne(
                            fontSize: 21.sp,
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
                      ),
                      15.horizontalSpace,
                    ]),
                10.verticalSpace,
                _buildBody(usersAsync, ref),
                SizedBox(height: 40.h), // Space for footer
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Footer(height: 40),
          ),
          Positioned(
            top: 43.h,
            right: 30.w,
            child: Close_Button(),

            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
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
    );
  }

  Widget _buildBody(AsyncValue<List<PersonsItem>> usersAsync, WidgetRef ref) {
    return usersAsync.when(
      data: (users) {
        // Once data is loaded, filter for chosen level
        final usersAvatars =
            ref.watch(avatarsProvider).getAllUserIdsAndAvatarLocations();
        final filteredUsers = ref
            .read(usersNotifierProvider(usersAvatars).notifier)
            .getUsersForLevel(chosenLevel);

        if (filteredUsers.isEmpty) {
          return Center(
            child: Text(
              'Nikto tu ešte nie je',
              style: GoogleFonts.titanOne(
                fontSize: 18.sp,
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
            child: ClipOval(
              child: File(item.profileIcon).existsSync()
                  ? Image.file(
                      File(item.profileIcon),
                      width: 28.w,
                      height: 28.w,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      'assets/avatars/kasko.png',
                      fit: BoxFit.fill,
                    ),
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
                  fontSize: 18.sp,
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
