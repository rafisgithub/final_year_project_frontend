// import 'package:flutter/material.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';

// class GradientMask extends StatelessWidget {
//   final Widget child; // Dynamic child widget

//   // ignore: use_super_parameters
//   const GradientMask({
//     Key? key,
//     required this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (bounds) {
//         return const LinearGradient(
//           colors: [
//             AppColors.cFEAA65,
//             AppColors.cFF5E4F,
//             AppColors.cD676FF,
//           ],
//           begin: Alignment.bottomRight,
//           end: Alignment.topLeft,
//           transform: GradientRotation(
//               160 * 3.141592653589793 / 180), // Rotation in radians
//         ).createShader(bounds);
//       },
//       blendMode: BlendMode.srcIn,
//       child: child,
//     );
//   }
// }
