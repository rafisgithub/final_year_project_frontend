import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.onChanged,
  });

  InputDecoration _decoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.c3D4040),
        borderRadius: BorderRadius.all(Radius.circular(100.r)),
      ),
      hintStyle: TextFontStyle.textStyle16c8993A4EurostileW400,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.r),
        borderSide: const BorderSide(color: AppColors.c3D4040, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: _decoration(),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.c3D4040),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: TextFontStyle.textStyle16c8993A4EurostileW400,
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
