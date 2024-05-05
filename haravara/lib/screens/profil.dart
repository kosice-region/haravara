import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/widgets/header.dart';
import 'package:haravara/widgets/header_menu.dart';
import 'package:haravara/widgets/footer.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          Image.asset(
            'assets/clovece.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              8.verticalSpace,
              const Header(),
              10.verticalSpace,
              Text(
                'PROFIL PATRACA',
                style: GoogleFonts.titanOne(
                    fontSize: 18.sp,
                    color: const Color.fromRGBO(41, 141, 116, 1),
                    fontWeight: FontWeight.w500),
              ),
              10.verticalSpace,
            ],
          ),
          Positioned(
            top: 140.h, // Posunutie o 4 cm zhora
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/profil.png', // Nahradiť súborom obrázka
              width: 120.w, // Zväčšená veľkosť obrázka
              height: 120.h,
            ),
          ),
        ],
      ),
      bottomSheet: const Footer(height: 175, boxFit: BoxFit.fill),
    );
  }
}
