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
  String? _selectedLanguage;
  @override
  void dispose() {
    super.dispose();
  }

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.h),
              Expanded(
                flex: 1,
                child: Text(
                  'Krishi App',
                  style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                    fontSize: 24.sp,
                    color: Colors.black,
                  ),
                ),
              ),
              //title
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    //image
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      height: 48.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: AppColors.cA1A1AA,
                          width: 1.w,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: 'English',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.language,
                                  size: 20.sp,
                                  color: AppColors.cA1A1AA,
                                ),
                                const SizedBox(width: 10),
                                Text('English'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Bangla',
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10.r,
                                  backgroundColor: AppColors.button,
                                  child: CircleAvatar(
                                    radius: 5.r,
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text('Bangla'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                        },
                        hint: const Row(
                          children: [
                            Icon(Icons.language),
                            SizedBox(width: 10),
                            Text('Select Language'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //button
              SizedBox(
                height: 48.h,
                child: CustomsButton(
                  bgColor1: AppColors.button,
                  bgColor2: AppColors.button,
                  name: 'Continue'.tr,
                  callback: () {
                    NavigationService.navigateToReplacement(
                      Routes.signinScreen,
                    );
                  },
                  textStyle: TextFontStyle.textStyle18c231F20poppins700
                      .copyWith(fontSize: 15.sp),
                ),
              ),
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}
