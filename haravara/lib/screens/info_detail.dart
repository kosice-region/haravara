import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDetail extends StatefulWidget {
  const InfoDetail({super.key});

  @override
  State<InfoDetail> createState() => _InfoDetailState();
}

class _InfoDetailState extends State<InfoDetail> {
  final String url = 'https://www.deutschetelekomitsolutions.sk/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deutsche Telekom Info',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 0, 144),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: Image(
                  image: AssetImage('images/TS.png'),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'T-Systems Slovakia s.r.o. s mission is\nto "give IT meaning". They are transforming into\na modern ICT services provider, focusing on\ndigital technologies and shifting from\na project-driven model to meet customer needs.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 2, color: Colors.black),
            const SizedBox(height: 20),
            Text(
              'For more information',
              style: GoogleFonts.lato(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.add_to_home_screen_sharp),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {},
                  child: Text(
                    url,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Required Hard skills',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const ProgressBar(skillName: 'Backend skills', level: 0.8),
            const ProgressBar(skillName: 'Frontend skills', level: 0.65),
            const ProgressBar(skillName: 'Data analysis', level: 0.75),
            const ProgressBar(skillName: 'Algorithmics', level: 0.9),
          ],
        ),
      ),
    );
  }
}

// Row(
//   children: [
//         Icon(Icons.add_to_home_screen_sharp),
//         SizedBox(width: 5),
//         Text(
//           'https://www.deutschetelekomitsolutions.sk/',
//           style: TextStyle(
//             color:
//                 Colors.black, // Adjust the color to match the design
//             fontSize: 16, // Adjust the font size to match the design
//           ),
//         ),
//       ],
//     ),
//     SizedBox(height: 10),
//     Row(
//       children: [
//         Icon(Icons.map_outlined),
//         SizedBox(width: 5),
//         Text(
//           'Žriedlová 13, 040 01 Košice',
//           style: TextStyle(
//             color:
//                 Colors.black, // Adjust the color to match the design
//             fontSize: 16, // Adjust the font size to match the design
//           ),
//         ),
//   ],
// ),

class ProgressBar extends StatelessWidget {
  final String skillName;
  final double level;

  const ProgressBar({Key? key, required this.skillName, required this.level})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(skillName, style: const TextStyle(fontSize: 16.0)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: level,
              backgroundColor: Colors.grey[300],
              color: Colors.purple,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text(
//         'Deutsche Telekom Info',
//         style: TextStyle(color: Colors.white),
//       ),
//       backgroundColor: const Color.fromARGB(255, 255, 0, 144),
//     ),
//     backgroundColor: Colors.white,
//     body: SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const Padding(
//               padding: EdgeInsets.only(top: 16),
//               child: Center(
//                 child: Image(
//                   image: AssetImage('images/TS.png'),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 55),
//             Center(
//               child: Text(
//                 'T-Systems Slovakia s.r.o. s mission is\nto "give IT meaning". They are transforming into\na modern ICT services provider, focusing on\ndigital technologies and shifting from\na project-driven model to meet customer needs.',
//                 style: GoogleFonts.inter(
//                   color: Colors.black, // Adjust the color to match the design
//                   fontSize: 17, // Adjust the font size to match the design
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             const Expanded(
//               child: Column(
//                 children: <Widget>[Divider(color: Colors.black)],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
