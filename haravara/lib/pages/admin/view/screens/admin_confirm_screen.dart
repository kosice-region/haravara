import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/admin/view/screens/admin_action_screen.dart';
import 'package:haravara/pages/admin/view/screens/admin_approved_screen.dart';
import 'package:haravara/pages/admin/view/screens/admin_menu_screen.dart';
import 'package:haravara/pages/reward_menu/service/reward_service.dart';

import '../../../../core/widgets/Popup.dart';

class AdminConfirm extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final int children;
  final String rewardName;
  final String rewardCode;

  const AdminConfirm({
    Key? key,
    required this.username,
    required this.userId,
    required this.type,
    required this.children,
    required this.rewardName,
    required this.rewardCode,
  }) : super(key: key);

  Future<void> _confirmReward(BuildContext context) async {
    final rewardService = RewardService();
    try {
      await rewardService.setRewardClaimed(rewardCode, userId);  
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminApproved(
            username: username,
            type: type,
            children: children,
            rewardName: rewardName,
          ),
        ),
      );
    } catch (e) {
      print("Error claiming reward: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Popup(title:'Error',content: 'Failed to claim reward. Please try again.',);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminActionScreen(
      titleText: 'Potvrďte odovzdanie ceny:',
      buttonText: 'Potvrď',
      buttonColor: const Color(0xFF4CAF50),
      onButtonPressed: () => _confirmReward(context), 
      onMenuPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminMenu()),
        );
      },
      username: username,
      buttonWidth: 100.w,
      type: type,
      children: children,
      rewardName: rewardName,
    );
  }
}
