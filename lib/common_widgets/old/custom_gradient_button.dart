// import 'package:flutter/material.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';

// class CustomGradientButton extends StatelessWidget {
//   final String text;
//   final double width;
//   final double height;
//   final VoidCallback onPressed;

//   // ignore: use_super_parameters
//   const CustomGradientButton({
//     Key? key,
//     required this.text,
//     required this.width,
//     required this.height,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: const LinearGradient(
//             colors: [
//               AppColors.cFEAA65,
//               AppColors.cFF5E4F,
//               AppColors.cD676FF,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
