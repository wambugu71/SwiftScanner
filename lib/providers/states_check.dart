import 'package:flutter/material.dart';

class HomePageState extends ChangeNotifier {
  bool is_home_exited = false;
  // HomePageState(this._is_home_exited);

  bool get is_home => is_home_exited;

  void enterHome() {
    is_home_exited = true;
    notifyListeners();
  }

  void homeExit() {
    is_home_exited = false;
    notifyListeners();
  }
}
