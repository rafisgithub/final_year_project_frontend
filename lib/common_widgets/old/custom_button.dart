// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final List<Color> backgroundGradientColors;
//   final List<Color> borderGradientColors;
//   final TextStyle textStyle;
//   final List<Color>? textGradientColors;
//   final Color? solidTextColor;
//   final double? height;

//   const CustomButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     required this.backgroundGradientColors,
//     required this.borderGradientColors,
//     required this.textStyle,
//     this.textGradientColors,
//     this.solidTextColor,
//     this.height,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         height: 56.h,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: backgroundGradientColors,
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16.r),
//           border: Border.all(
//             width: 1.w,
//             color: AppColors.cFEAA65,
//           ),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16.r),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(1.w),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: backgroundGradientColors,
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(14.r),
//                   ),
//                   alignment: Alignment.center,
//                   child: textGradientColors != null
//                       ? ShaderMask(
//                           shaderCallback: (bounds) {
//                             return LinearGradient(
//                               colors: textGradientColors!,
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ).createShader(
//                               Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//                             );
//                           },
//                           blendMode: BlendMode.srcIn,
//                           child: Text(
//                             text,
//                             style: textStyle.copyWith(color: Colors.white),
//                           ),
//                         )
//                       : Text(
//                           text,
//                           style: textStyle.copyWith(color: solidTextColor),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
