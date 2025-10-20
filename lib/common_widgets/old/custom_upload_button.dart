import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';

// ignore: must_be_immutable
class CustomUploadButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> backgroundGradientColors;
  final List<Color> borderGradientColors;
  final TextStyle textStyle;
  final List<Color>? textGradientColors;
  final Color? solidTextColor;
  final String? icon;
  double? fontSize;
  double? height;

  CustomUploadButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundGradientColors,
    required this.borderGradientColors,
    required this.textStyle,
    this.textGradientColors,
    this.solidTextColor,
    this.icon,
    this.fontSize,
    this.height,
  }) : assert(
          textGradientColors != null || solidTextColor != null,
          '',
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: IntrinsicWidth(
        child: Container(
          height: height?? 38.h,

          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 14.w), // Adjust padding
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: backgroundGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              width: 1.w,
              color: Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              textGradientColors != null
                  ? ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: textGradientColors!,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        );
                      },
                      blendMode: BlendMode.srcIn,
                      child: Text(
                        text,
                        style: textStyle,
                      ),
                    )
                  : Text(
                      text,
                      style: textStyle.copyWith(
                          color: solidTextColor, fontSize: fontSize),
                    ),
              UIHelper.horizontalSpace(10.w),
              if (icon != null) ...[
                SvgPicture.asset(
                  icon!,
                  height: 16.h,
                  width: 16.w,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
