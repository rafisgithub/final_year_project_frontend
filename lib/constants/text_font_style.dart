import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';


class TextFontStyle {
//Initialising Constractor
  TextFontStyle._();

  // static final textStyle24c222222QuandoW400 = GoogleFonts.quando(
  //     color: AppColors.c000000, fontSize: 24.sp, fontWeight: FontWeight.w400);

  static final textStyle12c7E7E7Epoppins400 = GoogleFonts.poppins(
      color: AppColors.c7E7E7E, fontSize: 12.sp, fontWeight: FontWeight.w400);

  static final textStyle14cFFFFFFpoppinw400 = GoogleFonts.poppins(
      color: AppColors.cFFFFFF, fontSize: 14.sp, fontWeight: FontWeight.w400);

  static final textStyle16c231F20IBMPlexSans400 = GoogleFonts.ibmPlexSans(
      color: AppColors.cFFFFFF, fontSize: 16.sp, fontWeight: FontWeight.w600);

  static final textStyle18c231F20poppins700 = GoogleFonts.poppins(
      color: AppColors.cFFFFFF, fontSize: 18.sp, fontWeight: FontWeight.w700);

  // static final textStyle16c231F20ibmPlexSans400 = GoogleFonts.ibmPlexSans(
  //     color: AppColors.c231F20, fontSize: 16.sp, fontWeight: FontWeight.w400);

  // static final textStyle16cA5A5A5ibmPlexSans400 = GoogleFonts.ibmPlexSans(
  //     color: AppColors.cA5A5A5, fontSize: 16.sp, fontWeight: FontWeight.w400);

  // static final textStyle16c333333poppins500 = GoogleFonts.poppins(
  //     color: AppColors.c333333, fontSize: 16.sp, fontWeight: FontWeight.w500);

  // static final textStyle14c000000poppins400 = GoogleFonts.poppins(
  //     color: AppColors.c000000, fontSize: 14.sp, fontWeight: FontWeight.w400);

  // static final textStyle14cE96BAEpoppins400 = GoogleFonts.euro(
  //     color: AppColors.cE96BAE, fontSize: 14.sp, fontWeight: FontWeight.w400);

  // 16px, 400, #8993A4
  static final textStyle16c8993A4EurostileW400 = TextStyle(
    color: AppColors.c8993A4,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Eurostile',
  );

  // 24px, 700, #3D4040, center
  static final textStyle24c3D4040EurostileW700 = TextStyle(
    color: AppColors.c3D4040,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Eurostile',
    height: 1.0,
  );

  // 16px, 400, #8993A4, center
  static final textStyle16c8993A4EurostileW400Center = TextStyle(
    color: AppColors.c8993A4,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Eurostile',
  );

  // 20px, 700, #3D4040, center
  static final textStyle20c3D4040EurostileW700Center = TextStyle(
    color: AppColors.c3D4040,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    fontFamily: 'Eurostile',
    height: 1.0,
  );


  // 16px, 500, #3D4040
  static final textStyle16c3D4040EurostileW500 = TextStyle(
    color: AppColors.c3D4040,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Eurostile',
  );

  // 16px, 400, #8993A4
  static final textStyle16c8993A4EurostileW400Alt = TextStyle(
    color: AppColors.c8993A4,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Eurostile',
    height: 26 / 16,
  );

  // Text field: 16px, 400, #8993A4, line-height 16px
  static final textStyle16c8993A4EurostileField = TextStyle(
    color: AppColors.c8993A4,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Eurostile',
    height: 16 / 16,
  );

  // Aggre text: 16px, 500, #73010B, underline
  static final textStyle16c73010BEurostileW500Underline = TextStyle(
    color: AppColors.c73010B,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'Eurostile',
    height: 26 / 16,
    decoration: TextDecoration.underline,
    decorationStyle: TextDecorationStyle.solid,
    decorationThickness: 0.095 * 16,
  );

  // 16px, 400, #73010B
  static final textStyle16c73010BEurostileW400 = TextStyle(
    color: AppColors.c73010B,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'Eurostile',
    height: 26 / 16,
  );

  // static final textStyle14c54585CDmSans400 =
  //     TextStyle(fontFamilyFallback: const [
  //   'DMSans',
  //   'Open Sans',
  //   'Roboto',
  //   'Noto Sans',
  // ], color: AppColors.c54585C, fontSize: 14.sp, fontWeight: FontWeight.w400);
}
