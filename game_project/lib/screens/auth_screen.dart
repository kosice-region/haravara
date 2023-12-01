import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TECH ',
                  style: GoogleFonts.baloo2(
                      fontSize: 65, fontWeight: FontWeight.bold),
                ),
                Text(
                  'TERRA',
                  style: GoogleFonts.baloo2(
                    fontSize: 65,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 185, 0, 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Playing games to search job',
              style: GoogleFonts.inter(fontSize: 22, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Container(
              width: 350,
              height: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.apple, size: 40),
                    const SizedBox(width: 40),
                    Text(
                      "Sign up with Apple",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 350,
              height: 80,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.g_mobiledata,
                      size: 40,
                    ),
                    const SizedBox(width: 40),
                    Text(
                      "Sign up with Google",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.phone_iphone_rounded),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.mail),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Navigate to login page
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 249, 192, 52),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sign up means you agree to\n',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: Color.fromARGB(255, 249, 192, 52),
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: Color.fromARGB(255, 249, 192, 52),
                      fontSize: 14,
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
