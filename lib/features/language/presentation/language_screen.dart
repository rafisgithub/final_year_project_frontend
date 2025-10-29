import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class LanguageScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage = 'Bangla'; 


  final List<Map<String, dynamic>> _languages = [
    {'name': 'Bangla', 'nativeName': 'বাংলা', 'flag': '🇧🇩', 'code': 'bn'},
    {'name': 'English', 'nativeName': 'English', 'flag': '🇬🇧', 'code': 'en'},
  ];

  @override
  void dispose() {
    super.dispose();
  }

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              // App Title
              Center(
                child: Text(
                  'Krishi App',
                  style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                    fontSize: 32.sp,
                    color: AppColors.button,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: 60.h),

              // Language Selection Title
              Text(
                'Choose Your Language',
                style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                  fontSize: 24.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Select your preferred language',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.cA1A1AA,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 32.h),

              // Language Options
              Expanded(
                child: ListView.builder(
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = _selectedLanguage == language['name'];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedLanguage = language['name'];
                          });
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 20.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.button.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.button
                                  : AppColors.cA1A1AA.withOpacity(0.3),
                              width: isSelected ? 2.w : 1.w,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.button.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              // Flag Emoji
                              Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.button.withOpacity(0.1)
                                      : AppColors.cA1A1AA.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Text(
                                    language['flag'],
                                    style: TextStyle(fontSize: 28.sp),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),

                              // Language Names
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      language['name'],
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppColors.button
                                            : Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      language['nativeName'],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.cA1A1AA,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Check Icon
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isSelected ? 1.0 : 0.0,
                                child: Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.button,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Continue Button
              SizedBox(
                height: 56.h,
                child: CustomsButton(
                  bgColor1: _selectedLanguage != null
                      ? AppColors.button
                      : AppColors.cA1A1AA.withOpacity(0.3),
                  bgColor2: _selectedLanguage != null
                      ? AppColors.button
                      : AppColors.cA1A1AA.withOpacity(0.3),
                  name: 'Continue'.tr,
                  callback: _selectedLanguage != null
                      ? () {
                          NavigationService.navigateToReplacement(
                            Routes.signUpScreen,
                          );
                        }
                      : () {},
                  textStyle: TextFontStyle.textStyle18c231F20poppins700
                      .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
