import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/repositories/database_repository.dart';
import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/pages/auth/services/auth_service.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/pages/web_view/view/web_view_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../core/widgets/Popup.dart';

var uuid = const Uuid();
final authService = AuthService();

class RegistrationForm extends ConsumerStatefulWidget {
  final VoidCallback toggleMode;
  const RegistrationForm({Key? key, required this.toggleMode})
      : super(key: key);

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  final DatabaseRepository databaseRepository = DatabaseRepository();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool isButtonDisabled = false;
  bool isFamily = false;
  bool rememberPhone = false;
  bool _acceptGDPRandVOP = false;
  String _enteredEmail = '';
  String _enteredUsername = '';
  String childrenCount = '';
  String selectedLocation = '';

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

    final userNameUsed =
        await databaseRepository.isUserNameUsed(_enteredUsername);
    if (userId.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Error',
            content: 'Tento e-mail už existuje',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }
    if (selectedLocation.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Chýbajuce dáta',
            content: 'Zadajte prosím lokaciu',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }
    if (userNameUsed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Error',
            content: 'Toto meno už niekto použiva',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _enteredEmail);
    await prefs.setString('username', _enteredUsername);
    await prefs.setString('location', selectedLocation);
    await prefs.setBool('isFamily', isFamily);
    await prefs.setInt('childrenCount', int.tryParse(childrenCount) ?? -1);
    await prefs.setBool('rememberPhone', rememberPhone);

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Popup(
          title: 'Úspech',
          content:
              'E-mailový odkaz bol odoslaný. Pre dokončenie registrácie skontrolujte svoj e-mail.',
        );
      },
    );
  }

  void _submitAndValidate() async {
    isButtonDisabled = true;
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_acceptGDPRandVOP) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Chýbajuce dáta',
            content:
                'Musíte súhlasiť so spracovaním osobných údajov (GDPR) a VOP.',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }
    if (_emailController.text.isEmpty ||
        !_emailController.text.contains('@') ||
        _emailController.text == 'const User Exist') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Chýbajuce dáta',
            content:
                'Prosím, zadajte platnú e-mailovú adresu alebo užívateľ existuje',
          );
        },
      );
      isButtonDisabled = false;
      return;
    }
    if (_usernameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(
            title: 'Chýbajuce dáta',
            content: 'Meno nesmie byť prázdne',
          );
        },
      );
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
                  title: isFamily ? 'MENO RODINNÉHO TÍMU' : 'MENO POUŽÍVATEĽA',
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
                  text: 'Pátrať ako rodina',
                  onChanged: _toggleIsFamily,
                ),
                CheckButton(
                  value: _acceptGDPRandVOP,
                  text: 'Som oboznámený s',
                  clickableText: 'GDPR',
                  hasClickablePart: true,
                  onClickableTextTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => WebViewContainer(
                            url:
                                'https://docs.google.com/viewer?url=https://org.kosiceregion.com/wp-content/uploads/2025/04/GDPR-oboznamenie_Haravara_final.pdf'),
                      ),
                    );
                  },
                  secondClickableText: 'VOP',
                  onSecondClickableTextTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => WebViewContainer(
                            url:
                                'https://docs.google.com/viewer?url=https://org.kosiceregion.com/wp-content/uploads/2025/04/VOP_aplikacia-Haravara_final.pdf'),
                      ),
                    );
                  },
                  onChanged: (bool value) {
                    setState(() {
                      _acceptGDPRandVOP = value;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                ConfirmButton(
                  text: 'REGISTRÁCIA',
                  onPressed: isButtonDisabled ? () {} : _submitAndValidate,
                ),
                SizedBox(height: 10.h),
                SwitchMode(
                  text: "Máte už konto? Prihlás sa.",
                  onPressed: widget.toggleMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
