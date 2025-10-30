import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/common_widgets/common_text_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.button.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.button.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.button,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.cA1A1AA,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: AppColors.button,
            size: 22.sp,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.cA1A1AA,
                    size: 22.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.button, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                    
                    // Welcome Text
                    Text(
                      "Welcome Back".tr,
                      style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    UIHelper.verticalSpace(6.h),
                    Text(
                      "Login to protect crops from diseases 🌾".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.cA1A1AA,
                      ),
                    ),
                    
                    UIHelper.verticalSpace(28.h),
                
                // Email Field
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  labelText: "Email Address".tr,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                
                UIHelper.verticalSpace(20.h),
                
                // Password Field
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Enter password',
                  labelText: "Password".tr,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                ),
                
                UIHelper.verticalSpace(16.h),
                
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: CommonTextButton(
                    text: 'Forgot password?',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      NavigationService.navigateTo(Routes.forgotPasswordscreen);
                    },
                  ),
                ),
                
                UIHelper.verticalSpace(28.h),
                
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
                    name: 'Login'.tr,
                    textStyle: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    callback: () {
                      // TODO: Implement login logic
                      // Collect and send login data to API
                      // Example:
                      // final loginData = {
                      //   'email': _emailController.text,
                      //   'password': _passwordController.text,
                      // };
                      
                      NavigationService.navigateToWithArgs(
                        Routes.mainNavigationBar,
                        {
                          'pageNum': 0,
                        },
                      );
                    },
                  ),
                ),
                
                UIHelper.verticalSpace(24.h),
                
                // Don't have account
                Center(
                  child: CommonTextButtonWithPrefix(
                    prefixText: "Don't have an account? ",
                    buttonText: 'Sign up',
                    onTap: () {
                      NavigationService.navigateTo(Routes.signUpScreen);
                    },
                  ),
                ),
                
                UIHelper.verticalSpace(32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
