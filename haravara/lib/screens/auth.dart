import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/services/auth_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredUsername = '';

  @override
  void initState() {
    super.initState();
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    if (await AuthService().findUserByEmail(_enteredEmail)) {
      _enteredEmail = 'const User Exist';
      _formKey.currentState!.validate();
    } else {
      final id = uuid.v4();
      List<String> deviceInfo = await AuthService().getDeviceDetails();
      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'username': _enteredUsername,
        'email': _enteredEmail,
        'phone_id': deviceInfo[0],
        'device_type': deviceInfo[1],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value != null &&
                                  value == 'const User Exist') {
                                return 'User with this email Exists';
                              }
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'username',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'username is empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                          SizedBox(height: 12.h),
                          ElevatedButton(
                            onPressed: _submit,
                            child: Text(_isLogin ? 'Login' : 'Sign Up'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create an Account'
                                : 'I already have an account.Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
