
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

class CustomsButton extends StatelessWidget {
  CustomsButton({
    super.key,
    required this.name,
    this.bgColor1,
    this.borderRadius,
    this.bgColor2,
    this.textColor,
    required this.callback,
    this.textStyle,
    this.borderColor, // ✅ Added
  });

  final String name;
  final Color? bgColor1;
  final BorderRadius? borderRadius;
  final Color? bgColor2;
  final Color? textColor;
  final VoidCallback callback;
  TextStyle? textStyle;
  final Color? borderColor; // ✅ Added

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgColor1 ?? AppColors.c8B3AFF, bgColor2 ?? AppColors.cD020FF],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(1000.r),
          border: Border.all(
            color: borderColor ?? Colors.transparent, // ✅ Optional border color
            width: 1.5.w, // ✅ Default border width
          ),
        ),
        child: Center(
          child: Text(
            name.tr,
            style: textStyle ??
                TextFontStyle.textStyle16c3D4040EurostileW500
                    .copyWith(color: textColor ?? AppColors.cF8F3DD),
          ),
        ),
      ),
    );
  }
}
