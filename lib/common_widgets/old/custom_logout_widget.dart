// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
// import 'package:final_year_project_frontend/constants/text_font_style.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';
// import 'package:final_year_project_frontend/helpers/all_routes.dart';
// import 'package:final_year_project_frontend/helpers/navigation_service.dart';
// import 'package:final_year_project_frontend/helpers/ui_helpers.dart';
// import 'package:final_year_project_frontend/constants/app_constants.dart';
// import 'package:final_year_project_frontend/helpers/di.dart';

// class CustomLogoutWidget extends StatelessWidget {
//   const CustomLogoutWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       height: 226.h,
//       padding: EdgeInsets.symmetric(horizontal: 21.w),
//       decoration: BoxDecoration(
//           color: AppColors.cFFFFFF,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           UIHelper.verticalSpace(10.h),
//           Container(
//             height: 4.h,
//             width: 48.w,
//             decoration: BoxDecoration(
//               color: AppColors.c091E42,
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//           ),
//           UIHelper.verticalSpace(20.h),
//           Text(
//             'Log Out',
//             style: TextFontStyle.textStyle12c231F20GothamRoundedBook400
//                 .copyWith(
//                     fontSize: 18.sp,
//                     color: AppColors.c091E42,
//                     fontWeight: FontWeight.w500,
//                     letterSpacing: 2.4.sp),
//           ),
//           UIHelper.verticalSpace(16.h),
//           Divider(
//             color: AppColors.c091E42.withOpacity(0.4),
//             thickness: .8.sp,
//           ),
//           UIHelper.verticalSpace(10.h),
//           Text('Are you sure you want to log out?',
//               style: TextFontStyle.textStyle12c231F20GothamRoundedBook400
//                   .copyWith(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.c091E42)),
//           UIHelper.verticalSpace(25.h),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CustomsButton(
//                 name: 'Cancel',
//                 bgColor: AppColors.c091E42,
//                 textStyle: TextFontStyle.textStyle12c231F20GothamRoundedBook400
//                     .copyWith(
//                   color: AppColors.c091E42,
//                   fontWeight: FontWeight.w500,
//                   fontStyle: FontStyle.normal,
//                   height: 1.5,
//                 ),
//                 callback: () {
//                   log('Login functionality will be implement here.');
//                   NavigationService.goBeBack;
//                 },
//                 textColor: AppColors.allPrimaryColor,
//                 borderColor: Colors.transparent,
//               ),
//               UIHelper.horizontalSpace(31.w),
//               CustomsButton(
//                   name: 'Yes, Logout',
//                   bgColor: AppColors.allPrimaryColor,
//                   callback: () async {
//                     // Clear user data
//                     await appData.write(kKeyIsLoggedIn, false);
//                     await appData.write(kKeyAccessToken, "");

//                     // Navigate to sign in screen after widget is disposed
//                     Future.microtask(() {
//                       NavigationService.navigateToReplacementUntil(
//                           Routes.signInScreen);
//                     });
//                   },
//                   textStyle: TextFontStyle
//                       .textStyle12c231F20GothamRoundedBook400
//                       .copyWith(
//                           fontSize: 14.sp,
//                           color: AppColors.cFFFFFF,
//                           fontWeight: FontWeight.w500,
//                           height: 1.5,
//                           fontStyle: FontStyle.normal),
//                   textColor: Colors.transparent),
//             ],
//           ),
//           UIHelper.verticalSpace(15.h),
//         ],
//       ),
//     );
//   }
// }
