import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:flutter/gestures.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_%20gradient_text.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_textfield.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/assets.gen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final sharedDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.transparent,

    border: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.cF2F0F0, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.cF2F0F0, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
    ),
    hintStyle: TextFontStyle.textStyle16c8993A4EurostileW400,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.cF2F0F0, width: 2.0),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: AppColors.c050915),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UIHelper.verticalSpace(40.h),
                  Image(image: AssetImage(Assets.images.justlogoPng.path)),
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
                  UIHelper.verticalSpace(40.h),
                  Text(
                    "Sign Up".tr,
                    style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                      fontSize: 24.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
            
                  UIHelper.verticalSpace(12.h),
                  Row(
                    children: [
                      Text(
                        "Full name".tr,
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  CustomTextField(
                    hintText: 'Enter your full name',
                    keyboardType: TextInputType.name,
                    textColor: AppColors.cFFFFFF,
                  ),
                  UIHelper.verticalSpace(16.h),
                  Row(
                    children: [
                      Text(
                        "Email address".tr,
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  CustomTextField(
                    hintText: 'Enter Your Email address',
                    keyboardType: TextInputType.emailAddress,
                    textColor: AppColors.cFFFFFF,
                  ),
                
                  UIHelper.verticalSpace(8.h),
                  Row(
                    children: [
                      Text(
                        "Password".tr,
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  CustomTextField(
                    hintText: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textColor: AppColors.cFFFFFF,
                  ),
                  UIHelper.verticalSpace(16.h),
                  Row(
                    children: [
                      Text(
                        "Confirm Password".tr,
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(8.h),
                  CustomTextField(
                    hintText: 'Re-Enter Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textColor: AppColors.cFFFFFF,
                  ),
                 
                  UIHelper.verticalSpace(20.h),
                  Row(
                    spacing: 5.h,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Divider(
                          color: AppColors.cD5D5D5, // line color
                          thickness: 1, // line thickness
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Or'.tr,
                          style: TextFontStyle.textStyle14cFFFFFFpoppinw400,
                        ),
                      ),
                      Flexible(
                        child: Divider(
                          color: AppColors.cD5D5D5, // line color
                          thickness: 1, // line thickness
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpace(12.h),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.cF2F0F0, // border color
                          width: 1.0, // border thickness
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      height: 56.h,
                      width: double.infinity,
                      child: Row(
                        children: [
                          // Icon aligned to start
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              Assets.icons.googleicon.path,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          // Use Expanded so text takes remaining space and centers itself
                          Expanded(
                            child: Text(
                              'Continue with Google'.tr,
                              style: TextFontStyle.textStyle14cFFFFFFpoppinw400,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            
                  UIHelper.verticalSpace(40.h),
                  Container(
                    height: 56.h,
                    width: double.infinity,
                    child: CustomsButton(
                      name: 'Sign Up'.tr,
                      textStyle: TextFontStyle.textStyle18c231F20poppins700
                          .copyWith(fontSize: 15.sp),
                      callback: () {
                        NavigationService.navigateTo(
                          Routes.otpVerificationScreen,
                        );
                      },
                    ),
                  ),
            
                  UIHelper.verticalSpace(40.h),
                   GestureDetector(
                    onTap: () {
                      NavigationService.navigateToReplacement(Routes.signinScreen);
                    },
                     child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextFontStyle.textStyle18c231F20poppins700
                              .copyWith(fontSize: 12.sp,fontWeight: FontWeight.w400),
                        ),
                        GradientText(
                          text: 'Login',
                          gradient: LinearGradient(
                            colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                          ),
                          style: TextFontStyle.textStyle18c231F20poppins700
                              .copyWith(fontSize: 12.sp,fontWeight: FontWeight.w600,decoration: TextDecoration.underline),
                        ),
                      ],
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
