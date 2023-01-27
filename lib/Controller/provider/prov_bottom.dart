import 'package:flutter/cupertino.dart';

class BottomProvider extends ChangeNotifier{
  int? _currentIndex;
  get currentIndex => _currentIndex;
  set currentIndex(index) {
    _currentIndex = index;
    notifyListeners();
  }
}