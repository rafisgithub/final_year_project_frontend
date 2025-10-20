import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/assets.gen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

class CustomCardWidget extends StatelessWidget {
  final String backgroundImagePath;
  final String title;
  final String location;
  final String amount;
  final String company;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const CustomCardWidget({
    Key? key,
    required this.backgroundImagePath,
    required this.title,
    required this.buttonText,
    required this.onButtonPressed,
    required this.location,
    required this.amount,
    required this.company,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xFF161C2D)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,

                    child: Image.asset(Assets.icons.raactiveAiicon.path),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
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

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 12.w,
                        children: [
                          Image.asset(Assets.icons.locationicon.path),
                          Text(
                            '$location',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF7E7E7E),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Image.asset(Assets.icons.manyicon.path),
                          Text(
                            '$amount',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF7E7E7E),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12.w,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 28.h,

                              child: CustomsButton(
                                name: 'Applied Sep 18',
                                callback: () {},
                                bgColor1: AppColors.c2F3956,
                                bgColor2: AppColors.c2F3956,
                                textStyle: TextFontStyle
                                    .textStyle12c7E7E7Epoppins400
                                    .copyWith(color: AppColors.cFFFFFF),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 28.h,

                              child: CustomsButton(
                                name: 'View job link',
                                callback: onButtonPressed,
                                textStyle: TextFontStyle
                                    .textStyle12c7E7E7Epoppins400
                                    .copyWith(color: AppColors.cFFFFFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 12.w,
                        children: [
                          Image.asset(Assets.icons.companyicon.path),
                          Text(
                            '$company',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF7E7E7E),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
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
