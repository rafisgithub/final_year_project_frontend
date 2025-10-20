// // ignore_for_file: library_private_types_in_public_api, must_be_immutable, unused_field

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import '../constants/text_font_style.dart';
// import '../gen/colors.gen.dart';
// import 'package:gradient_borders/gradient_borders.dart';

// class CustomTextForm extends StatefulWidget {
//   final String? labelText;
//   final String? hintText;
//   final Widget? prefixIcon;
//   bool? obscureText;
//   final TextEditingController? controller;
//   final TextInputType keyboardType;
//   final Function(String)? onChanged;
//   final Function()? onTap;
//   final String? Function(String?)? validator;
//   final bool isPrefixIcon;
//   final bool? isColor;
//   final double borderRadius;
//   final VoidCallback? onSuffixIconTap;
//   final String? iconpath;
//   final int maxline;
//   final bool readOnly;
//   final bool? enabled;
//   final bool? isBorder;
//   final Color? fillColor;
//   final String? prefixImage;
//   final FocusNode? currentFocus;
//   final FocusNode? nextFocus;
//   final TextInputAction? textInputAction;
//   final FocusNode? focusNode;
//   final bool isPasswordField;
//   final String? suffixIcon;

//   CustomTextForm({
//     super.key,
//     this.labelText,
//     this.hintText,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = true,
//     this.isPasswordField = false,
//     this.controller,
//     this.keyboardType = TextInputType.text,
//     this.onChanged,
//     this.validator,
//     this.borderRadius = 16,
//     required this.isPrefixIcon,
//     this.iconpath,
//     this.onSuffixIconTap,
//     this.readOnly = false,
//     this.maxline = 1,
//     this.isBorder = false,
//     this.fillColor,
//     this.prefixImage,
//     this.currentFocus,
//     this.nextFocus,
//     this.isColor,
//     this.enabled,
//     this.textInputAction,
//     this.focusNode, this.onTap,
//   });

//   @override
//   _CustomTextFormState createState() => _CustomTextFormState();
// }

// class _CustomTextFormState extends State<CustomTextForm> {
//   late FocusNode _focusNode;
//   bool isFocused = false;
//   bool isObscure = true;

//   @override
//   void initState() {
//     super.initState();
//     isObscure = widget.obscureText ?? true;

//     _focusNode = FocusNode();
//     _focusNode.addListener(() {
//       setState(() {
//         isFocused = _focusNode.hasFocus;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(1.0),
//       child: TextFormField(
//         onTap: widget.onTap,
//         cursorColor: AppColors.c091E42,
//         enabled: widget.enabled,
//         readOnly: widget.readOnly,
//         maxLines: widget.maxline,
//         focusNode: widget.focusNode,
//         controller: widget.controller,
//         keyboardType: widget.keyboardType,
//         cursorRadius: Radius.circular(5.r),
//         obscureText: widget.isPasswordField ? isObscure : false,
//         onChanged: widget.onChanged,
//         validator: widget.validator,
//         decoration: InputDecoration(
//           fillColor: Colors.transparent,
//           filled: true,

//           border: GradientOutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(16.r)),
//               gradient: const LinearGradient(colors: [
//                 Color(0xFFFFA865),
//                 Color(0xFFFF5E4F),
//                 Color(0xFFD676FF)
//               ]),
//               width: 1),
//           enabledBorder: GradientOutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(16.r)),
//               gradient: const LinearGradient(colors: [
//                 Color(0xFFFFA865),
//                 Color(0xFFFF5E4F),
//                 Color(0xFFD676FF)
//               ]),
//               width: 1),
//           focusedBorder: GradientOutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(16.r)),
//               gradient: const LinearGradient(colors: [
//                 Color(0xFFFFA865),
//                 Color(0xFFFF5E4F),
//                 Color(0xFFD676FF)
//               ]),
//               width: 1),

//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(widget.borderRadius),
//             borderSide: const BorderSide(color: Colors.red),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(widget.borderRadius),
//             borderSide: const BorderSide(color: Colors.red),
//           ),
//           labelText: widget.labelText,
//           hintText: widget.hintText,
//           contentPadding: EdgeInsets.symmetric(
//             vertical: 16.h,
//           ),
//           hintStyle: TextFontStyle.textStyle10c231F20poppins400.copyWith(
//             color: AppColors.c091E42.withOpacity(0.5),
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w500,
//           ),
//           prefixIcon: widget.isPrefixIcon && widget.prefixImage != null
//               ? Padding(
//                   padding: const EdgeInsets.all(14.0),
//                   child: SvgPicture.asset(
//                     widget.prefixImage ?? "",
//                     height: 20.h,
//                     width: 20.w,
//                     fit: BoxFit.contain,
//                   ),
//                 )
//               : null,

//           // ----------Password Visibility ----------
//           suffixIcon: widget.isPasswordField
//               ? IconButton(
//                   icon: Icon(
//                     isObscure ? Icons.visibility_off : Icons.visibility,
//                     color: AppColors.c091E42.withOpacity(0.5),
//                     size: 20.sp,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       isObscure = !isObscure;
//                     });
//                   },
//                 )
//               : null,

//           // -------- error text color -------------
//           errorStyle: TextStyle(
//             color: Colors.red,
//             fontSize: 12.sp,
//           ),
//         ),
//       ),
//     );
//   }
// }
