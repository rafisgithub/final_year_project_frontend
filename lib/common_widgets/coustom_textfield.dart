import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';


final sharedDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.transparent,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.cF2F0F0, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.r)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.cF2F0F0, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.r)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: BorderSide(color: AppColors.cF2F0F0, width: 1.0),
  ),
  hintStyle: TextFontStyle.textStyle16c8993A4EurostileW400,
);

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Color textColor;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.textColor = Colors.black,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscurePassword = false;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscurePassword,
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: widget.textColor,
        // 👇 Add spacing only when text is actually entered
        letterSpacing: (widget.obscureText && (widget.controller?.text.isNotEmpty ?? false))
            ? 3.0
            : 0.0,
      ),
      onChanged: (_) => setState(() {}), // rebuild when text changes
      decoration: sharedDecoration.copyWith(
        hintText: widget.hintText,
        alignLabelWithHint: true,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.c8993A4,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
    );
  }
}
