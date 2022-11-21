import 'package:flutter/material.dart';
import 'package:money_manager/screen_navbar.dart';
import 'package:money_manager/screen_onboarding.dart';
import 'package:money_manager/screen_welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 44, 43, 43),
      body: Center(
        child: Image.asset(
            'assets/images/Black & White Finance Money Care Bold Logo.png'),
      ),
    );
  }

  Future<void> checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    final loggedName = pref.getString('saved_name');
    if (loggedName == null) {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ScreenWelcome()));
      }
    } else {
      gotoLogin();
    }
  }

  Future<void> gotoLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const BottomNavigationScreen()));
    }
  }
}
