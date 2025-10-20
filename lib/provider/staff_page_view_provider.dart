import 'package:flutter/material.dart';

class StaffPageViewProvider extends ChangeNotifier {
  int _page = 0;
  int get page => _page;

  void jumpToPage(int page) {
    _page = page;
    notifyListeners();
  }
}