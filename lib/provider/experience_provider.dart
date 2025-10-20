import 'package:flutter/material.dart';

class ExperienceProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _experienceList = [];

  List<Map<String, dynamic>> get experienceList => _experienceList;
  String jobTitle = '';
  String? selectedJobTitle;
  String? gender;
  int? selectedJobTitleId;

  final Set<int> _selectedExperienceIds = {};
  Set<int> get selectedExperienceIds =>
      Set.unmodifiable(_selectedExperienceIds);

  // Experiences Operations
  void addExperienceId(int experienceId) {
    _selectedExperienceIds.add(experienceId);
    notifyListeners();
  }

  void removeExperienceId(int experienceId) {
    _selectedExperienceIds.remove(experienceId);
    notifyListeners();
  }

  void addExperience(Map<String, dynamic> experience) {
    _experienceList.add(experience);
    notifyListeners();
  }

  void updateStartDate(DateTime date) {
    if (_experienceList.isNotEmpty) {
      _experienceList.last["Start Date"] = date.toIso8601String();
      notifyListeners();
    }
  }

  void updateEndDate(DateTime date) {
    if (_experienceList.isNotEmpty) {
      _experienceList.last["End Date"] = date.toIso8601String();
      notifyListeners();
    }
  }
}
