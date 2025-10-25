// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:final_year_project_frontend/features/join_as_company/choose_package_for_add_staff/model/staff_info_mode.dart';

// class StaffProvider with ChangeNotifier {
//   // Staff List Management
//   final List<Staff> _staffList = [];
//   List<Staff> get staffList => List.unmodifiable(_staffList);

//   // Personal Information
//   String? selectedJobTitle;
//   String? gender;
//   int? selectedJobTitleId;

//   // Controllers
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController countryController = TextEditingController();
//   final TextEditingController postCodeController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController businessDetailsController =
//       TextEditingController();
//   final TextEditingController identificationController =
//       TextEditingController();
//   final TextEditingController dateControllers = TextEditingController();
//   final TextEditingController phonenumber = TextEditingController();

//   // Bank Details
//   final TextEditingController accountHolderController = TextEditingController();
//   final TextEditingController accountNumberController = TextEditingController();
//   final TextEditingController bankcountryController = TextEditingController();
//   final TextEditingController bankpostCodeController = TextEditingController();
//   final TextEditingController swiftCodeController = TextEditingController();

//   // Skills Management
//   final Set<int> _selectedSkillIds = {};
//   Set<int> get selectedSkillIds => Set.unmodifiable(_selectedSkillIds);

//   // File Management
//   File? _profileImage;
//   File? _pdfFile;
//   File? _mediaFile;

//   // Getters
//   File? get profileImage => _profileImage;
//   File? get pdfFile => _pdfFile;
//   File? get mediaFile => _mediaFile;

//   // Experiences Management
//   final Set<int> _selectedExperienceIds = {};
//   Set<int> get selectedExperienceIds =>
//       Set.unmodifiable(_selectedExperienceIds);

//   // Staff Operations
//   void addStaff(Staff staff) {
//     _staffList.add(staff);
//     notifyListeners();
//   }

//   void clearStaffList() {
//     _staffList.clear();
//     notifyListeners();
//   }

//   // Skill Operations
//   void initializeSkills(List<int> skillIds) {
//     if (_selectedSkillIds.isEmpty) {
//       _selectedSkillIds.addAll(skillIds);
//       notifyListeners();
//       _logSelectedSkills();
//     }
//   }

//   bool isSkillSelected(int skillId) {
//     return _selectedSkillIds.contains(skillId);
//   }

//   void toggleSkillSelection(int skillId, bool isSelected) {
//     if (isSelected) {
//       _selectedSkillIds.add(skillId);
//     } else {
//       _selectedSkillIds.remove(skillId);
//     }
//     notifyListeners();
//     _logSelectedSkills();
//   }

//   // File Operations
//   void setProfileImage(File? image) {
//     _profileImage = image;
//     notifyListeners();
//   }

//   void setPdfFile(File? file) {
//     _pdfFile = file;
//     notifyListeners();
//   }

//   void setMediaFile(File? file) {
//     _mediaFile = file;
//     notifyListeners();
//   }

//   // Add this method to allow updating gender from the UI
//   void setGender(String? value) {
//     gender = value;
//     notifyListeners();
//   }

//   // Experiences Operations
//   void addExperience(int experienceId) {
//     _selectedExperienceIds.add(experienceId);
//     notifyListeners();
//   }

//   void removeExperience(int experienceId) {
//     _selectedExperienceIds.remove(experienceId);
//     notifyListeners();
//   }

//   void clearExperiences() {
//     _selectedExperienceIds.clear();
//     notifyListeners();
//   }

//   // Reset all provider data
//   void resetAllData() {
//     _staffList.clear();
//     selectedJobTitle = null;
//     gender = null;
//     selectedJobTitleId = null;
//     _selectedSkillIds.clear();
//     _profileImage = null;
//     _pdfFile = null;
//     _mediaFile = null;
//     _selectedExperienceIds.clear();

//     // Clear all text controllers
//     nameController.clear();
//     countryController.clear();
//     postCodeController.clear();
//     lastNameController.clear();
//     firstNameController.clear();
//     businessDetailsController.clear();
//     identificationController.clear();
//     dateControllers.clear();
//     phonenumber.clear();
//     accountHolderController.clear();
//     accountNumberController.clear();
//     bankcountryController.clear();
//     bankpostCodeController.clear();
//     swiftCodeController.clear();

//     notifyListeners();
//   }

//   // Cleanup
//   @override
//   void dispose() {
//     // Dispose all controllers
//     nameController.dispose();
//     countryController.dispose();
//     postCodeController.dispose();
//     lastNameController.dispose();
//     firstNameController.dispose();
//     businessDetailsController.dispose();
//     identificationController.dispose();
//     dateControllers.dispose();
//     accountHolderController.dispose();
//     accountNumberController.dispose();
//     bankcountryController.dispose();
//     bankpostCodeController.dispose();
//     swiftCodeController.dispose();
//     // Note: phonenumber controller is not disposed here as it's managed by the provider
//     // and should only be disposed when the provider itself is disposed
//     super.dispose();
//   }

//   // Helper Methods
//   void _logSelectedSkills() {
//     log("Selected Skill IDs: ${_selectedSkillIds.toList()}");
//   }
// }
