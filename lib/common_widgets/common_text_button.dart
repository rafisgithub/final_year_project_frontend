import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

/// Common text button widget for consistent design across the app
/// Used for text links like "Forgot password?", "Sign up", "Login" links
class CommonTextButton extends StatelessWidget {
  const CommonTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.hasUnderline = true,
  });

  final String text;
  final VoidCallback onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final bool hasUnderline;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 14.sp,
          fontWeight: fontWeight ?? FontWeight.w700,
          color: color ?? AppColors.button,
          decoration: hasUnderline ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}

/// Common text button with prefix text (e.g., "Already have an account? Login")
class CommonTextButtonWithPrefix extends StatelessWidget {
  const CommonTextButtonWithPrefix({
    super.key,
    required this.prefixText,
    required this.buttonText,
    required this.onTap,
    this.fontSize,
    this.prefixColor,
    this.buttonColor,
  });

  final String prefixText;
  final String buttonText;
  final VoidCallback onTap;
  final double? fontSize;
  final Color? prefixColor;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            prefixText,
            style: TextStyle(
              fontSize: fontSize ?? 14.sp,
              fontWeight: FontWeight.w400,
              color: prefixColor ?? Colors.black87,
            ),
          ),
          Text(
            buttonText,
            style: TextStyle(
              fontSize: fontSize ?? 14.sp,
              fontWeight: FontWeight.w700,
              color: buttonColor ?? AppColors.button,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
