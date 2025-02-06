
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/pages/profile/widgets/widgets.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/pages/map_detail/providers/places_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          // Background Image
          BackgroundImage(
            imagePath: 'assets/backgrounds/HARAVARA_profil.jpg',
          ),

          // Scrollable Content
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: 65.h, 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),
                    const Header(),
                    SizedBox(height: 5.h),
                    AvatarWidget(),
                    SizedBox(height: 5.h),
                    const SearcherLevel(),
                    SizedBox(height: 12.h),
                    UsernameWidget(),
                    SizedBox(height: 12.h),
                    RedirectButtons(),
                    SizedBox(height: 10.h),
                    ActionButtons(),
                    SizedBox(height: 10.h),
                    ActionButtons2(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}

class SearcherLevel extends ConsumerWidget {
  final Color color;

  const SearcherLevel({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String levelOfSearcher = ref.watch(placesProvider.select(
        (state) => ref.read(placesProvider.notifier).getLevelOfSearcher()));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(234, 97, 205, 255),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        levelOfSearcher,
        style: GoogleFonts.titanOne(
          fontSize: 13.sp,
          fontWeight: FontWeight.w300,
          color: color,
        ),
      ),
    );
  }
}
