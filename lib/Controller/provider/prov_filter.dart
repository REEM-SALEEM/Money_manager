import 'package:flutter/cupertino.dart';

class Filter extends ChangeNotifier {
  String ss = "";
  get selectedCategorytype => ss;
  set selectedCategorytype(value) {
    ss = value;
    notifyListeners();
  }
}

class FilterAll extends ChangeNotifier {
  String selectedate = "";
  get selectedCategorytype => selectedate;
  set selectedCategorytype(value) {
    selectedate = value;
    notifyListeners();
  }
}

