import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/models/user.dart';
import 'package:haravara/providers/current_screen_provider.dart';
import 'package:haravara/providers/preferences_provider.dart';
import 'package:haravara/services/auth_service.dart';
import 'package:haravara/services/screen_router.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:haravara/widgets/header.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
final authService = AuthService();

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  var _enteredEmail = '';
  var _enteredUsername = '';
  bool isCodeSent = false;
  bool isInputByPhoneNumber = false;
  late String code;
  late AuthNotifier authNotifier;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  @override
  void initState() {
    authNotifier = ref.read(authNotifierProvider.notifier);
    _emailFocusNode.addListener(_onFocusChange);
    _usernameFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _submitAndValidate() async {
    if (_emailController.text.isEmpty ||
        !_emailController.text.contains('@') ||
        _emailController.text == 'const User Exist') {
      _showSnackBar('Please enter a valid email address or user exists');
      return;
    }
    if (!_isLogin) {
      if (_usernameController.text.isEmpty) {
        _showSnackBar('username must not be empty');
        return;
      }
      _enteredUsername = _usernameController.text;
    }
    _enteredEmail = _emailController.text;
    if (_isLogin) {
      _handleLogin();
    } else {
      _handleRegistration();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));
    var deviceHeight = MediaQuery.of(context).size.height;
    var registrationHeight = 140;
    var loginHeight = 110;
    if (deviceHeight < 850) {
      registrationHeight = 160;
      loginHeight = 120;
    }
    if (deviceHeight < 700) {
      registrationHeight = 180;
      loginHeight = 140;
    }
    print(deviceHeight);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 8).h,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  const Header(showMenu: false),
                  15.verticalSpace,
                  Text(
                    'PRIHLÁSENIE',
                    style: GoogleFonts.titanOne(
                        fontSize: 18.sp,
                        color: const Color.fromARGB(255, 86, 162, 73),
                        fontWeight: FontWeight.w500),
                  ),
                  5.verticalSpace,
                  Container(
                    key: ValueKey<bool>(_isLogin),
                    width: 220.w,
                    height: _isLogin ? loginHeight.h : registrationHeight.h,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15)).r,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                19.verticalSpace,
                                SizedBox(
                                  width: 166.w,
                                  child: TextFormField(
                                    controller: _emailController,
                                    focusNode: _emailFocusNode,
                                    autocorrect: false,
                                    keyboardType: TextInputType.emailAddress,
                                    textCapitalization: TextCapitalization.none,
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      label: _emailFocusNode.hasFocus ||
                                              _emailController.text.isNotEmpty
                                          ? null
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 15)
                                                      .r,
                                              child: Center(
                                                child: Text(
                                                  'E-MAIL PÁTRAČA',
                                                  style: GoogleFonts.titanOne(
                                                    color: const Color.fromARGB(
                                                        255, 86, 162, 73),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 155, 221, 153),
                                          width: 3.w,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 155, 221, 153),
                                          width: 3.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (!_isLogin && !isCodeSent)
                                  SizedBox(
                                    width: 166.w,
                                    child: TextFormField(
                                      controller: _usernameController,
                                      focusNode: _usernameFocusNode,
                                      autocorrect: true,
                                      keyboardType: TextInputType.name,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        label: _usernameFocusNode.hasFocus ||
                                                _usernameController
                                                    .text.isNotEmpty
                                            ? null
                                            : Padding(
                                                padding:
                                                    EdgeInsets.only(top: 15.w),
                                                child: Center(
                                                  child: Text(
                                                    'POUŽÍVATEĽSKÉ MENO',
                                                    style: GoogleFonts.titanOne(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 86, 162, 73),
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 155, 221, 153),
                                            width: 3.w,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 155, 221, 153),
                                            width: 3.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                15.verticalSpace,
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    textStyle:
                                        GoogleFonts.titanOne(fontSize: 11.sp),
                                    foregroundColor:
                                        const Color.fromARGB(255, 86, 162, 73),
                                    backgroundColor: const Color.fromARGB(
                                        255, 155, 221, 153),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                              Radius.circular(34))
                                          .w,
                                      side: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 91, 187, 75),
                                          width: 2.0.w),
                                    ),
                                  ),
                                  onPressed: _submitAndValidate,
                                  child: SizedBox(
                                    width: 100.w,
                                    height: 20.h,
                                    child: Center(
                                        child: Text(_isLogin
                                            ? 'PRIHLÁS SA'
                                            : 'REGISTRÁCIA')),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  TextButton(
                    child: Text(
                        !_isLogin
                            ? "Máte už konto? Prihlás sa."
                            : 'Nie si ešte prihlásený? ZAREGISTRUJ SA!',
                        style: GoogleFonts.titanOne(
                            fontSize: 10.sp,
                            color: const Color.fromARGB(255, 86, 162, 73),
                            fontWeight: FontWeight.w500)),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0.h,
                      child: const Footer(
                        height: 160,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                    if (deviceHeight > 700)
                      Positioned(
                        bottom: 0.h,
                        left: 105.w,
                        child: Image.asset(
                          'assets/Hero.jpeg',
                          width: 138.w,
                          height: 160.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final userId = await authService.findUserByEmail(_enteredEmail);
    if (userId.isEmpty || userId.compareTo('null') == 0) {
      _showSnackBar('We cant find your email, register instead');
      return;
    }
    List<String> deviceInfo = await authService.getDeviceDetails();
    User user = await authService.getUserById(userId);
    if (user.phones.contains(deviceInfo[0])) {
      ref.read(currentScreenProvider.notifier).changeScreen(ScreenType.news);
      ref
          .read(loginNotifierProvider.notifier)
          .login(user.username, user.email!, user.id!);
      await authService.getCollectedPlacesByUser(userId);
      routeToNewsScreen();
    } else {
      authNotifier.setEnteredUsername(user.username);
      authNotifier.setEnteredEmail(user.email);
      authNotifier.setUserId(user.id);
      authNotifier.toggleLoginState(true);
      onSendCode();
    }
  }

  Future<void> _handleRegistration() async {
    final userId = await authService.findUserByEmail(_enteredEmail);
    if (userId.isEmpty) {
      _showSnackBar('This email already exists');
      return;
    }
    authNotifier.setEnteredUsername(_enteredUsername);
    authNotifier.setEnteredEmail(_enteredEmail);
    authNotifier.toggleLoginState(false);
    onSendCode();
  }

  onSendCode() async {
    final sentCode = await authService.sendEmail(context, _enteredEmail);
    ref.read(currentScreenProvider.notifier).changeScreen(ScreenType.code);
    authNotifier.updateCode(sentCode);
    routeToCodeScreen();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void routeToNewsScreen() async {
    ScreenRouter().routeToNextScreenWithoutAllowingRouteBack(
        context, ScreenRouter().getScreenWidget(ScreenType.news));
  }

  void routeToCodeScreen() {
    ScreenRouter().routeToNextScreen(
        context, ScreenRouter().getScreenWidget(ScreenType.code));
  }

  @override
  void dispose() {
    // Очищаем FocusNode при уничтожении виджета
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }
}
