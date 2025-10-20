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
        decoration: BoxDecoration(color: AppColors.c050915),
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
                        'Aura',
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 24.sp),
                      ),
                      GradientText(
                        text: 'Forge',
                        gradient: LinearGradient(
                          colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                        ),
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 24.sp),
                      ),
                    ],
                  ),
                  
                  UIHelper.verticalSpace(63.h),
                  //image
                  Center(
                    child: Image(
                      image: AssetImage(Assets.images.onbordingsenterlogo.path,) ,
                    ).animate(onPlay: (controller) => controller.repeat(),).shimmer(
                      duration: 3000.ms,
                      delay: 1000.ms,
                      color: AppColors.cD020FF.withValues(alpha: .25)
                    ),
                  ),
                  UIHelper.verticalSpace(63.h),
                  Wrap(
                   alignment:WrapAlignment.center,
                    children: [
                      Text(
                        'Discover the ',
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 20.sp),
                      ),
                      GradientText(
                        text: 'intelligence',
                        gradient: LinearGradient(
                          colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                        ),
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 20.sp),
                      ),
                      Text(
                        ' of',
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 20.sp),
                      ),
                       Text(
                        'Aura',
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 20.sp),
                      ),
                      GradientText(
                        text: ' Forge',
                        gradient: LinearGradient(
                          colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                        ),
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 20.sp),
                      ),
                      Text(
                        ' Ai',
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 20.sp),
                      ),
            
                    ],
                  ),
                  Text('AuraForge AI: Where Your Imagination Becomes an Intelligent Reality',style: TextFontStyle.textStyle12c7E7E7Epoppins400.copyWith(
                   fontSize: 14.sp
                  ),textAlign: TextAlign.center,),
            UIHelper.verticalSpace(63.h),
                  //button
                  SizedBox(
                    height: 48.h,
                    child: CustomsButton(
                      name: 'Get Started',
                      callback: () {
                        NavigationService.navigateToReplacement(Routes.signinScreen);
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
