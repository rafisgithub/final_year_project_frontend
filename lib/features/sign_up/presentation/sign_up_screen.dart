import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/common_widgets/common_text_button.dart';
import 'package:final_year_project_frontend/common_widgets/google_sign_in_button.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/di.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';
import 'package:final_year_project_frontend/networks/auth_service.dart';

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
  bool _isLoading = false;
  String _phoneNumber = '';

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Get selected language from storage or default to 'en'
        // Storage format is 'en_US' or 'bn_BD', but backend expects 'en' or 'bn'
        final storedLanguage = appData.read(kKeyLanguage) ?? 'en';
        final selectedLanguage = storedLanguage.contains('_')
            ? storedLanguage.split('_')[0]
            : storedLanguage;

        final result = await AuthService.signUp(
          name: _nameController.text.trim(),
          fatherName: _fatherNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneNumber,
          password: _passwordController.text,
          selectedLanguage: selectedLanguage,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (result['success'] == true) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result['message'] ?? 'Account created successfully!',
                ),
                backgroundColor: AppColors.button,
                duration: Duration(seconds: 2),
              ),
            );

            // Navigate to home page
            NavigationService.navigateToWithArgs(Routes.mainNavigationBar, {
              'pageNum': 0,
            });
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Sign up failed'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
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
        border: Border.all(
          color: AppColors.button.withValues(alpha: 0.2),
          width: 1.5,
        ),
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
          hintText: hintText,
          labelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.button,
          ),
          hintStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.cA1A1AA,
          ),
          prefixIcon: Icon(prefixIcon, color: AppColors.button, size: 22.sp),
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
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 18.h,
          ),
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
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20.sp,
                      color: AppColors.button,
                    ),
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
                          style: TextFontStyle.textStyle18c231F20poppins700
                              .copyWith(
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
                  _buildTextField(
                    controller: _nameController,
                    labelText: 'Full Name'.tr,
                    hintText: 'e.g. Rafi Ahmed',
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),

                  UIHelper.verticalSpace(20.h),

                  // Father's Name Field
                  _buildTextField(
                    controller: _fatherNameController,
                    labelText: "Father's Name".tr,
                    hintText: 'e.g. Nural Sheikh',
                    prefixIcon: Icons.family_restroom_outlined,
                    keyboardType: TextInputType.name,
                  ),

                  UIHelper.verticalSpace(20.h),

                  // Email Field
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email Address'.tr,
                    hintText: 'e.g. example@gmail.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  UIHelper.verticalSpace(20.h),

                  // Phone Number Field
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number'.tr,
                      hintText: 'Phone Number',
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.button,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.cA1A1AA,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: AppColors.button.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: AppColors.button.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: AppColors.button,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 18.h,
                      ),
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
                  _buildTextField(
                    controller: _passwordController,
                    labelText: 'Password'.tr,
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
                          color: AppColors.button.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? Center(
                            child: SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          )
                        : CustomsButton(
                            bgColor1: AppColors.button,
                            bgColor2: AppColors.c28B446,
                            name: 'Sign Up'.tr,
                            textStyle: TextFontStyle
                                .textStyle18c231F20poppins700
                                .copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                            callback: _isLoading ? () {} : _handleSignUp,
                          ),
                  ),

                  UIHelper.verticalSpace(28.h),

                  // Divider with "OR"
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.cA1A1AA.withValues(alpha: 0.3),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cA1A1AA,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.cA1A1AA.withValues(alpha: 0.3),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  UIHelper.verticalSpace(28.h),

                  // Google Sign In Button
                  GoogleSignInButton(),

                  UIHelper.verticalSpace(24.h),

                  // Already have account
                  Center(
                    child: CommonTextButtonWithPrefix(
                      prefixText: "Already have an account? ",
                      buttonText: 'Login',
                      onTap: () {
                        NavigationService.navigateToReplacement(
                          Routes.signinScreen,
                        );
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
