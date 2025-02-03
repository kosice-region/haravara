import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haravara/core/widgets/close_button.dart';
import 'package:haravara/core/widgets/header.dart';
import 'package:haravara/pages/header_menu/view/header_menu_screen.dart';
import 'package:haravara/core/widgets/footer.dart';
import 'package:haravara/pages/summary/widgets/widgets.dart';

import '../../../router/router.dart';

class FaqItem {
  FaqItem({required this.question, required this.answer});

  String question;
  String answer;
}

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final List<String> imageAssets = [
    'assets/backgrounds/background-summary.png',
    'assets/budik.png',
  ];

  final List<FaqItem> _faqItems = [
    FaqItem(
      question: 'Čo je to Haravara?',
      answer:
          'Haravara je čarovná krajina, ktorú dospelí poznajú pod názvom Košický kraj, a v ktorej dobrý duch Kaško ukryl 60 Haravara pečiatok. Vydaj sa s nami na interaktívnu pátračku po krajine plnej nádherných miest a zaži skvelé dobrodružstvá s rodičmi a kamarátmi pri hľadaní pečiatok pomocou aplikácie Haravara Pátračka!',
    ),
    FaqItem(
      question: 'Čo potrebujem, aby som sa mohol zapojiť do Haravara Pátračky?',
      answer:
          'Každý, kto sa chce zapojiť do Haravara Pátračky, sa potrebuje zaregistrovať v našej aplikácii. (toto doplniť podľa presných inštrukcií k registrácii, ktoré aktuálne ešte nepoznám)',
    ),
    FaqItem(
      question: 'Kedy sa začína a dokedy trvá Haravara Pátračka?',
      answer:
          'Aktuálna sezóna Haravara Pátračky trvá od 1. apríla do 31. decembra 2025.',
    ),
    FaqItem(
      question: 'Kde si môžem vyzdvihnúť výhry?',
      answer:
          'Výhru za 15 pečiatok si môžeš vyzdvihnúť v Regionálnom informačnom bode v Košiciach alebo v štyroch Turistických informačných centrách – v Spišskej Novej Vsi, Rožňave, Michalovciach a Trebišove. (k ostatným výhram za 30 a 45 pečiatok sa budem vedieť vyjadriť až neskôr, lebo neviem s koľkými pečiatkami/výhrami budeme rátať budúcu sezónu a akou formou ich mienime odovzdávať)',
    ),
    FaqItem(
      question: 'Kedy prebehne žrebovanie o hlavné ceny?',
      answer:
          'Žrebovanie o hlavné ceny prebehne v januári 2026. (tu budem potrebovať s vami prekonzultovať spôsob, akým budú pátrači dávať vedieť nám o tom, že majú všetko, resp. či nám sa to bude kdesi reflektovať v systéme, alebo ako presne budeme zdieľať tieto informácie)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    imageAssets.forEach((image) => precacheImage(AssetImage(image), context));
    return Scaffold(
      endDrawer: HeaderMenu(),
      body: Stack(
        children: [
          BackgroundImage(
            image: 'assets/backgrounds/background-summary.png',
          ),
          Column(
            children: [
              8.verticalSpace,
              const Header(),
              30.verticalSpace,
              Text(
                'OTÁZKY A ODPOVEDE',
                style: GoogleFonts.titanOne(
                    fontSize: 18.sp,
                    color: const Color.fromARGB(255, 86, 162, 73),
                    fontWeight: FontWeight.w500),
              ),
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: _buildFaqList(),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Footer(height: 40),
          ),
          Positioned(
            top: 43.h,
            right: 30.w,
            child: Close_Button(screenType: ScreenType.news,),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqList() {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 80.h), // Added bottom padding
      child: Column(
        children: _faqItems.map((item) => _buildFaqItem(item)).toList(),
      ),
    );
  }

  Widget _buildFaqItem(FaqItem item) {
    return GestureDetector(
      onTap: () => _showAnswerDialog(item),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            item.question,
            style: GoogleFonts.titanOne(
              fontSize: 14.sp,
              color: const Color.fromARGB(255, 86, 162, 73),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  void _showAnswerDialog(FaqItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            item.question,
            style: GoogleFonts.titanOne(
              fontSize: 16.sp,
              color: const Color.fromARGB(255, 86, 162, 73),
            ),
          ),
          content: Text(
            item.answer,
            style: GoogleFonts.titanOne(
              fontSize: 12.sp,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Zavrieť',
                style: GoogleFonts.titanOne(
                  fontSize: 12.sp,
                  color: const Color.fromARGB(255, 86, 162, 73),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
