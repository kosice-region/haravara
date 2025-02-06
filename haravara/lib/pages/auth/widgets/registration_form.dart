import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/providers/auth_provider.dart';
import 'package:haravara/pages/auth/services/auth_screen_service.dart';
import 'package:haravara/pages/auth/view/auth_screen.dart';
import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/pages/web_view/view/web_view_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/repositories/database_repository.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool isButtonDisabled = false;
  bool isFamily = false;
  bool rememberPhone = false;
  bool _acceptGDPR = false;
  String _enteredEmail = '';
  String _enteredUsername = '';
  String childrenCount = '';
  String selectedLocation = '';

  DatabaseRepository DBrep = DatabaseRepository();

  @override
  void initState() {
    _usernameFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _updateChildrenCount(String newValue) {
    setState(() {
      childrenCount = newValue;
    });
  }

  void _toggleIsFamily(bool value) {
    setState(() {
      isFamily = value;
      if (isFamily && childrenCount.isEmpty) {
        childrenCount = '1';
      }
    });
  }

  Future<void> _handleRegistration() async {
    log('REGISTRATION - Start registration process');
    final userId = await authService.findUserByEmail(_enteredEmail);
    if (userId.isNotEmpty) {
      showSnackBar(context, 'Tento e-mail už existuje');
      isButtonDisabled = false;
      return;
    }
    if (selectedLocation.isEmpty) {
      showSnackBar(context, 'Zadajte prosím lokaciu');
      isButtonDisabled = false;
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _enteredEmail);
    await ref.read(userInfoProvider.notifier).updateProfileType(isFamily);
    int? children = int.tryParse(childrenCount) ?? -1;
    await ref.read(userInfoProvider.notifier).updateCountOfChildren(children);
    ref
        .read(authNotifierProvider.notifier)
        .setEnteredUsername(_enteredUsername);
    ref.read(authNotifierProvider.notifier).setEnteredEmail(_enteredEmail);
    ref.read(authNotifierProvider.notifier).setEnteredChildren(children);
    ref.read(authNotifierProvider.notifier).setLocation(selectedLocation);
    ref.read(authNotifierProvider.notifier).toggleFamilyState(isFamily);
    ref.read(authNotifierProvider.notifier).toggleRememberState(rememberPhone);
    await authService.sendSignInWithEmailLink(_enteredEmail);
    isButtonDisabled = false;
    showSnackBar(
      context,
      'An email link has been sent. Please check your email to complete registration.',
    );
  }

  void _submitAndValidate() async {
    isButtonDisabled = true;
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_acceptGDPR) {
      showSnackBar(
          context, 'Musíte súhlasiť so spracovaním osobných údajov (GDPR).');
      isButtonDisabled = false;
      return;
    }
    if (_emailController.text.isEmpty ||
        !_emailController.text.contains('@') ||
        _emailController.text == 'const User Exist') {
      showSnackBar(context,
          'Prosím, zadajte platnú e-mailovú adresu alebo užívateľ existuje');
      isButtonDisabled = false;
      return;
    }
    if (_usernameController.text.isEmpty) {
      showSnackBar(context, 'Meno nesmie byť prázdne');
      isButtonDisabled = false;
      return;
    }
    _enteredUsername = _usernameController.text;
    _enteredEmail = _emailController.text;
    await _handleRegistration();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        width: 300,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 24, 191, 186),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Column(
          key: _formKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                FormRow(
                  title: isFamily ? 'E-MAIL RODINY' : 'E-MAIL PÁTRAČA',
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  inputType: TextInputType.emailAddress,
                ),
                FormRow(
                  title: isFamily ? 'MENO RODINNEHO TIMU' : 'MENO POUŽÍVATEĽA',
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  inputType: TextInputType.name,
                ),
                SizedBox(height: 5.h),
                LocationField(
                  onLocationSelected: (location) {
                    setState(() {
                      selectedLocation = location;
                    });
                  },
                ),
                if (isFamily)
                  ChildrenCount(
                    onChanged: _updateChildrenCount,
                  ),
                CheckButton(
                  value: isFamily,
                  text: 'Patrať ako rodina',
                  onChanged: _toggleIsFamily,
                ),
                CheckButton(
                  value: _acceptGDPR,
                  text: 'Súhlasím s',
                  clickableText: 'GDPR',
                  hasClickablePart: true,
                  onClickableTextTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => WebViewContainer(
                            url: 'https://www.haravara.sk/gdpr/'),
                      ),
                    );
                  },
                  onChanged: (bool value) {
                    setState(() {
                      _acceptGDPR = value;
                    });
                  },
                ),
                SizedBox(height: 10.h),
              ],
            ),
            ConfirmButton(
              text: 'REGISTRÁCIA',
              onPressed: isButtonDisabled ? () {} : _submitAndValidate,
            ),
          ],
        ),
      ),
    );
  }
}
