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
import 'package:haravara/widgets/header_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/widgets.dart';

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
  var _isLogin = false;
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
    ScreenUtil.init(context, designSize: const Size(255, 516));
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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(top: 8).h,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    const Header(showMenu: false),
                    15.verticalSpace,
                    Text(
                      'PRIHLÁSENIE',
                      style: GoogleFonts.titanOne(
                          fontSize: 18.sp,
                          color: const Color.fromARGB(255, 86, 162, 73),
                          fontWeight: FontWeight.w500),
                    ),
                    5.verticalSpace,
                    Container(
                      width: 220.w,
                      height: _isLogin ? 100.h : 161.h,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)).r,
                        color: const Color.fromARGB(255, 177, 235, 183),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 91, 187, 75)
                                .withOpacity(1),
                            spreadRadius: 8,
                            blurRadius: 8,
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
                                  3.verticalSpace,
                                  SizedBox(
                                    width: 166.w,
                                    child: TextFormField(
                                      autocorrect: false,
                                      keyboardType: TextInputType.emailAddress,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        label: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15).r,
                                          child: Center(
                                            child: Text(
                                              'E-MAIL PÁTRAČA',
                                              style: GoogleFonts.titanOne(
                                                color: const Color.fromARGB(
                                                    255, 86, 162, 73),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 155, 221, 153),
                                            width: 4.w,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 155, 221, 153),
                                            width: 4.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!_isLogin) 10.verticalSpace,
                                  if (!_isLogin)
                                    SizedBox(
                                      width: 166.w,
                                      child: TextFormField(
                                        autocorrect: true,
                                        keyboardType: TextInputType.name,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          label: Center(
                                            child: Text(
                                              'POUŽÍVATEĽSKÉ MENO',
                                              style: GoogleFonts.titanOne(
                                                color: const Color.fromARGB(
                                                    255, 86, 162, 73),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 155, 221, 153),
                                              width: 4.w,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 155, 221, 153),
                                              width: 4.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  10.verticalSpace,
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      textStyle:
                                          GoogleFonts.titanOne(fontSize: 11.sp),
                                      foregroundColor: const Color.fromARGB(
                                          255, 86, 162, 73),
                                      backgroundColor: const Color.fromARGB(
                                          255, 155, 221, 153),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                                Radius.circular(34))
                                            .w,
                                        side: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 91, 187, 75),
                                            width: 4.0.w),
                                      ),
                                    ),
                                    onPressed:
                                        isCodeSent ? _submitCode : _submit,
                                    child: SizedBox(
                                      width: 100.w,
                                      height: 20.h,
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
                    10.verticalSpace,
                    TextButton(
                      child: Text(
                          !_isLogin
                              ? "Máte už konto? Prihlás sa."
                              : 'Nie si ešte prihlásený? ZAREGISTRUJ SA!',
                          style: GoogleFonts.titanOne(
                              fontSize: 10.sp,
                              color: const Color.fromARGB(255, 86, 162, 73),
                              fontWeight: FontWeight.w500)),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0.h,
                        child: const Footer(
                          height: 160,
                          boxFit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0.h,
                        left: 105.w,
                        child: Image.asset(
                          'assets/Hero.jpeg',
                          width: 138.w,
                          height: 160.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
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
