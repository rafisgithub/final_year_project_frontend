// import 'package:flutter/material.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';

// class CustomGradientMask extends StatelessWidget {
//   final Widget child; // Dynamic child widget

//   // ignore: use_super_parameters
//   const GradientMask(
//     Type text, {
//     Key? key,
//     required this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (bounds) {
//         return LinearGradient(
//           colors: [
//             AppColors.cFEAA65.withOpacity(1.0),
//             AppColors.cFF5E4F.withOpacity(1.0),
//             AppColors.cD676FF.withOpacity(1.0),
//           ],
//           begin: Alignment.bottomRight,
//           end: Alignment.topLeft,
//           transform: const GradientRotation(
//               160 * 3.141592653589793 / 180), // Rotation in radians
//         ).createShader(bounds);
//       },
//       blendMode: BlendMode.srcIn,
//       child: child,
//     );
//   }
// }
