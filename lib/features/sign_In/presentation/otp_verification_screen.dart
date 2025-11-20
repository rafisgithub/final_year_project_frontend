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
import 'package:final_year_project_frontend/networks/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? email;
  
  const OtpVerificationScreen({super.key, this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String? _email;
  bool _isResending = false;
  
  @override
  void initState() {
    super.initState();
    // Get email from route arguments if not passed directly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['email'] != null) {
        setState(() {
          _email = args['email'] as String;
        });
      }
    });
  }
  
  String _maskEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '${username[0]}***@$domain';
    }
    
    final visibleChars = username.substring(0, 2);
    return '$visibleChars***@$domain';
  }
  
  Future<void> _handleResendOtp() async {
    final email = _email ?? widget.email;
    
    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email not found. Please go back and try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isResending = true;
    });
    
    try {
      final response = await AuthService.resendOtp(
        email: email,
        purpose: 'password_reset',
      );
      
      if (response['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'OTP resent successfully'),
              backgroundColor: AppColors.button,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to resend OTP'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                (_email != null && _email!.isNotEmpty) || (widget.email != null && widget.email!.isNotEmpty)
                    ? "Enter the verification code we sent to: ${_maskEmail(_email ?? widget.email ?? '')}"
                    : "Enter the verification code we sent to your email",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.cA1A1AA,
                ),
              ),
              
              UIHelper.verticalSpace(28.h),
              
              CustomOtpPinField(
                maxLength: 4,
                onSubmit: (String) {},
                onChange: (String) {},
              ),

              UIHelper.verticalSpace(20.h),
              
              Center(
                child: _isResending
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                        ),
                      )
                    : CommonTextButton(
                        text: 'Click to resend code',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.button,
                        onTap: _handleResendOtp,
                      ),
              ),

              UIHelper.verticalSpace(40.h),
              
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
                    // Navigate to reset password screen with email
                    final email = _email ?? widget.email;
                    if (email != null && email.isNotEmpty) {
                      NavigationService.navigateToWithArgs(
                        Routes.resetPasswordScreen,
                        {'email': email},
                      );
                    } else {
                      // Fallback if email is missing
                      NavigationService.navigateTo(
                        Routes.resetPasswordScreen,
                      );
                    }
                  },
                ),
              ),
              
              UIHelper.verticalSpace(32.h),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
