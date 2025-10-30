import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(24.h),
              
              // Back Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: AppColors.button),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              
              UIHelper.verticalSpace(16.h),
              
              // App Title with Agricultural Icon
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.button.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.eco,
                        size: 40.sp,
                        color: AppColors.button,
                      ),
                    ),
                    UIHelper.verticalSpace(12.h),
                    Text(
                      'Krishi App',
                      style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                        fontSize: 28.sp,
                        color: AppColors.button,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '🌱 Agricultural Officer Assistant',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.c28B446,
                      ),
                    ),
                  ],
                ),
              ),
              
              UIHelper.verticalSpace(24.h),
              
              // Title Text
              Text(
                "OTP Verification".tr,
                style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              UIHelper.verticalSpace(6.h),
              Text(
                "Enter the verification code we send you on: Alberts******@gmail.com",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.cA1A1AA,
                ),
              ),
              
              UIHelper.verticalSpace(28.h),
              
              CustomOtpPinField(
                onSubmit: (String) {},
                onChange: (String) {},
              ),

              UIHelper.verticalSpace(20.h),
              
              Center(
                child: CommonTextButton(
                  text: 'Click to resend code',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.button,
                  onTap: () {
                    // TODO: Implement resend code logic
                  },
                ),
              ),

              Spacer(),
              
              // Confirm Button
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
                  name: 'Confirm'.tr,
                  textStyle: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  callback: () {
                    NavigationService.navigateToWithArgs(
                      Routes.mainNavigationBar,
                      {
                        'pageNum': 0,
                      },
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
