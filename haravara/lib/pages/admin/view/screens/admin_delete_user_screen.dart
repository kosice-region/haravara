
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/database_repository.dart';
import '../../../../core/widgets/Popup.dart';
import '../../../auth/services/auth_service.dart';
import '../../../auth/widgets/location_field.dart';
import '../../../leaderBoard/providers/userList.dart';
import '../../../profile/providers/avatars.provider.dart';
import '../../../profile/providers/user_info_provider.dart';
import '../../../profile/widgets/action_buttons.dart';

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
  late String userId = "";
  int _currentChildrenCount = 0;
  int? _selectedChildrenCount = 1;
  late String username;
  late String newUsername = '';
  String selectedCity = '';


  @override
  initState() {
    super.initState();
  }

  // test(String email) async{
  //   userId = await databaseRepository.getUserIdByEmail(email);
  //   userProfile = await authRepository.getUserProfile(userId);
  //   _currentChildrenCount = userProfile?['children'];
  // }

  updateChildrenCount(int newCount) async {
    try {
      userId = await databaseRepository.getUserIdByEmail(selectedEmail!);
      print(userId);
      Map<String, dynamic>? userProfile = await authRepository.getUserProfile(userId);
      final avatar;
      int children;
      String city;

      if (userProfile != null) {
         avatar= userProfile['avatar'];
         print(avatar);
         children = userProfile['children'];
         print(children);
         city = userProfile['location'];
         print(city);
      }else{
        return;
      }

      String userProfileType =
      newCount > 0 ? 'family' : 'individual';

      await authRepository.updateUserProfile(
          userId, avatar, userProfileType, city, newCount);


      debugPrint('Zmenení počeť detí na $newCount');
      userId = "";
      // Show a confirmation dialog to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Zmenení počeť detí na $newCount!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      userId = "";
      debugPrint('Error updating children count: $e');
      // Show an error dialog to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Nepodarilo sa zmeniť počeť detí.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    userId = "";
  }


  Future<bool> _updateUsername() async {
    userId = await databaseRepository.getUserIdByEmail(selectedEmail!);
    if (newUsername.isEmpty || newUsername == "") {
      userId = "";
      return true;
    }
    if (newUsername.length < 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          userId = "";
          return Popup(title:'Error',content: 'Meno musí obsahovať aspoň 3 znaky',);
        },
      );
      userId = "";
      return false;
    }
    if (await DBrep.isUserNameUsed(newUsername)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          userId = "";
          return Popup(title:'Error',content: 'Toto meno už niekto používa',);
        },
      );
      return false;
    } else {

      await authRepository.updateUserName(newUsername, userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Meno zmenené na $newUsername'),
            backgroundColor: Colors.green,
          ),
        );
      }
      userId = "";
      return true;
    }
  }

  void _showUsernameDialog(BuildContext context) {
    bool changedName = false;
    bool changedCount = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              'Upraviť údaje',
              style: GoogleFonts.titanOne(),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 200,
                  child: TextField(
                    autofocus: true,
                    maxLength: 20,
                    onChanged: (value) {
                      changedName = true;
                      setState(() {
                        newUsername = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Nové meno',
                      hintStyle: GoogleFonts.titanOne(
                        color: Color.fromARGB(255, 188, 95, 190),
                        fontWeight: FontWeight.w300,
                        fontSize: 11.sp,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 188, 95, 190),
                          width: 3.w,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 188, 95, 190),
                          width: 3.w,
                        ),
                      ),
                    ),
                    style: GoogleFonts.titanOne(
                      color: Color.fromARGB(255, 188, 95, 190),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // --- CONDITIONALLY VISIBLE WIDGET: Dropdown for children count ---
                DropdownButtonFormField<int>(
                  value: _currentChildrenCount,
                  decoration: const InputDecoration(
                    labelText: 'Zvolte počeť detí',
                    border: OutlineInputBorder(),
                  ),

                  items: [0 ,1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    changedCount = true;
                    setState(() {
                      _selectedChildrenCount = newValue;
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Zrušiť',
                  style: GoogleFonts.titanOne(
                    color: Color.fromARGB(255, 188, 95, 190),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if(changedCount){
                    final int newCount = _selectedChildrenCount ?? 0;
                    updateChildrenCount(newCount);
                    print(newCount);
                  }
                  else if (changedName && newUsername != "") {
                    await _updateUsername();
                    print(newUsername);
                  }
                  else{
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Nič ste neupravily'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }

                  }
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Uložiť',
                  style: GoogleFonts.titanOne(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 188, 95, 190),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ),
            ],
          );
        });
  }


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
                                if(selectedEmail == null)
                                     EmailSuggestionsList(
                                  searchQuery: _searchQuery,
                                  onEmailSelected: (email) {
                                    // test(email);
                                    setState(() {
                                      selectedEmail = email;
                                    });
                                  },
                                )
                                else if (selectedEmail != null)
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child:
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                if(selectedEmail != null){
                                                  _showUsernameDialog(context);
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                side: BorderSide(color: Colors.white, width: 5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.w, vertical: 14.h),
                                              ),
                                              child: Text(
                                                'Upraviť uživatela',
                                                style: GoogleFonts.titanOne(
                                                  fontSize: 10.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                    Row(
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
                                      ]
                                    ),
                                  ),
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







