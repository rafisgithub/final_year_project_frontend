import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';

class PasswordUpdateSuccessScreen extends StatefulWidget {
  const PasswordUpdateSuccessScreen({super.key});

  @override
  State<PasswordUpdateSuccessScreen> createState() =>
      _PasswordUpdateSuccessScreenState();
}

class _PasswordUpdateSuccessScreenState
    extends State<PasswordUpdateSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Spacer(),

              // Success Icon
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.button.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80.sp,
                  color: AppColors.button,
                ),
              ),

              UIHelper.verticalSpace(32.h),

              Text(
                "Password Updated".tr,
                style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.button,
                ),
                textAlign: TextAlign.center,
              ),

              UIHelper.verticalSpace(8.h),

              Text(
                "Successfully".tr,
                style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.c28B446,
                ),
                textAlign: TextAlign.center,
              ),

              UIHelper.verticalSpace(16.h),

              Text(
                "Your password has been successfully updated. Please log in first",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.cA1A1AA,
                ),
                textAlign: TextAlign.center,
              ),

              Spacer(),

              // Login Button
              Container(
                height: 56.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: CustomsButton(
                  bgColor1: AppColors.button,
                  bgColor2: AppColors.c28B446,
                  name: 'Login Now'.tr,
                  textStyle: TextFontStyle.textStyle18c231F20poppins700
                      .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                  callback: () {
                    NavigationService.navigateToReplacementUntilWithObject(
                      Routes.mainNavigationBar,
                      {'pageNum': 0},
                    );
                  },
                ),
              ),

              UIHelper.verticalSpace(32.h),
            ],
          ),
        ),
      ),
    );
  }
}
