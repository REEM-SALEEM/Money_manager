import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../View/screen_navbar.dart';
import '../../View/screen_welcome.dart';

class ProvLogin extends ChangeNotifier{
Future<void> checkLogin(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    final loggedName = pref.getString('saved_name');
    if (loggedName == null) {
      await Future.delayed(const Duration(seconds: 4));
      
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) =>  ScreenWelcome()));
      
    } else {
      gotoLogin(context);
    }
  }

  Future<void> gotoLogin(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
   
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) =>  BottomNavigationScreen()));
    
  }

}