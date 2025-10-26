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

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
                  "Reset password".tr,
                  style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                    fontSize: 24.sp,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                UIHelper.verticalSpace(40.h),
                Row(
                  children: [
                    Text(
                        "New Password".tr,
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
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
                              color: Colors.black,
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
                Spacer(),
                Container(
                  height: 56.h,
                  width: double.infinity,
                  child: CustomsButton(
                    bgColor1: AppColors.button,
                      bgColor2: AppColors.button,
                    name: 'Continue'.tr,
                    textStyle: TextFontStyle.textStyle18c231F20poppins700
                        .copyWith(fontSize: 15.sp),
                    callback: () {
                      NavigationService.navigateToReplacement(
                        Routes.passwordUpdateSuccessScreen,
                      );
                    },
                  ),
                ),
                UIHelper.verticalSpace(40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
