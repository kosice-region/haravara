import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/providers/auth_provider.dart';
import 'package:haravara/pages/auth/services/auth_screen_service.dart';
import 'package:haravara/pages/auth/view/auth_screen.dart';
import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
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
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();
  var isButtonDisabled = false;
  var _enteredEmail = '';
  var _enteredUsername = '';
  bool isFamily = false;
  bool rememberPhone = false;
  DatabaseRepository DBrep = DatabaseRepository();

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
      registrationHeight = 200;
      familyRegistrationHeight = 250;
    }
    if (deviceHeight < 700) {
      registrationHeight = 225;
      familyRegistrationHeight = 265;
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
                        isFamily ? 'MENO RODINNÉHO TÍMU' : 'MENO POUŽÍVATEĽA',
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
                        text: 'PÁTRAŤ\' AKO RODINA',
                        onChanged: _toggleIsFamily,
                      ),
                      20.verticalSpace,
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
    log('REGISTRATION - Start registration process');

    final userId = await authService.findUserByEmail(_enteredEmail);
    log('REGISTRATION - Checking if user already exists with email: $_enteredEmail');

    if (userId.isNotEmpty) {
      showSnackBar(context,'Tento e-mail už existuje');
      isButtonDisabled = false;
      return;
    }
    if(await DBrep.isUserNameUsed(_enteredUsername)){
      showSnackBar(context, 'Toto meno už niekto používa');

      isButtonDisabled = false;
      return;
    }

    if (selectedLocation.isEmpty) {

      showSnackBar(context, 'Zadajte prosím lokáciu');

      isButtonDisabled = false;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _enteredEmail);
    log('REGISTRATION - Email stored locally: $_enteredEmail');

    await ref.read(userInfoProvider.notifier).updateProfileType(isFamily);
    log('REGISTRATION - Profile type updated (isFamily): $isFamily');

    int? children = int.tryParse(childrenCount) ?? -1;
    await ref.read(userInfoProvider.notifier).updateCountOfChildren(children);
    log('REGISTRATION - Children count updated: $children');

    ref
        .read(authNotifierProvider.notifier)
        .setEnteredUsername(_enteredUsername);
    ref.read(authNotifierProvider.notifier).setEnteredEmail(_enteredEmail);
    ref.read(authNotifierProvider.notifier).setEnteredChildren(children);
    ref.read(authNotifierProvider.notifier).setLocation(selectedLocation);
    ref.read(authNotifierProvider.notifier).toggleFamilyState(isFamily);
    ref.read(authNotifierProvider.notifier).toggleRememberState(rememberPhone);

    log('REGISTRATION - State updated with username: ${ref.read(authNotifierProvider).enteredUsername}');
    log('REGISTRATION - State updated with email: ${ref.read(authNotifierProvider).enteredEmail}');
    log('REGISTRATION - State updated with children: ${ref.read(authNotifierProvider).children}');
    log('REGISTRATION - State updated with location: ${ref.read(authNotifierProvider).location}');
    log('REGISTRATION - Family state: ${ref.read(authNotifierProvider).isFamily}');
    log('REGISTRATION - Remember phone state: ${ref.read(authNotifierProvider).isNeedToRemeber}');

    await authService.sendSignInWithEmailLink(_enteredEmail);
    log('REGISTRATION - Sign-in email link sent to: $_enteredEmail');

    isButtonDisabled = false;
    showSnackBar(context,
        'An email link has been sent. Please check your email to complete registration.');
    log('REGISTRATION - Registration process complete');
  }

  void _toggleIsFamily(bool value) {
    setState(() {
      isFamily = value;
    });
    setState(() {
      childrenCount = '1';
    });
  }
}
