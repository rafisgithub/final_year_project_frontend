// // ignore_for_file: deprecated_member_use, must_be_immutable, library_private_types_in_public_api
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:final_year_project_frontend/constants/text_font_style.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';
// import 'package:final_year_project_frontend/helpers/ui_helpers.dart';

// class CustomGreyTextFormField extends StatefulWidget {
//   final bool isPasswordField;
//   final String hintText;
//   final String? prefixIcon;
//   final String? suffixIcon;
//   final Color? borderColor;
//   final Color? backgroundColor;
//   final Color? iconColor;
//   final Color? fillColor;
//   final Color? hintTextColor;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   String? Function(String?)? validator;
//   bool? readOnly;

//   CustomGreyTextFormField(
//       {super.key,
//       this.isPasswordField = false,
//       this.hintText = 'Enter text',
//       this.prefixIcon,
//       this.suffixIcon,
//       this.borderColor,
//       this.backgroundColor = Colors.white,
//       this.iconColor = Colors.black,
//       this.hintTextColor = Colors.grey,
//       this.controller,
//       this.keyboardType,
//       this.validator,
//       this.readOnly = false, this.fillColor,  });

//   @override
//   _CustomGreyTextFormFieldState createState() =>
//       _CustomGreyTextFormFieldState();
// }

// class _CustomGreyTextFormFieldState extends State<CustomGreyTextFormField> {
//   bool _obscureText = false;

//   @override
//   void initState() {
//     super.initState();
//     _obscureText = widget.isPasswordField;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 16.w,
//       ),
//       height: 56.h,
//       alignment: Alignment.centerLeft,
//       decoration: BoxDecoration(
//         color: widget.backgroundColor,
//         border: Border.all(color: AppColors.cA5A5A5),
//         // gradient: LinearGradient(
//         //   colors: [
//         //     const Color(0xFFFFA865).withOpacity(0.2),
//         //     const Color(0xFFFF5E4F).withOpacity(0.2),
//         //     const Color(0xFFD676FF).withOpacity(0.2),
//         //   ],
//         //   begin: Alignment.topLeft,
//         //   end: Alignment.bottomRight,
//         // ),
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Prefix Icon with consistent size
//           if (widget.prefixIcon != null)
//             SvgPicture.asset(
//               widget.prefixIcon!,
//               height: 24.h,
//               width: 24.w,
//               // color: widget.iconColor,
//             ),
//           // Text field area
//           UIHelper.horizontalSpace(10.h),
//           Expanded(
//             child: TextFormField(

//               textAlign: TextAlign.start,
//               readOnly: widget.readOnly!,
//               controller: widget.controller,
//               keyboardType: widget.keyboardType,
//               cursorColor: AppColors.c091E42,
//               obscureText: _obscureText,
//               validator: widget.validator,
//               decoration: InputDecoration(
//                 // filled: true,
//                 // fillColor: widget.fillColor ,
//                 hintText: widget.hintText,
//                 hintStyle: TextFontStyle.textStyle10c231F20poppins400.copyWith(
//                   color: widget.hintTextColor,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           // Password toggle icon
//           if (widget.isPasswordField)
//             IconButton(
//               icon: Icon(
//                 _obscureText ? Icons.visibility_off : Icons.visibility,
//                 color: widget.iconColor,
//                 size: 22.sp,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _obscureText = !_obscureText;
//                 });
//               },
//             ),
//           if (widget.suffixIcon != null)
//             SvgPicture.asset(
//               widget.suffixIcon!,
//               height: 24.h,
//               width: 24.w,
//               fit: BoxFit.contain,
//               // color: widget.iconColor,
//             ),
//         ],
//       ),
//     );
//   }
// }
