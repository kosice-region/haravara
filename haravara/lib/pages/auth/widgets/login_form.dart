import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/Popup.dart';
import '../services/auth_service.dart';

final loginauthService = AuthService();

class LoginForm extends ConsumerStatefulWidget {
  final VoidCallback toggleMode;
  const LoginForm({Key? key, required this.toggleMode}) : super(key: key);

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
    return Container(
      key: _formKey,
      width: 220.w,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 24, 191, 186),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 4),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          SizedBox(height: 5.h),
          ConfirmButton(
            text: 'PRIHLÁS SA',
            onPressed: isButtonDisabled ? () {} : _submitAndValidate,
          ),
          SizedBox(height: 10.h),
          SwitchMode(
            text: 'Nie si ešte zaregistrovaný? ZAREGISTRUJ SA!',
            onPressed: widget.toggleMode,
          ),
        ],
      ),
    );
  }

  void _submitAndValidate() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Error',
            content:
                'Prosím, zadajte platnú e-mailovú adresu alebo užívateľ existuje',
          );
        },
      );
      return;
    }
    _enteredEmail = _emailController.text;
    _handleLogin();
  }

  Future<void> _handleLogin() async {
    final userId = await loginauthService.findUserByEmail(_enteredEmail);
    if (userId.isEmpty || userId.compareTo('null') == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Error',
            content: 'Nemôžeme nájsť váš e-mail, radšej sa registrujte',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }

    log('User found with userId: $userId');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _enteredEmail);

    await loginauthService.sendSignInWithEmailLink(_enteredEmail);

    isButtonDisabled = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Popup(
          title: 'Úspech',
          content:
              'E-mailový odkaz bol odoslaný. Pre dokončenie prihlásenia skontrolujte svoj e-mail.',
        );
      },
    );
  }
}
