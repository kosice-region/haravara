import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/screens/google_map_second_screen.dart';
import 'package:haravara/services/auth_service.dart';
import 'package:haravara/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GoogleMapSecondScreen()));
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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _isLogin ? 'SIGN IN' : 'REGISTER',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35.0.h),
                SizedBox(
                  height: 155.h,
                  width: 350.w,
                  child: isCodeSent
                      ? codeContent
                      : Column(
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: isInputByPhoneNumber
                                        ? 'Number'
                                        : 'Email',
                                    prefixIcon: Icon(isInputByPhoneNumber
                                        ? Icons.phone_android_rounded
                                        : Icons.email),
                                  ),
                                  autocorrect: false,
                                  keyboardType: _isLogin
                                      ? TextInputType.emailAddress
                                      : isInputByPhoneNumber
                                          ? TextInputType.phone
                                          : TextInputType.none,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email or Phone number can\'t be empty';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null && value.contains('@')) {
                                      _enteredEmail = value;
                                    } else if (value != null) {
                                      _enteredPhone = value;
                                    }
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12.0.h),
                                  child: TextButton.icon(
                                    icon: Icon(
                                      !isInputByPhoneNumber
                                          ? Icons.phone_android_outlined
                                          : Icons.email,
                                      color: Colors.grey,
                                    ),
                                    label: Text(
                                      isInputByPhoneNumber
                                          ? 'via email'
                                          : 'via number',
                                      style:
                                          GoogleFonts.lato(color: Colors.grey),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isInputByPhoneNumber =
                                            !isInputByPhoneNumber;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25.0.h),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person_4),
                                ),
                                keyboardType: TextInputType.none,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name can\'t be empty';
                                  }
                                  return null;
                                },
                                onSaved: (username) {
                                  _enteredUsername = username!;
                                },
                              ),
                          ],
                        ),
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Don\'t have an account?' : 'Have an account?',
                      style: GoogleFonts.lato(color: Colors.grey),
                    ),
                    TextButton(
                      child: Text(_isLogin ? 'Register' : 'Login'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.lato(fontSize: 20.sp),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: isCodeSent ? _submitCode : _submit,
                  child: SizedBox(
                    width: 150.w,
                    height: 50.h,
                    child: Center(child: Text(_isLogin ? 'LOGIN' : 'REGISTER')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const GoogleMapSecondScreen()));
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
