import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

class CustomCardWidget extends StatelessWidget {
  final String backgroundImagePath;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const CustomCardWidget({
    super.key,
    required this.backgroundImagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        height: 300.h,
        width: 224.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: SizedBox()),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF161C2D),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.h,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF7E7E7E),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      
                      SizedBox(
                        height: 28.h,
                        child: CustomsButton(name: 'open', callback: () {}),
                      ),
                    ],
                  ),
                ),
              ),
            
            ),
          ],
        ),
      ),
    );
  }
}
