import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  String _phoneNumber = '';

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.button.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.button.withOpacity(0.08),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.button.withOpacity(0.05),
              Colors.white,
              AppColors.c28B446.withOpacity(0.03),
            ],
          ),
        ),
        child: SafeArea(
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
                              color: AppColors.button.withOpacity(0.1),
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
                      "Create Account".tr,
                      style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    UIHelper.verticalSpace(6.h),
                    Text(
                      "Join us to scan leaves & detect diseases 🌿".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.cA1A1AA,
                      ),
                    ),
                    
                    UIHelper.verticalSpace(28.h),
                    
                    // Name Field
                    Text(
                      "Full Name".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'e.g. Rafi Ahmed',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                    ),
                    
                    UIHelper.verticalSpace(20.h),
                    
                    // Father's Name Field
                    Text(
                      "Father's Name".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    _buildTextField(
                      controller: _fatherNameController,
                      hintText: 'e.g. Nural Sheikh',
                      prefixIcon: Icons.family_restroom_outlined,
                      keyboardType: TextInputType.name,
                    ),
                    
                    UIHelper.verticalSpace(20.h),
                    
                    // Email Field
                    Text(
                      "Email Address".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'e.g. example@gmail.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    UIHelper.verticalSpace(20.h),
                    
                    // Phone Number Field
                    Text(
                      "Phone Number".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.cA1A1AA,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: AppColors.button.withOpacity(0.2), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: AppColors.button.withOpacity(0.2), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: AppColors.button, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                      ),
                      initialCountryCode: 'BD',
                      dropdownIconPosition: IconPosition.trailing,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      onChanged: (phone) {
                        _phoneNumber = phone.completeNumber;
                      },
                    ),
                    
                    UIHelper.verticalSpace(20.h),
                    
                    // Password Field
                    Text(
                      "Password".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    UIHelper.verticalSpace(8.h),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Create a strong password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    
                    UIHelper.verticalSpace(28.h),
                    
                    // Sign Up Button
                    Container(
                      height: 56.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.button.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CustomsButton(
                        bgColor1: AppColors.button,
                        bgColor2: AppColors.c28B446,
                        name: 'Sign Up'.tr,
                        textStyle: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        callback: () {
                          // Collect all data (selected_language will come from language_screen)
                          final signUpData = {
                            'name': _nameController.text,
                            'father_name': _fatherNameController.text,
                            'email': _emailController.text,
                            'phone_number': _phoneNumber,
                            'password': _passwordController.text,
                          };
                          
                          print('Sign Up Data: $signUpData');
                          
                          NavigationService.navigateTo(
                            Routes.otpVerificationScreen,
                          );
                        },
                      ),
                    ),
                    
                    UIHelper.verticalSpace(24.h),
                    
                    // Already have account
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          NavigationService.navigateToReplacement(Routes.signinScreen);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.button,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    UIHelper.verticalSpace(32.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
