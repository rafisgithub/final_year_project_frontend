import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:flutter/gestures.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_%20gradient_text.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_textfield.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/assets.gen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';

class PasswordUpdateSuccessScreen extends StatefulWidget {
  const PasswordUpdateSuccessScreen({super.key});

  @override
  State<PasswordUpdateSuccessScreen> createState() => _PasswordUpdateSuccessScreenState();
}

class _PasswordUpdateSuccessScreenState extends State<PasswordUpdateSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: AppColors.c050915),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
               Container(
                child: Column(
                  children: [
                    Image(image: AssetImage(Assets.images.succestickmark.path)),
                UIHelper.verticalSpace(40.h),
                Text(
                  "Password updated".tr,
                  style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                    fontSize: 24.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                GradientText(text: "successfully", gradient: LinearGradient(colors: [
                  AppColors.c8B3AFF,
                  AppColors.cD020FF,
                ]), style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                  fontSize: 24.sp,
                )),

                UIHelper.verticalSpace(8.h),
               Text(
                "Your password has been successfully updated. Please log in first",
                style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.c7E7E7E
                ),
                textAlign: TextAlign.center
               ),
               
                  ],
                ),
               ),
               Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 56.h,
                    width: double.infinity,
                    child: CustomsButton(
                      name: 'Login Now'.tr,
                      textStyle: TextFontStyle.textStyle18c231F20poppins700
                          .copyWith(fontSize: 15.sp),
                      callback: () {
                        NavigationService.navigateToWithArgs(
                          Routes.mainNavigationBar,
                           {
                            'pageNum': 0,
                          },
                        );
                      },
                    ),
                  ),
                ),
                UIHelper.verticalSpace(40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
