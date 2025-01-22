import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/core/services/database_service.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/auth/models/user.dart';
import 'package:haravara/pages/auth/services/auth_service.dart';
import 'package:haravara/pages/auth/view/auth_screen.dart';
import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';
import 'package:haravara/router/router.dart';
import 'package:haravara/router/screen_router.dart';

import '../widgets/widgets.dart';

class AuthVerificationScreen extends ConsumerStatefulWidget {
  const AuthVerificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthVerificationScreen> createState() =>
      _AuthVerificationScreenState();
}

class _AuthVerificationScreenState
    extends ConsumerState<AuthVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _code = '';
  bool _onEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 140, 192, 225),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Image.asset(
              'assets/backgrounds/verification_background.png',
              fit: BoxFit.cover,
              width: 265.w,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 8).h,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      15.verticalSpace,
                      const Header(
                        showMenu: false,
                        isCenter: true,
                      ),
                      40.verticalSpace,
                      Container(
                        width: 230.w,
                        height: 175.h,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)).r,
                          color: const Color.fromARGB(255, 255, 200, 67),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 248, 184, 36)
                                  .withOpacity(1),
                              spreadRadius: 8,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            17.verticalSpace,
                            Text(
                              'OVERENIE',
                              style: GoogleFonts.titanOne(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            35.verticalSpace,
                            Stack(
                              children: [
                                for (int i = 0; i < 4; i++) CodeDigit(index: i),
                                VerificationCode(
                                  textStyle: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  underlineColor: Colors.transparent,
                                  underlineWidth: 0,
                                  digitsOnly: true,
                                  length: 4,
                                  onCompleted: (String value) {
                                    setState(() {
                                      _code = value;
                                    });
                                  },
                                  onEditing: (bool value) {
                                    setState(() {
                                      _onEditing = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            25.verticalSpace,
                            SubmitButton(
                              onPressed: _validateCode,
                              text: 'POKRAČOVAT',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateCode() async {
    final authState = ref.watch(authNotifierProvider);
    if (authState.code != _code) {
      _showSnackBar('incorrect');
      return;
    }
    if (authState.isLogin) {
      final user = await authService.loginUserByEmail(
        authState.enteredEmail!,
        authState.isNeedToRemeber,
      );
      if (user == null) {
        _showSnackBar('User not found.');
        return;
      }
      final isAdmin = await DatabaseService().isAdmin(user.email!);
      if (isAdmin) {
        routeToAdminScreen(context);
      } else {
        routeToNewsScreen();
      }
    } else {
      final user = await authService.registerUserByEmail(
        authState.enteredEmail!,
        authState.enteredUsername!,
        authState.isFamily,
        authState.children!,
        authState.location ?? '',
        authState.isNeedToRemeber,
      );
      ref.read(loginNotifierProvider.notifier).login(
            authState.enteredUsername!,
            authState.enteredEmail!,
            user.id!,
            authState.children ?? -1,
            authState.location ?? '',
          );
      ref.read(userInfoProvider.notifier).build();
      ref
          .read(userInfoProvider.notifier)
          .updateUsername(authState.enteredUsername!);
      final isAdmin = await DatabaseService().isAdmin(user.email!);
      if (isAdmin) {
        routeToAdminScreen(context);
      } else {
        routeToNewsScreen();
      }
    }
    _showSnackBar('Success');
  }

  void routeToNewsScreen() {
    if (!mounted) return;
    ref.read(routerProvider.notifier).changeScreen(ScreenType.news);
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
      context,
      ScreenRouter().getScreenWidget(ScreenType.news),
    );
  }

  void routeToAdminScreen(BuildContext context) {
    if (!mounted) return;
    ref.read(routerProvider.notifier).changeScreen(ScreenType.admin);
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
      context,
      ScreenRouter().getScreenWidget(ScreenType.admin),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
