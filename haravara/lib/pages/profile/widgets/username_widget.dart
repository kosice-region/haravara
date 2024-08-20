import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/profile/providers/user_info_provider.dart';

class UsernameWidget extends ConsumerWidget {
  const UsernameWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var username = ref.watch(userInfoProvider).username;
    return Container(
      width: 195.w,
      height: 38.h,
      decoration: BoxDecoration(
        color: Color.fromARGB(225, 158, 230, 165),
        borderRadius: BorderRadius.all(Radius.circular(15.dg)),
      ),
      child: Center(
        child: Text(
          username,
          style: GoogleFonts.titanOne(
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
