import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_%20gradient_text.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/features/job_List/widgets/custom_card_widget.dart';


import 'package:final_year_project_frontend/gen/assets.gen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/my_animation.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class ProfileSetingScreen extends StatefulWidget {
  const ProfileSetingScreen({super.key});

  @override
  State<ProfileSetingScreen> createState() => _ProfileSetingScreenState();
}

class _ProfileSetingScreenState extends State<ProfileSetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor:AppColors.c050915,
        title: Row(
          children: [
            Text(
              'Profile & ',
              style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                fontSize: 24.sp,
                color: AppColors.cFFFFFF,
              ),
            ),
            GradientText(
              text: 'Settings',
              gradient: LinearGradient(
                colors: [AppColors.c8B3AFF, AppColors.cD020FF],
              ),
              style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                fontSize: 24.sp,
              ),
            ),
            
          ],
        ),
        
      ),
      body: Container(
        color: AppColors.c050915,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomScrollView(
            primary: true,
            clipBehavior: Clip.none,
            slivers: [
              SliverToBoxAdapter(
                child:  Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                  ),
                ),
                child:Container(
                  padding: EdgeInsets.all(8.w),
                  width: double.infinity,
                   decoration: BoxDecoration(
                    color:AppColors.c050915,
                  ),
                  child: Row(
                    spacing: 12.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor:AppColors.c7E7E7E ,
                        radius: 30.r,
                        backgroundImage: AssetImage(Assets.images.maskot.path),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        
                        children: [
                          Text(
                            'Wade warren',
                            style: TextFontStyle.textStyle12c7E7E7Epoppins400.copyWith(
                              fontSize: 20.sp,
                              color: AppColors.cFFFFFF,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            'wadewarren29@gmail.com',
                            style: TextFontStyle.textStyle12c7E7E7Epoppins400.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.cFFFFFF,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                )
              ),
            
              ),
              SliverToBoxAdapter(child: UIHelper.verticalSpace(26.h)),
              TransformableSliverList.builder(
                itemCount: 5,
                getTransformMatrix: TransformMatrices.fadeInOut,
                itemBuilder: (context, index) {
                  return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.c161C2D,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(20.h),
                            title: Text(
                              "Agent Name",
                              style: TextFontStyle
                                  .textStyle18c231F20poppins700
                                  .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            subtitle: Text(
                              "Last run 6 min ago",
                              style: TextFontStyle
                                  .textStyle12c7E7E7Epoppins400,
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,color: AppColors.cFFFFFF,size: 16.sp,),
                          ),
                        ),
                      )
                     ;
                },
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}

