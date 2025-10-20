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

class ForgotPasswordscreen extends StatefulWidget {
  const ForgotPasswordscreen({super.key});

  @override
  State<ForgotPasswordscreen> createState() => _ForgotPasswordscreenState();
}

class _ForgotPasswordscreenState extends State<ForgotPasswordscreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: AppColors.c050915),
        child: SafeArea(
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
                  "Forgot password".tr,
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
                UIHelper.verticalSpace(8.h),
                CustomTextField(
                  hintText: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  textColor: AppColors.cFFFFFF,
                ),
                Spacer(),
                Container(
                  height: 56.h,
                  width: double.infinity,
                  child: CustomsButton(
                    name: 'Continue'.tr,
                    textStyle: TextFontStyle.textStyle18c231F20poppins700
                        .copyWith(fontSize: 15.sp),
                    callback: () {
                      NavigationService.navigateTo(
                        Routes.resetPasswordScreen,
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
