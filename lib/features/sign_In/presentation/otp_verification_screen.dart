import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_%20gradient_text.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/common_widgets/common_text_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/features/sign_In/widgets/custom_otp_field_widget.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
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

                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "OTP Verification".tr,
                    style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                      fontSize: 24.sp,
                      height: 1.6.h,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                UIHelper.verticalSpace(15.h),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Enter the verification code we send you on: Alberts******@gmail.com",
                    style: TextFontStyle.textStyle12c7E7E7Epoppins400.copyWith(
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                UIHelper.verticalSpace(40.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: CustomOtpPinField(onSubmit: (String ) {  }, onChange: (String ) {  },),
                ),

                UIHelper.verticalSpace(60.h),
                                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateToReplacement(Routes.signinScreen);
                    },
                     child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t receive the code? ",
                          style: TextFontStyle.textStyle18c231F20poppins700
                              .copyWith(fontSize: 12.sp,fontWeight: FontWeight.w400,color: Colors.black),
                        ),
                        GradientText(
                          text: 'Click to resend code',
                          gradient: LinearGradient(
                            colors: [Colors.black, Colors.black],
                          ),
                          style: TextFontStyle.textStyle18c231F20poppins700
                              .copyWith(fontSize: 12.sp,fontWeight: FontWeight.w600,decoration: TextDecoration.underline),
                        ),
                      ],
                                     ),
                   ),
                

                UIHelper.verticalSpace(120.h),
                SizedBox(
                  height: 48.h,
                  width: double.infinity,
                  child: CustomsButton(
                    bgColor1: AppColors.button,
                    bgColor2: AppColors.button,
                    name: 'Confirm'.tr,
                    callback: () {
                      NavigationService.navigateToWithArgs(
                        Routes.mainNavigationBar,
                        {
                          'pageNum': 0,
                        }
                      );
                    },
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
