import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:haravara/pages/auth/widgets/widgets.dart';
import 'package:haravara/core/providers/preferences_provider.dart';
import 'package:haravara/pages/auth/services/auth_service.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
final authService = AuthService();

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  var _isLogin = false;
  bool isFamily = false;
  bool isCodeSent = false;
  bool isInputByPhoneNumber = false;
  late String code;
  late AuthNotifier authNotifier;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  var userId = '';
  final List<String> children = List.generate(
      5, (index) => index == 0 ? '1 dieťaťa' : '${index + 1} deti');
  String? dropdownValue;

  final List<String> imageAssets = [
    'assets/backgrounds/pozadie_auth.jpg',
    'assets/backgrounds/VOZIK_BOK.jpg',
  ];

  @override
  void initState() {
    dropdownValue = children[0];
    authNotifier = ref.read(authNotifierProvider.notifier);
    _emailFocusNode.addListener(_onFocusChange);
    _usernameFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    var deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            bottom: 190.h,
            left: -20.w,
            child: Image.asset(
              'assets/backgrounds/pozadie_auth.jpg',
              fit: BoxFit.fitHeight,
              width: 320.w,
              height: 350.h,
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (deviceHeight > 700) 35.verticalSpace,
                    if (deviceHeight < 700) 25.verticalSpace,
                    Text(
                      'PRIHLÁSENIE',
                      style: GoogleFonts.titanOne(
                        fontSize: 18.sp,
                        color: Color.fromARGB(255, 254, 152, 43),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    5.verticalSpace,
                    Opacity(
                      opacity: 0.9,
                      child: _isLogin ? LoginForm() : RegistrationForm(),
                    ),
                    SwitchMode(
                      text: !_isLogin
                          ? "Máte už konto? Prihlás sa."
                          : 'Nie si ešte prihlásený? ZAREGISTRUJ SA!',
                      onPressed: _toggleLoginMode,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            child: Image.asset(
              'assets/backgrounds/VOZIK_BOK.jpg',
              fit: BoxFit.cover,
              height: 200.h,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLoginMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
