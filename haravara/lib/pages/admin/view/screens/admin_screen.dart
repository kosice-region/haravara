import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/admin/view/screens/admin_confirm_screen.dart';
import 'package:haravara/pages/admin/view/screens/admin_menu_screen.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isCodeIncorrect = false;

  Future<void> _verifyCode(BuildContext context) async {
    final enteredCode = _codeController.text.trim();
    final activeRewardsRef = FirebaseDatabase.instance.ref('userRewards/activeRewards');

    try {
      final snapshot = await activeRewardsRef.get();
      if (!snapshot.exists || snapshot.value == null) {
        setState(() => _isCodeIncorrect = true);
        _focusNode.requestFocus();
        return;
      }
      final allActiveData = Map<String, dynamic>.from(snapshot.value as Map);
      bool isCodeValid = false;
      String? foundUserId;
      String? foundRewardName;
      allActiveData.forEach((userId, userRewardsData) {
        if (userRewardsData is Map) {
          userRewardsData.forEach((rewardKey, rewardDetails) {
            if (rewardDetails is Map && rewardDetails['code'] == enteredCode) {
              isCodeValid = true;
              foundUserId = userId;
              foundRewardName = rewardDetails['rewardName'];
            }
          });
        }
      });
      if (isCodeValid && foundUserId != null && foundRewardName != null) {
        final userRef = FirebaseDatabase.instance.ref('users/$foundUserId');
        final userSnapshot = await userRef.get();
        if (userSnapshot.exists && userSnapshot.value != null) {
          final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
          final username = userData['username'] ?? '';
          final type = userData['profile']['type'] ?? '';
          final children = userData['profile']['children'] ?? 0;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminConfirm(
                username: username,
                type: type,
                children: children,
                rewardName: foundRewardName!,
                rewardCode: enteredCode,
                userId: foundUserId!,
              ),
            ),
          );
        } else {
          setState(() => _isCodeIncorrect = true);
          _focusNode.requestFocus();
        }
      } else {
        setState(() => _isCodeIncorrect = true);
        _focusNode.requestFocus();
      }
    } catch (_) {
      setState(() => _isCodeIncorrect = true);
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/backgrounds/verification_background.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Container(
                    height: 50.h,
                    color: const Color.fromRGBO(41, 141, 116, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => const AdminMenu(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 150),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 3.5.h, width: 35.48.w, child: const ColoredBox(color: Colors.black)),
                                  SizedBox(height: 8.h),
                                  SizedBox(height: 3.5.h, width: 35.48.w, child: const ColoredBox(color: Colors.black)),
                                  SizedBox(height: 8.h),
                                  SizedBox(height: 3.5.h, width: 35.48.w, child: const ColoredBox(color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ElevatedButton(
                            onPressed: () => _verifyCode(context),
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(85.w, 33.h),
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(color: Colors.white, width: 4),
                            ),
                            child: Text(
                              'Potvrď',
                              style: GoogleFonts.titanOne(
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Column(
                  children: [
                    const Header(),
                    SizedBox(height: 40.h),
                    Column(
                      children: [
                        Container(
                          width: 210.w,
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9260A8),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Text(
                            _isCodeIncorrect
                                ? 'Kód bol nesprávny, zadajte kód znovu'
                                : 'Zadajte 8 miestny kód',
                            style: GoogleFonts.titanOne(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          width: 210.w,
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE65F33),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _codeController,
                                focusNode: _focusNode,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 8,
                                style: GoogleFonts.titanOne(
                                  fontSize: 28.sp,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: '- - - - - - - -',
                                  hintStyle: GoogleFonts.titanOne(
                                    fontSize: 28.sp,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  counterText: '',
                                  border: InputBorder.none,
                                ),
                                onChanged: (_) => setState(() {}),
                                onSubmitted: (_) => _verifyCode(context),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                '${_codeController.text.length}/8',
                                style: GoogleFonts.titanOne(
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}
