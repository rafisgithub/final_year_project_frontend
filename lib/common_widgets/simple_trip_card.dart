// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:final_year_project_frontend/gen/assets.gen.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';
// import 'package:final_year_project_frontend/constants/text_font_style.dart';
// import 'package:final_year_project_frontend/common_widgets/customs_button.dart';

// class SimpleTripCard extends StatelessWidget {
//   const SimpleTripCard({
//     super.key,
//     required this.pickupTime,
//     required this.destinationTime,
//     required this.pickupLocation,
//     required this.destinationLocation,
//     required this.onAccept,
//   });

//   final String pickupTime;
//   final String destinationTime;
//   final String pickupLocation;
//   final String destinationLocation;
//   final VoidCallback onAccept;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.r),
//           side: BorderSide(color: AppColors.c73010B.withValues(alpha: .10)),
//         ),
//       elevation: 0,
//       color: Colors.white,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🚗 PICKUP
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 18.r,
//                   backgroundColor: AppColors.c73010B.withOpacity(0.1),
//                   child: Image.asset(
//                     Assets.icons.locationMarker.path,
//                     height: 20.h,
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Pick up:",
//                         style: TextFontStyle.textStyle16c3D4040EurostileW500
//                             .copyWith(color: AppColors.c8993A4),
//                       ),
//                       SizedBox(height: 4.h),
//                       Row(
//                         children: [
//                           Image.asset(
//                             Assets.icons.clock.path,
//                             height: 14.h,
//                             color: Colors.black,
//                           ),
//                           SizedBox(width: 6.w),
//                           Expanded(
//                             child: Text(
//                               pickupTime,
//                               style:
//                                   TextFontStyle.textStyle16c3D4040EurostileW500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8.h),

//             /// 📍 PICKUP LOCATION
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     pickupLocation,
//                     style: TextFontStyle.textStyle16c3D4040EurostileW500
//                         .copyWith(fontSize: 14.sp),
//                     textAlign: TextAlign.start,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.h),

//             /// 📍 DESTINATION
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 18.r,
//                   backgroundColor: AppColors.c8993A4.withOpacity(0.1),
//                   child: Image.asset(
//                     Assets.icons.locationicon.path,
//                     height: 20.h,
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Destination:",
//                         style: TextFontStyle.textStyle16c3D4040EurostileW500
//                             .copyWith(color: AppColors.c8993A4),
//                       ),
//                       SizedBox(height: 4.h),
//                       Row(
//                         children: [
//                           Image.asset(
//                             Assets.icons.clock.path,
//                             height: 14.h,
//                             color: Colors.black,
//                           ),
//                           SizedBox(width: 6.w),
//                           Expanded(
//                             child: Text(
//                               destinationTime,
//                               style:
//                                   TextFontStyle.textStyle16c3D4040EurostileW500,
//                             ),
//                           ),
//                         ],
//                       ),
                      
//                     ],
//                   ),
//                 ),

//               ],
//             ),
//             SizedBox(height: 8.h),

//             /// 📍 DESTINATION LOCATION
//             Row(
//               children:[
//                       Expanded(
//                         child: Text(
//                           destinationLocation,
//                           style: TextFontStyle.textStyle16c3D4040EurostileW500.copyWith(fontSize: 14.sp),
//                     textAlign: TextAlign.start,
//                         ),
//                       ),
//               ]
//             ),

//             SizedBox(height: 20.h),

//             /// 🧭 ACCEPT BUTTON
//             SizedBox(
//               width: double.infinity,
//               height: 42.h,
//               child: CustomsButton(
//                 name: "Accept",
//                 callback: onAccept,
                
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
