import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/admin/FooterAdmin.dart';
import 'package:haravara/pages/admin/view/screens/admin_confirm_screen.dart';
import 'package:firebase_database/firebase_database.dart';

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
    double deviceHeight = MediaQuery.of(context).size.height;
    double buttonHeight = 33.h;
    double buttonWidth = 85.w;

    if (deviceHeight < 850) {
      buttonHeight = 38.h;
      buttonWidth = 95.w;
    }
    if (deviceHeight < 700) {
      buttonHeight = 43.h;
      buttonWidth = 105.w;
    }
    if (deviceHeight < 650) {
      buttonHeight = 48.h;
      buttonWidth = 115.w;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/verification_background.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              children: [
                Header(),
                50.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Column(
                    children: [
                      Container(
                        width: 230.w,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF9260A8),
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
                        width: 230.w,
                        padding: EdgeInsets.all(10.w),
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
                            SizedBox(height: 8.h),
                            Text(
                              '${_codeController.text.length}/8',
                              style: GoogleFonts.titanOne(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FooterAdmin(), // Place the Footer widget at the bottom
          ),
        ],
      ),
    );
  }
}
