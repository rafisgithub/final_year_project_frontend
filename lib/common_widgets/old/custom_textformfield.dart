// // ignore_for_file: deprecated_member_use, must_be_immutable, library_private_types_in_public_api
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:final_year_project_frontend/common_widgets/custom_border_painter.dart';
// import 'package:final_year_project_frontend/constants/text_font_style.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';
// import 'package:final_year_project_frontend/helpers/ui_helpers.dart';

// class CustomTextFormField extends StatefulWidget {
//   final bool isPasswordField;
//   final String? suffixIcon;
//   final String hintText;
//   final String? prefixIcon;

//   final Color? borderColor;
//   final Color? backgroundColor;
//   final Color? iconColor;
//   final Color? hintTextColor;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   String? Function(String?)? validator;
//   bool? readOnly;

//   CustomTextFormField(
//       {super.key,
//       this.isPasswordField = false,
//       this.hintText = 'Enter text',
//       this.prefixIcon,
//       this.suffixIcon,
//       this.borderColor = Colors.grey,
//       this.backgroundColor = Colors.white,
//       this.iconColor = Colors.black,
//       this.hintTextColor = Colors.grey,
//       this.controller,
//       this.keyboardType,
//       this.validator,
//       this.readOnly = false});

//   @override
//   _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
// }

// class _CustomTextFormFieldState extends State<CustomTextFormField> {
//   bool _obscureText = false;

//   @override
//   void initState() {
//     super.initState();
//     _obscureText = widget.isPasswordField;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(1.0),
//       child: CustomPaint(
//         painter: CustomBorderPainter(),
//         child: Container(
//           height: 56.h,
//           padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.8.h),
//           alignment: Alignment.centerLeft,
//           decoration: BoxDecoration(
//             color: widget.backgroundColor,
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0xFFFFA865).withOpacity(0.1),
//                 const Color(0xFFFF5E4F).withOpacity(0.1),
//                 const Color(0xFFD676FF).withOpacity(0.1),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Prefix Icon with consistent size
//               if (widget.prefixIcon != null)
//                 SvgPicture.asset(
//                   widget.prefixIcon!,
//                   height: 24.h,
//                   width: 24.w,
//                   // color: widget.iconColor,
//                 ),
//               // Text field area
//               UIHelper.horizontalSpace(10.h),
//               Expanded(
//                 child: TextFormField(
//                   textAlign: TextAlign.start,
//                   cursorRadius: const Radius.circular(5.0),
//                   readOnly: widget.readOnly!,
//                   controller: widget.controller,
//                   keyboardType: widget.keyboardType,
//                   cursorColor: AppColors.c091E42,
//                   obscureText: _obscureText,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an email address'; // Check if empty
//                     }
//                     // Regular expression for basic email validation
//                     const emailPattern =
//                         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
//                     final emailRegExp = RegExp(emailPattern);

//                     if (!emailRegExp.hasMatch(value)) {
//                       return 'Please enter a valid email address'; // If email format is incorrect
//                     }

//                     return null; // If valid email
//                   },
//                   decoration: InputDecoration(
//                     //contentPadding: EdgeInsets.only(bottom: 12.h),
//                     hintText: widget.hintText,
//                     hintStyle:
//                         TextFontStyle.textStyle10c231F20poppins400.copyWith(
//                       color: widget.hintTextColor,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     border: InputBorder.none,
//                     enabledBorder: InputBorder.none,
//                     errorBorder: InputBorder.none,
//                     focusedBorder: InputBorder.none,
//                     disabledBorder: InputBorder.none,
//                     focusedErrorBorder: InputBorder.none,
//                   ),
//                 ),
//               ),

//               if (widget.suffixIcon != null)
//                 SvgPicture.asset(
//                   widget.suffixIcon!,
//                   height: 24.h,
//                   width: 24.w,
//                   fit: BoxFit.contain,
//                   // color: widget.iconColor,
//                 ),

//               // Password toggle icon
//               if (widget.isPasswordField)
//                 ShaderMask(
//                   shaderCallback: (bounds) {
//                     return const LinearGradient(
//                       colors: [
//                         Color(0xFFFFA865),
//                         Color(0xFFFF5E4F),
//                         Color(0xFFD676FF),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ).createShader(bounds);
//                   },
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: Icon(
//                       _obscureText ? Icons.visibility_off : Icons.visibility,
//                       color: widget.iconColor,
//                       size: 20.sp,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureText = !_obscureText;
//                       });
//                     },
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
