import 'package:flutter/material.dart';
import 'package:money_manager/Controller/provider/prov_checklogin.dart';
import 'package:provider/provider.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  var checker;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checker =
          Provider.of<ProvLogin>(context, listen: false).checkLogin(context);
    });
    // checkLogin();
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
}
