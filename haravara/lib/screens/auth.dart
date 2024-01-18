import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/screens/google_map_second_screen.dart';
import 'package:haravara/services/auth_service.dart';
import 'package:haravara/services/database_service.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:haravara/widgets/header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/widgets.dart' as Flutter;

var uuid = const Uuid();
final databaseService = DatabaseService();
final authService = AuthService();

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPhone = '';
  var _enteredUsername = '';
  var _enteredCode = '';
  bool isCodeSent = false;
  bool isInputByPhoneNumber = false;
  late String code;

  @override
  void initState() {
    super.initState();
  }

  void _submitCode() async {
    _formKey.currentState!.save();

    if (_enteredCode.compareTo(code) == 1) {
      _showSnackBar('Not valid');
      return;
    }

    if (_isLogin) {
      await authService.loginUserByEmail(_enteredEmail);
    } else {
      await authService.registerUserByEmail(_enteredEmail, _enteredUsername);
    }

    _showSnackBar('Success');
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    if (_isLogin) {
      _handleLogin();
    } else {
      _handleRegistration();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget codeContent = TextFormField(
      decoration: const InputDecoration(
        labelText: 'Enter your code here',
        prefixIcon: Icon(Icons.add_to_home_screen_sharp),
      ),
      autocorrect: false,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.none,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Write code';
        }
        return null;
      },
      onSaved: (value) {
        _enteredCode = value!;
      },
    );
    print(MediaQuery.of(context).size.width.w * 0.9);
    print(MediaQuery.of(context).size.height.h * 0.28);
    ScreenUtil.init(context,
        designSize: const Size(430, 932), minTextAdapt: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Header(showMenu: false),
                SizedBox(height: 20.h),
                Text(
                  'PRIHLÁSENIE',
                  style: GoogleFonts.titanOne(
                      fontSize: 34.sp,
                      color: const Color.fromARGB(255, 1, 199, 67),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20.h),
                LayoutBuilder(builder: (context, constraints) {
                  return FractionallySizedBox(
                    widthFactor: 0.9.w,
                    child: AspectRatio(
                      aspectRatio: constraints.maxWidth *
                          2.3 /
                          (constraints.maxWidth + (_isLogin ? 85 : 285)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 177, 235, 183),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 91, 187, 75)
                                  .withOpacity(1),
                              spreadRadius: 8,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30.h,
                                    ),
                                    SizedBox(
                                      width: 300.w,
                                      child: TextFormField(
                                        autocorrect: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          label: Center(
                                            child: Text(
                                              'E-MAIL PÁTRAČA',
                                              style: GoogleFonts.titanOne(
                                                color: const Color.fromARGB(
                                                    255, 86, 162, 73),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 20.sp,
                                              ),
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                  128, 86, 162, 73),
                                              width: 4.w,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                  128, 86, 162, 73),
                                              width: 4.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (!_isLogin)
                                      SizedBox(
                                        width: 300.w,
                                        child: TextFormField(
                                          autocorrect: true,
                                          keyboardType: TextInputType.name,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold),
                                          decoration: InputDecoration(
                                            label: Center(
                                              child: Text(
                                                'POUŽÍVATEĽSKÉ MENO',
                                                style: GoogleFonts.titanOne(
                                                  color: const Color.fromARGB(
                                                      255, 86, 162, 73),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 20.sp,
                                                ),
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    128, 86, 162, 73),
                                                width: 4.w,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: const Color.fromARGB(
                                                    128, 86, 162, 73),
                                                width: 4.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: _isLogin ? 20.h : 22.h),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        textStyle: GoogleFonts.titanOne(
                                            fontSize: 20.sp),
                                        foregroundColor: const Color.fromARGB(
                                            255, 86, 162, 73),
                                        backgroundColor: const Color.fromARGB(
                                            255, 155, 221, 153),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(34.0),
                                          side: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 91, 187, 75),
                                              width: 4.0.w),
                                        ),
                                      ),
                                      onPressed:
                                          isCodeSent ? _submitCode : _submit,
                                      child: SizedBox(
                                        width: 150.w,
                                        height: 50.h,
                                        child: Center(
                                            child: Text(_isLogin
                                                ? 'PRIHLÁS SA'
                                                : 'REGISTRÁCIA')),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 10.h),
                TextButton(
                  child: Text('Nie si ešte prihlásený? ZAREGISTRUJ SA!',
                      style: GoogleFonts.titanOne(
                          fontSize: 16.sp,
                          color: const Color.fromARGB(255, 86, 162, 73),
                          fontWeight: FontWeight.w500)),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                ),
                if (_isLogin) SizedBox(height: 72.h),
                Expanded(
                  child: Stack(
                    children: [
                      const Footer(),
                      Positioned(
                        left: 170.w,
                        child: Flutter.Image.asset(
                          'assets/Hero.jpeg',
                          height: 340.h,
                          width: 250.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _handleLogin() async {
    List<String> deviceInfo = await authService.getDeviceDetails();
    final userId = await authService.findUserByEmail(_enteredEmail);
    if (userId.isEmpty || userId.compareTo('null') == 0) {
      _showSnackBar('We cant find your email, register instead');
      return;
    }
    User user = await authService.getUserById(userId);
    if (user.phoneIds.contains(deviceInfo[0])) {
      await setLoginPreferences(user.email!, user.userId!);
      _showSnackBar('Success');
    } else {
      onSendCode();
    }
  }

  Future<void> _handleRegistration() async {
    final userId = await authService.findUserByEmail(_enteredEmail);
    if (userId.isEmpty) {
      _showSnackBar('This email already exists');
      return;
    }
    onSendCode();
  }

  onSendCode() async {
    final sentCode = await authService.sendEmail(context);
    setState(() {
      code = sentCode;
      isCodeSent = true;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  setLoginPreferences(String email, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setString('email', email);
    prefs.setString('id', id);
  }
}
