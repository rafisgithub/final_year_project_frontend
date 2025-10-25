import 'package:flutter/material.dart';

class ReviewProvider with ChangeNotifier {
  int applicationId = 0;

  // Experiences Operations
  void addApplicationId(int applicationId) {
    this.applicationId = applicationId;
    notifyListeners();
  }
}
