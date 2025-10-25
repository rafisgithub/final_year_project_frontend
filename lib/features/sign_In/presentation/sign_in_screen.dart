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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
        decoration: BoxDecoration(color: AppColors.cFFFFFF),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UIHelper.verticalSpace(40.h),
                
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
                UIHelper.verticalSpace(40.h),
                Text(
                  "Welcome back".tr,
                  style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                    fontSize: 24.sp,
                  ),
                  textAlign: TextAlign.center,
                ),

                UIHelper.verticalSpace(40.h),
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
                  hintText: 'Email address',
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
                  textColor: Colors.black,
                ),
                UIHelper.verticalSpace(16.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigateTo(Routes.forgotPasswordscreen);
                      },
                      child: GradientText(
                        text: 'Forgot password?',
                        gradient: LinearGradient(
                          colors: [Colors.black, Colors.black],
                        ),
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(
                              fontSize: 12.sp,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ],
                ),
                UIHelper.verticalSpace(20.h),

                UIHelper.verticalSpace(40.h),
                Container(
                  height: 56.h,
                  width: double.infinity,
                  child: CustomsButton(
                    bgColor1: AppColors.button,
                      bgColor2: AppColors.button,
                    name: 'Login'.tr,
                    textStyle: TextFontStyle.textStyle18c231F20poppins700
                        .copyWith(fontSize: 15.sp),
                    callback: () {
                      NavigationService.navigateToReplacement(
                        Routes.otpVerificationScreen,
                      );
                    },
                  ),
                ),

                UIHelper.verticalSpace(40.h),
                 GestureDetector(
                  onTap: () {},
                   child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 12.sp,fontWeight: FontWeight.w400,color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {
                          NavigationService.navigateTo(Routes.signUpScreen);
                        },
                        child: GradientText(
                          text: 'Sign up',
                          gradient: LinearGradient(
                            colors: [Colors.black, Colors.black],
                          ),
                          style: TextFontStyle.textStyle18c231F20poppins700
                              .copyWith(fontSize: 12.sp,fontWeight: FontWeight.w600,decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                                   ),
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
