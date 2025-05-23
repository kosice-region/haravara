
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/database_repository.dart';

class AdminDeleteUserScreen extends ConsumerStatefulWidget {
  const AdminDeleteUserScreen({Key? key}) : super(key: key);

  @override
  _AdminDeleteUserScreenState createState() =>
      _AdminDeleteUserScreenState();
}

class _AdminDeleteUserScreenState
    extends ConsumerState<AdminDeleteUserScreen> {
  final databaseRepository = DatabaseRepository();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = '';
  String? selectedEmail;
  String email = "";



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
                            hintText: 'Hľadaj email',
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

                                     EmailSuggestionsList(
                                  searchQuery: _searchQuery,
                                  onEmailSelected: (email) {
                                    setState(() {
                                      selectedEmail = email;
                                    });
                                  },
                                )

                              ]
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
                            ElevatedButton(
                              onPressed: () async {
                                if(selectedEmail != null){
                                  // log(selectedEmail!);
                                  // log(await getUserIdByEmail(selectedEmail!));
                                  databaseRepository.removeUserCompletely(await databaseRepository.getUserIdByEmail(selectedEmail!));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF1249),
                                side: BorderSide(color: Colors.white, width: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 14.h),
                              ),
                              child: Text(
                                'Odstraniť',
                                style: GoogleFonts.titanOne(
                                  fontSize: 10.sp,
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







