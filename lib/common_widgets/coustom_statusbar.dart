import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

class CoustomStatusbar extends StatefulWidget {
  const CoustomStatusbar({super.key});

  @override
  State<CoustomStatusbar> createState() => _CoustomStatusbarState();
}

class _CoustomStatusbarState extends State<CoustomStatusbar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 0,
      color:AppColors.c06EC4B1A,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: ListTile(),
      ),
          // 🟢 Title and subtitle come from outsid e
    );
  }
}