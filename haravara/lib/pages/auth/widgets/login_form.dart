import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/auth/services/auth_screen_service.dart';
import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

final loginauthService = AuthService();

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm();
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  var _enteredEmail = '';
  var userId = '';
  final _formKey = GlobalKey<FormState>();
  bool isButtonDisabled = false;
  bool rememberPhone = false;

  @override
  void initState() {
    _emailFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    final deviceHeight = MediaQuery.of(context).size.height;
    var loginHeight = 120;
    if (deviceHeight < 850) {
      loginHeight = 120;
    }

    return Container(
      key: _formKey,
      width: 220.w,
      height: loginHeight.h,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 24, 191, 186),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  19.verticalSpace,
                  FormRow(
                    title: 'E-MAIL',
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    inputType: TextInputType.emailAddress,
                  ),
                  5.verticalSpace,
                ],
              ),
            ],
          ),
          ConfirmButton(
            text: 'PRIHLÁS SA',
            onPressed: isButtonDisabled ? () {} : _submitAndValidate,
          ),
        ],
      ),
    );
  }

  void _submitAndValidate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      showSnackBar(context,
          'Prosím, zadajte platnú e-mailovú adresu alebo užívateľ existuje');
      return;
    }
    _enteredEmail = _emailController.text;
    _handleLogin();
  }

  Future<void> _handleLogin() async {
    final userId = await loginauthService.findUserByEmail(_enteredEmail);
    if (userId.isEmpty || userId.compareTo('null') == 0) {
      showSnackBar(context, 'Nemôžeme nájsť váš e-mail, radšej sa registrujte');
      isButtonDisabled = false;
      return;
    }

    log('User found with userId: $userId');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _enteredEmail);

    final isAdmin = await DatabaseService().isAdmin(_enteredEmail);
    if (isAdmin) {
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        log('Admin signed in anonymously: ${userCredential.user?.uid}');

        routeToAdminScreen(context);
      } catch (error) {
        showSnackBar(context, 'Admin login failed: $error');
      }
      isButtonDisabled = false;
      return;
    }

    await loginauthService.sendSignInWithEmailLink(_enteredEmail);

    isButtonDisabled = false;
    showSnackBar(context,
        'An email link has been sent. Please check your email to complete login.');
  }
}
