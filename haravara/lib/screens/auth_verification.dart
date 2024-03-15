import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/providers/current_screen_provider.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/screens/auth.dart';
import 'package:haravara/services/screen_router.dart';
import 'package:haravara/widgets/header.dart';

class AuthVerificationScreen extends ConsumerStatefulWidget {
  const AuthVerificationScreen({super.key});

  @override
  ConsumerState<AuthVerificationScreen> createState() =>
      _AuthVerificationScreenState();
}

class _AuthVerificationScreenState
    extends ConsumerState<AuthVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  String _code = '';
  bool _onEditing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 150, 190),
      body: Padding(
          padding: const EdgeInsets.only(top: 8).h,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                15.verticalSpace,
                const Header(
                  showMenu: false,
                  isCenter: true,
                ),
                40.verticalSpace,
                Container(
                  width: 220.w,
                  height: 175.h,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)).r,
                    color: const Color.fromARGB(255, 177, 235, 183),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 91, 187, 75)
                            .withOpacity(1),
                        spreadRadius: 8,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      23.verticalSpace,
                      Text(
                        'OVERENIE',
                        style: GoogleFonts.titanOne(
                          fontSize: 18.sp,
                          color: const Color.fromARGB(255, 86, 162, 73),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        'Zadajte kod',
                        style: GoogleFonts.oswald(
                          fontSize: 12.sp,
                          color: const Color.fromARGB(255, 86, 162, 73),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      20.verticalSpace,
                      VerificationCode(
                        textStyle: TextStyle(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 0, 77, 73)),
                        underlineColor: const Color.fromARGB(255, 50, 0, 112),
                        underlineWidth: 2.w,
                        keyboardType: TextInputType.number,
                        length: 4,
                        onCompleted: (String value) {
                          setState(() {
                            _code = value;
                            _validateCode();
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
                ),
              ],
            ),
          )),
    );
  }

  void _validateCode() async {
    var authState = ref.watch(authNotifierProvider);
    if (authState.code != _code) {
      _showSnackBar('incorrect');
      return;
    }
    if (authState.isLogin) {
      await authService.loginUserByEmail(authState.enteredEmail!);
    } else {
      await authService.registerUserByEmail(
          authState.enteredEmail!, authState.enteredUsername!, ref);
    }
    routeToNewsScreen();
    _showSnackBar('Success');
  }

  void routeToNewsScreen() {
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.news));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
