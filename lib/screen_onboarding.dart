import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:money_manager/screen_navbar.dart';
import 'package:money_manager/screen_welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenOnboarding extends StatefulWidget {
  const ScreenOnboarding({super.key});

  @override
  State<ScreenOnboarding> createState() => _ScreenOnboardingState();
}

class _ScreenOnboardingState extends State<ScreenOnboarding> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 42, 41),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(43, 90, 30, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child:
                    Lottie.asset('assets/lottie/9888-money-money-money.json'),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Simple way to\nhelp control your\nSavings!',
                        style: TextStyle(
                            fontFamily: "NotoSans",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25,
                            letterSpacing: 1.2,
                            height: 1.4)),
                    const SizedBox(height: 33),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8,
                        shadowColor: const Color.fromARGB(255, 184, 252, 121),
                        backgroundColor:
                            const Color.fromARGB(255, 184, 252, 121),
                        fixedSize: const Size(500, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      onPressed: () {
                       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavigationScreen(),));
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                            fontSize: 19,
                            color: Color.fromARGB(255, 32, 32, 32),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
