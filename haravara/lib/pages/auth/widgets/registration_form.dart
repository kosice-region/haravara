import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/providers/auth_provider.dart';
import 'package:haravara/pages/auth/services/auth_screen_service.dart';
import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:haravara/router/router.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:haravara/router/screen_router.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();
  var isButtonDisabled = false;
  var _enteredEmail = '';
  var _enteredUsername = '';
  bool isFamily = false;
  bool rememberPhone = false;

  String childrenCount = '';
  String selectedLocation = '';

  void _submitAndValidate() async {
    isButtonDisabled = true;
    FocusManager.instance.primaryFocus?.unfocus();
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
  void initState() {
    _usernameFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var registrationHeight = 200;
    var familyRegistrationHeight = 230;
    if (deviceHeight < 850) {
      registrationHeight = 220;
      familyRegistrationHeight = 240;
    }
    if (deviceHeight < 700) {
      registrationHeight = 225;
      familyRegistrationHeight = 245;
    }

    return Container(
      key: _formKey,
      width: 220.w,
      height: isFamily ? familyRegistrationHeight.h : registrationHeight.h,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Color.fromARGB(255, 249, 175, 97),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 188, 95, 190).withOpacity(1),
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
                  FormRow(
                    title: isFamily ? 'E-MAIL RODINY' : 'E-MAIL PÁTRAČA',
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    inputType: TextInputType.emailAddress,
                  ),
                  FormRow(
                    title:
                        isFamily ? 'MENO RODINNEHO TIMU' : 'POUŽÍVATEĽSKÉ MENO',
                    controller: _usernameController,
                    focusNode: _usernameFocusNode,
                    inputType: TextInputType.name,
                  ),
                  5.verticalSpace,
                  LocationField(
                    onLocationSelected: (location) {
                      setState(() {
                        selectedLocation = location;
                      });
                    },
                  ),
                  Column(
                    children: [
                      if (isFamily)
                        ChildrenCount(
                          onChanged: _updateChildrenCount,
                        ),
                      CheckButton(
                        value: isFamily,
                        text: 'Patrat\' ako rodina',
                        onChanged: _toggleIsFamily,
                      ),
                      CheckButton(
                        value: rememberPhone,
                        text: 'Remember this phone',
                        onChanged: _toggleRememberMe,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ConfirmButton(
            text: 'REGISTRÁCIA',
            onPressed: isButtonDisabled ? () {} : _submitAndValidate,
          ),
        ],
      ),
    );
  }

  void _updateChildrenCount(String newValue) {
    setState(() {
      childrenCount = newValue;
    });
  }

  Future<void> _handleRegistration() async {
    final userId = await authService.findUserByEmail(_enteredEmail);
    if (userId.isNotEmpty) {
      showSnackBar(context, 'Tento e-mail už existuje');
      isButtonDisabled = false;
      return;
    }
    if (selectedLocation.isEmpty) {
      showSnackBar(context, 'Zadajte prosim lokaciu');
      isButtonDisabled = false;
      return;
    }

    int? children = int.tryParse(childrenCount);
    ref.read(authNotifierProvider.notifier).toggleRememberState(rememberPhone);
    ref
        .read(authNotifierProvider.notifier)
        .setEnteredUsername(_enteredUsername);
    ref.read(authNotifierProvider.notifier).setEnteredEmail(_enteredEmail);
    ref.read(authNotifierProvider.notifier).toggleLoginState(false);
    ref.read(authNotifierProvider.notifier).toggleFamilyState(isFamily);
    ref.read(authNotifierProvider.notifier).setEnteredChildren(children ?? -1);
    ref.read(authNotifierProvider.notifier).setLocation(selectedLocation);
    onSendCode();
    isButtonDisabled = false;
  }

  onSendCode() async {
    final sentCode = await authService.sendEmail(context, _enteredEmail);
    ref.read(routerProvider.notifier).changeScreen(ScreenType.code);
    ref.read(authNotifierProvider.notifier).updateCode(sentCode);
    routeToCodeScreen(context);
  }

  void routeToNewsScreen() async {
    if (!mounted) return;
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.news));
  }

  void _toggleIsFamily(bool value) {
    setState(() {
      isFamily = value;
    });
  }

  void _toggleRememberMe(bool value) {
    setState(() {
      rememberPhone = value;
    });
  }
}
