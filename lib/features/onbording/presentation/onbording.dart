import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_%20gradient_text.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/assets.gen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class OnbordingScreens extends StatefulWidget {
  
  // ignore: use_super_parameters
  const OnbordingScreens({super.key});

  @override
  State<OnbordingScreens> createState() => _OnbordingScreensState();
}

class _OnbordingScreensState extends State<OnbordingScreens> {
  @override
  void dispose() {
    super.dispose();
  }

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: AppColors.cFFFFFF),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
            
                children: [
                  UIHelper.verticalSpace(28.h),
            //title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Krishi App',
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 24.sp, color: Colors.black),
                      ),
                    ],
                  ),
                  
                  UIHelper.verticalSpace(63.h),
                  //image
                  Center(
                    child: Image(
                      image: AssetImage(Assets.images.splashicom.path),
                    ),
                  ),
                  UIHelper.verticalSpace(150.h),
                 
                  //button
                  SizedBox(
                    height: 48.h,
                    child: CustomsButton(
                      bgColor1: AppColors.button,
                      bgColor2: AppColors.button,
                      name: 'Continue'.tr,
                      callback: () {
                        NavigationService.navigateToReplacement(Routes.languageScreen);
                      },
                      textStyle: TextFontStyle.textStyle18c231F20poppins700
                          .copyWith(fontSize: 15.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
