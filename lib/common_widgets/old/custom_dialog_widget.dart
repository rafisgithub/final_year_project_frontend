// // ignore_for_file: use_super_parameters
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:final_year_project_frontend/constants/text_font_style.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';
// import 'package:final_year_project_frontend/helpers/navigation_service.dart';
// import 'package:final_year_project_frontend/helpers/ui_helpers.dart';
//
// import 'custom_button.dart';
//
// class CusatomDialogWidget extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String buttonText;
//   final VoidCallback onPressed;
//   final String iconPath;
//
//   const CusatomDialogWidget({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.buttonText,
//     required this.onPressed,
//     required this.iconPath,
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.center,
//       child: Material(
//         color: Colors.transparent,
//         child: IntrinsicHeight(
//           child: Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(24.w),
//                 child: Container(
//                   padding: EdgeInsets.all(24.w),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColors.cFFFFFF,
//                     borderRadius: BorderRadius.circular(24.r),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(iconPath),
//                       // UIHelper.verticalSpace(24.h),
//                       Text(
//                         title,
//                         style: TextFontStyle
//                             .textStyle16c231F20GothamRoundedMedium500
//                             .copyWith(
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.c222222,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       UIHelper.verticalSpace(12.h),
//                       Text(
//                         subtitle,
//                         style: TextFontStyle
//                             .textStyle16c231F20GothamRoundedMedium500
//                             .copyWith(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.cA5A5A5,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       UIHelper.verticalSpace(24.h),
//                       CustomButton(
//                         backgroundGradientColors: const [
//                           Color(0xFFFFA865),
//                           Color(0xFFFF5E4F),
//                           Color(0xFFD676FF)
//                         ],
//                         onPressed: onPressed,
//                         text: buttonText,
//                         textGradientColors: const [
//                           AppColors.cFFFFFF,
//                           AppColors.cFFFFFF
//                         ],
//                         borderGradientColors: const [Colors.transparent],
//                         textStyle: TextFontStyle
//                             .textStyle16c231F20GothamRoundedMedium500
//                             .copyWith(
//                                 fontSize: 18.sp, color: AppColors.cFFFFFF),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: GestureDetector(
//                   onTap: () {
//                     NavigationService.goBack;
//                   },
//                   child: SvgPicture.asset('assets/icons/crossBtn.svg'),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.center,
//       child: Material(
//         color: Colors.transparent,
//         child: IntrinsicHeight(
//           child: Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(24.w),
//                 child: Container(
//                   padding: EdgeInsets.all(24.w),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColors.cFFFFFF,
//                     borderRadius: BorderRadius.circular(24.r),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(iconPath),
//                       // UIHelper.verticalSpace(24.h),
//                       Text(
//                         title,
//                         style: TextFontStyle
//                             .textStyle16c231F20GothamRoundedMedium500
//                             .copyWith(
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.c222222,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       UIHelper.verticalSpace(12.h),
//                       Text(
//                         subtitle,
//                         style: TextFontStyle
//                             .textStyle16c231F20GothamRoundedMedium500
//                             .copyWith(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w400,
//                           color: AppColors.cA5A5A5,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       UIHelper.verticalSpace(24.h),
//                       CustomButton(
//                         backgroundGradientColors: const [
//                           Color(0xFFFFA865),
//                           Color(0xFFFF5E4F),
//                           Color(0xFFD676FF)
//                         ],
//                         onPressed: onPressed,
//                         text: buttonText,
//                         textGradientColors: const [
//                           AppColors.cFFFFFF,
//                           AppColors.cFFFFFF
//                         ],
//                         borderGradientColors: const [Colors.transparent],
//                         textStyle: TextFontStyle
//                             .textStyle16c231F20GothamRoundedMedium500
//                             .copyWith(
//                             fontSize: 18.sp, color: AppColors.cFFFFFF),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: GestureDetector(
//                   onTap: () {
//                     NavigationService.goBack;
//                   },
//                   child: SvgPicture.asset('assets/icons/crossBtn.svg'),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// // // void showCusatomDialogWidget({
// // //   required BuildContext context,
// // //   required String title,
// // //   required String subtitle,
// // //   required String buttonText,
// // //   required VoidCallback onPressed,
// // //   required String iconPath,
// // // }) {
// // //   showDialog(
// // //     context: context,
// // //     barrierDismissible: false,
// // //     builder: (BuildContext context) {
// // //       return CusatomDialogWidget(
// // //         title: title,
// // //         subtitle: subtitle,
// // //         buttonText: buttonText,
// // //         onPressed: onPressed,
// // //         iconPath: iconPath,
// // //       );
// // //     },
// // //   );
// // // }
