import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haravara/widgets/footer.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const HeaderMenu(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8).h,
        child: Column(
          children: [
            const Header(),
            39.verticalSpace,
            Container(
              width: 224.w,
              height: 135.h,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)).r,
                color: const Color.fromARGB(255, 177, 235, 183),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 91, 187, 75).withOpacity(1),
                    spreadRadius: 8,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0.h,
                    child: const Footer(
                      height: 190,
                      boxFit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: 8.h,
                    right: 1.w,
                    // left: 10.w,
                    child: Image.asset(
                      'assets/kaso-detective.png',
                      height: 164.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
