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
    Key? key,
    required this.backgroundImagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
                    color: Color(0xFF161C2D),
                   
                  ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Image(image: AssetImage(backgroundImagePath), fit: BoxFit.cover,)),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                 
                  decoration: BoxDecoration(
                    color: Color(0xFF161C2D),
                    borderRadius: BorderRadius.circular(0.r),
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
                        width: 74.w,
                        child: CustomsButton(name: 'open', callback: onButtonPressed),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
