import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haravara/core/providers/initialization_provider.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool? _isConnected;
  bool _initialCheckDone = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();

    _performInitialChecks();
  }

  Future<void> _performInitialChecks() async {
    if (!mounted) return;

    setState(() {
      _initialCheckDone = false;
      _isConnected = null;
    });

    bool hasInternet = await InternetConnection().hasInternetAccess;

    if (mounted) {
      setState(() {
        _isConnected = hasInternet;
        _initialCheckDone = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(255, 516));

    double progress = ref.watch(initializationProgressProvider) * 100;

    Color backgroundColor = const Color(0xFFF2F3F4);
    Color logoAccent = const Color(0xFFBC5FBE);
    Color textColor = Colors.black87;
    Color subTextColor = Colors.grey[800]!;
    Color progressBackground = Colors.grey[300]!;
    Color spinnerColor = logoAccent;

    Widget currentScreenStateContent;

    if (!_initialCheckDone) {
      currentScreenStateContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo-haravara.png',
            width: 150.w,
            height: 180.h,
          ),
          SizedBox(height: 20.h),
          Platform.isIOS
              ? CupertinoActivityIndicator(radius: 12.r, color: spinnerColor)
              : SizedBox(
                  width: 28.w,
                  height: 28.h,
                  child: CircularProgressIndicator(
                    color: spinnerColor,
                    strokeWidth: 3.0,
                  ),
                ),
          SizedBox(height: 15.h),
          Text(
            "Kontrolujem pripojenie...",
            style: GoogleFonts.titanOne(
                fontSize: 16.sp, color: subTextColor, letterSpacing: 0.2),
          ),
        ],
      );
    } else if (_isConnected == false) {
      currentScreenStateContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo-haravara.png',
            width: 150.w,
            height: 180.h,
          ),
          SizedBox(height: 25.h),
          Icon(Icons.signal_wifi_off_rounded,
              size: 50.r, color: Colors.red[400]),
          SizedBox(height: 15.h),
          Text(
            'Žiadne internetové pripojenie',
            textAlign: TextAlign.center,
            style: GoogleFonts.titanOne(fontSize: 18.sp, color: textColor),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Skontrolujte pripojenie k sieti a skúste to znova.',
              textAlign: TextAlign.center,
              style: GoogleFonts.titanOne(
                  fontSize: 14.sp,
                  color: subTextColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      );
    } else {
      currentScreenStateContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo-haravara.png',
            width: 150.w,
            height: 180.h,
          ),
          SizedBox(height: 5.h),
          Text(
            "Inicializácia",
            style: GoogleFonts.titanOne(fontSize: 20.sp, color: subTextColor),
          ),
          SizedBox(height: 14.h),
          Platform.isIOS
              ? CupertinoActivityIndicator(radius: 12.r, color: spinnerColor)
              : SizedBox(
                  width: 28.w,
                  height: 28.h,
                  child: CircularProgressIndicator(
                    color: spinnerColor,
                    strokeWidth: 3.0,
                  ),
                ),
          SizedBox(height: 24.h),
          Container(
            width: 204.w,
            height: 29.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: subTextColor,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Container(
                width: 200.w,
                height: 25.h,
                decoration: BoxDecoration(
                  color: progressBackground,
                  borderRadius: BorderRadius.circular(12.5.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.5.r),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 25.h,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(logoAccent),
                      ),
                    ),
                    Text(
                      '${progress.toStringAsFixed(0)}%',
                      style: GoogleFonts.titanOne(
                        fontSize: 16.sp,
                        color: textColor,
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: Colors.white.withOpacity(0.2),
                            offset: Offset(0.5, 0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget screenLayout = Column(
      children: <Widget>[
        Expanded(
          child: Center(child: currentScreenStateContent),
        ),
        20.h.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 55.w,
              height: 55.h,
              child: Image.asset(
                'assets/company-logo/KSK_logo_hor_ver_b.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: 65.w,
              height: 65.h,
              child: Image.asset(
                'assets/company-logo/Logo_KRT_SK_b.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: 50.w,
              height: 50.h,
              child: Image.asset(
                'assets/company-logo/DTITSO_rgb_m.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );

    return Material(
      color: backgroundColor,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: screenLayout,
      ),
    );
  }
}
