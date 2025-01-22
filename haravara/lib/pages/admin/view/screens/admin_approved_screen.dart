import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/pages/admin/view/screens/admin_screen.dart';
import 'package:haravara/pages/admin/view/screens/admin_action_screen.dart';
import 'package:haravara/pages/admin/view/screens/admin_menu_screen.dart';

class AdminApproved extends StatelessWidget {
  final String username;
  final String type;
  final int children;
  final String rewardName;

  const AdminApproved({
    Key? key,
    required this.username,
    required this.type,
    required this.children,
    required this.rewardName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminActionScreen(
      titleText: 'Cena bola odovzdaná úspešne.',
      buttonText: 'Zadaj kód',
      buttonColor: const Color(0xFFEAB635),
      onButtonPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      },
      onMenuPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminMenu()),
        );
      },
      username: username,
      type: type,          
      children: children,  
      rewardName: rewardName,
      buttonWidth: 100.w,
    );
  }
}
