import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvGetnSet extends ChangeNotifier {
//-------------------------------------------------------Set data

  Future<void> setNotesData(name) async {
    final sharedprefs = await SharedPreferences
        .getInstance(); //initialize object of shared preference
    await sharedprefs.setString('saved_name', name.text);
    notifyListeners();
  }

//-------------------------------------------------------Get data
  String? savedName;
  Future<void> getSavedData(BuildContext context) async {
    final sharedprefs = await SharedPreferences.getInstance();
    //getter method - get the saved name by key
    savedName = sharedprefs.getString('saved_name');
    notifyListeners();
  }
}
