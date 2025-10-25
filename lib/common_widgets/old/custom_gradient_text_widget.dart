// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:final_year_project_frontend/constants/text_font_style.dart';

// class CustomGradientTextWidget extends StatelessWidget {
//   final String text;
//   final double? fontSize;
//   TextDecoration? decoration;
//   FontWeight? fontWeight;

//   // ignore: use_key_in_widget_constructors
//   CustomGradientTextWidget(
//       {required this.text,
//       required this.fontSize,
//       required this.fontWeight,
//       this.decoration}) {
//     text;
//     fontSize;
//     decoration;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (bounds) => const LinearGradient(
//         colors: [Color(0xFFFFA865), Color(0xFFFF5E4F), Color(0xFFD676FF)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
//       child: Text(
//         text,
//         style: TextFontStyle.textStyle24c231F20GothamRoundedMedium500.copyWith(
//             color: Colors
//                 .white, // The color must be set to white for the gradient to appear.
//             fontSize: fontSize,
//             fontWeight: fontWeight,
//             decoration: decoration,
//             decorationThickness: 2.0),
//       ),
//     );
//   }
// }
