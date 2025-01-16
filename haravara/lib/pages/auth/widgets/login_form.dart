import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/pages/admin/view/screens/admin_screen.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:haravara/pages/auth/services/auth_screen_service.dart';
import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/router/router.dart';

import '../../../core/providers/preferences_provider.dart';
import '../../profile/providers/providers.dart';
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
    var deviceHeight = MediaQuery.of(context).size.height;
    var loginHeight = 120;
    if (deviceHeight < 850) {
      loginHeight = 120;
    }

    return Container(
      key: _formKey,
      width: 220.w,
      height: loginHeight.h,
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

  void _toggleRememberMe(bool value) {
    setState(() {
      rememberPhone = value;
    });
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

  // Updating USER_ID in UserInfoProvider and SharedPreferences
  await ref.read(userInfoProvider.notifier).updateUserId(userId);
  this.userId = userId;
  List<String> deviceInfo = await loginauthService.getDeviceDetails();
  User? user = await loginauthService.getUserById(userId);
  if (user == null) {
    showSnackBar(context, 'User not found.');
    isButtonDisabled = false;
    return;
  }

  await DatabaseService().saveUserAvatarsLocally(userId);
  final List<UserAvatar> avatars = await DatabaseService().loadAvatars();
  await loginauthService.getCollectedPlacesByUser(userId);
  ref.read(avatarsProvider.notifier).addAvatars(avatars);

  bool isFamily = user.userProfile!.profileType == ProfileType.family;
  String updateUsername = user.username;

  // Updating user info in UserInfoProvider
  await ref.read(userInfoProvider.notifier).updateUsername(updateUsername);
  await ref.read(userInfoProvider.notifier).updateProfileType(isFamily);
  await ref.read(userInfoProvider.notifier).updateCountOfChildren(user.userProfile!.children ?? -1);
  int children = user.userProfile!.children ?? -1;
  String location = user.userProfile!.location ?? '';

  final isAdmin = await DatabaseService().isAdmin(user.email!);

  if (isAdmin) {
      routeToAdminScreen(context);
    } else {
      // Not an admin, then follow the existing device verification logic
      if (user.phones.contains(deviceInfo[0])) {
        ref.read(avatarsProvider.notifier).updateAvatar(user.userProfile!.avatar!);

        ref.read(routerProvider.notifier).changeScreen(ScreenType.news);
        ref.read(loginNotifierProvider.notifier).login(
          user.username,
          user.email!,
          user.id!,
          children,
          location,
        );
        ref.read(userInfoProvider.notifier).build();
        routeToNewsScreen(context);
      } else {
        ref.read(authNotifierProvider.notifier).toggleRememberState(rememberPhone);
        ref.read(authNotifierProvider.notifier).setEnteredUsername(user.username);
        ref.read(authNotifierProvider.notifier).setEnteredEmail(user.email);
        ref.read(authNotifierProvider.notifier).setUserId(user.id);
        ref.read(authNotifierProvider.notifier).setLocation(location);
        ref.read(authNotifierProvider.notifier).setEnteredChildren(children);
        ref.read(authNotifierProvider.notifier).toggleFamilyState(isFamily);
        ref.read(authNotifierProvider.notifier).toggleLoginState(true);
        onSendCode();
      }
    }

    isButtonDisabled = false;
  }


  onSendCode() async {
    final sentCode = await loginauthService.sendEmail(context, _enteredEmail);
    ref.read(routerProvider.notifier).changeScreen(ScreenType.code);
    ref.read(authNotifierProvider.notifier).updateCode(sentCode);
    routeToCodeScreen(context);
  }
}
