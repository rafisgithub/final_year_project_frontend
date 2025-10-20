// // ignore_for_file: unnecessary_null_comparison
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:final_year_project_frontend/constants/text_font_style.dart';
// import 'package:final_year_project_frontend/gen/colors.gen.dart';
// import 'package:final_year_project_frontend/helpers/ui_helpers.dart';
// import 'package:country_picker/country_picker.dart';

// class CustomCountryPicker extends StatefulWidget {
//   final String labelText;
//   final String hintText;
//   final bool showSuffixIcon;
//   final String? suffixIcon;
//   final VoidCallback onButtonPressed;
//   // Callback when button is pressed
//   final bool isDatePicker;
// // 
//   const CustomCountryPicker({
//     super.key,
//     required this.labelText,
//     required this.hintText,
//     this.suffixIcon,
//     this.showSuffixIcon = true,
//     required this.onButtonPressed, // Callback
//     required this.isDatePicker,
//   });

//   @override
//   State<CustomCountryPicker> createState() => _CustomCountryPickerState();
// }

// class _CustomCountryPickerState extends State<CustomCountryPicker> {
//   bool isIconVisible = false; // To manage dynamic icon display
//   bool isDateSelected = false;

//   @override
//   void initState() {
//     super.initState();
//     // context.read<AuthProvider>().displayedHintText2 = widget.hintText;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.labelText,
//           style:
//               TextFontStyle.textStyle16c231F20GothamRoundedMedium500.copyWith(
//             color: AppColors.c091E42,
//             fontSize: 14.sp,
//           ),
//         ),
//         UIHelper.verticalSpace(12.h),
//         ElevatedButton(
//           onPressed: () async {
//             showCountryPicker(
//                 context: context,
//                 showPhoneCode:
//                     true, // optional. Shows phone code next to the country name.
//                 onSelect: ( country) {
//                   setState(() {
//                     // context.read<AuthProvider>().selectedCountry =
//                     //     '${country.name}';
//                   });
//                 },
//               );
//             if (widget.onButtonPressed != null) {
//               widget.onButtonPressed(); // Trigger the callback if provided
//             }
//             setState(() {
//               isIconVisible =
//                   !isIconVisible; // Toggle the icon state (optional)
//             });
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent, // Transparent background
//             padding: EdgeInsets.all(15.sp), // Padding of 14 pixels on all sides
//             elevation: 0,
//             shadowColor: Colors.transparent, // Remove shadow if desired
//             shape: RoundedRectangleBorder(
//               borderRadius:
//                   BorderRadius.circular(4.r), // Optional rounded corners
//               side: BorderSide(
//                 width: 1.sp,
//                 color: AppColors.c3689FD, // Border color
//               ),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Expanded(
//               //   child: Text(
//               //     widget.isDatePicker
//               //         ? context.read<AuthProvider>().displayedHintText2
//               //         : context
//               //             .read<AuthProvider>()
//               //             .selectedCountry
//               //             .toLowerCase(),
//               //     style: TextFontStyle.textStyle14c252C2EOpenSansW400.copyWith(
//               //       color: AppColors.c4B586B, // Text color
//               //       fontSize: 14.sp,
//               //     ),
//               //     textAlign: TextAlign.left,
//               //     overflow: TextOverflow.ellipsis, // In case text overflows
//               //   ),
//               // ),
//               SizedBox(
//                   height: 24.h,
//                   width: 24.w,
//                   child: SvgPicture.asset(
//                     widget.suffixIcon!,
//                   )),
//             ],
//           ),
//         ),
//       ],
//     );
//   }


// }

