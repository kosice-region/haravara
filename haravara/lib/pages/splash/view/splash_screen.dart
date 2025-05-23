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

    // Check internet connection
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

    Widget currentScreenStateContent;

    if (!_initialCheckDone) {
      currentScreenStateContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo-haravara.png', // Ensure path is correct
            width: 150.w,
            height: 180.h,
          ),
          SizedBox(height: 20.h),
          Platform.isIOS
              ? CupertinoActivityIndicator(radius: 12.r, color: Colors.white)
              : SizedBox(
            width: 24.w, // Slightly larger
            height: 24.h,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3.0, // Slightly thicker
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            "Kontrolujem pripojenie...", // "Checking connection..."
            style: GoogleFonts.titanOne(fontSize: 16.sp, color: Colors.grey[400]),
          ),
        ],
      );
    } else if (_isConnected == false) {
      currentScreenStateContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo-haravara.png', // Ensure path is correct
            width: 150.w,
            height: 180.h,
          ),
          SizedBox(height: 25.h),
          Icon(Icons.signal_wifi_off_rounded, size: 50.r, color: Colors.redAccent[100]),
          SizedBox(height: 15.h),
          Text(
            'Žiadne internetové pripojenie', // "No Internet Connection"
            textAlign: TextAlign.center,
            style: GoogleFonts.titanOne(fontSize: 18.sp, color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Skontrolujte pripojenie k sieti a skúste to znova.', // "Please check your network connection and try again."
              textAlign: TextAlign.center,
              style: GoogleFonts.titanOne(fontSize: 14.sp, color: Colors.grey[500]),
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
            'assets/logo-haravara.png', // Ensure path is correct
            width: 150.w,
            height: 180.h,
          ),
          SizedBox(height: 5.h), // Adjusted spacing
          Text(
            "Inicializácia",
            style: GoogleFonts.titanOne(fontSize: 20.sp, color: Colors.grey[400]),
          ),
          SizedBox(height: 10.h),
          Platform.isIOS
              ? CupertinoActivityIndicator(
            radius: 10.r,
            color: Colors.white,
          )
              : SizedBox(
            width: 20.w,
            height: 20.h,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 204.w,
            height: 29.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.white.withOpacity(0.7), // Slightly transparent border
                width: 2.5, // Adjusted border width
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Container(
                width: 200.w,
                height: 25.h,
                decoration: BoxDecoration(
                  // Using a darker grey for better contrast if progress bar is light
                  color: Colors.grey[700]?.withOpacity(0.5),
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
                        backgroundColor: Colors.transparent, // Handled by container
                        valueColor: AlwaysStoppedAnimation<Color>(
                            const Color.fromARGB(255, 188, 95, 190).withOpacity(1)),
                      ),
                    ),
                    Text(
                      '${progress.toStringAsFixed(0)}%',
                      style: GoogleFonts.titanOne(
                          fontSize: 16.sp,
                          color: Colors.white,
                          shadows: [ // Adding a subtle shadow for text readability
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(1.0, 1.0),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // The main layout of the splash screen
    Widget screenLayout = Column(
      children: <Widget>[
        Expanded(
          child: Center(child: currentScreenStateContent), // Content fills the expanded area
        ),
        20.h.verticalSpace, // Space before company logos
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    SizedBox(
      width: 55.w,
      height: 55.h,
      child: Image.asset(
        'assets/company-logo/KSK_logo_hor_ver_inv.png', // Ensure path is correct
        fit: BoxFit.contain,
        ),
      ),
    SizedBox(
        width: 65.w,
        height: 65.h,
        child: Image.asset(
          'assets/company-logo/Logo_KRT_SK_w.png', // Ensure path is correct
          fit: BoxFit.contain,
      ),
    ),
    SizedBox(
      width: 30.w,
      height: 30.h,
      child: Image.asset(
          'assets/company-logo/T_logo_rgb_p.png', // Ensure path is correct
          fit: BoxFit.contain,
        ),
      ),
    ],
    ), // Company logos at the bottom
        SizedBox(height: 20.h), // Padding at the very bottom
      ],
    );

    return Material(
      color: Colors.black,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child, // Apply fade to the entire screenLayout
          );
        },
        child: screenLayout,
      ),
    );
  }
}
