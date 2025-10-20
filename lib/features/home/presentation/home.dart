import 'package:animated_item/animated_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_%20gradient_text.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_statusbar.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';

import 'package:final_year_project_frontend/common_widgets/simple_trip_card.dart';

import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/features/home/widgets/custom_card_widget.dart';
import 'package:final_year_project_frontend/gen/assets.gen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/my_animation.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isActive = true;
  String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    final top2 = MediaQueryData.fromView(View.of(context)).padding.top;
    final _scaleController = ScrollController();
    return Scaffold(
      body: Container(
        color: AppColors.c050915,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomScrollView(
            primary: true,
            clipBehavior: Clip.none,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(top: top2),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aura',
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 24.sp),
                      ),
                      GradientText(
                        text: 'Forge',
                        gradient: LinearGradient(
                          colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                        ),
                        style: TextFontStyle.textStyle18c231F20poppins700
                            .copyWith(fontSize: 24.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: UIHelper.verticalSpace(26.h)),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      "Your Ai agents",
                      style: TextFontStyle.textStyle18c231F20poppins700
                          .copyWith(fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
              
              TransformableSliverList.builder(
            itemCount: 20,
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
                            contentPadding: EdgeInsets.all(8.h),
                            leading: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.c8B3AFF,
                                    AppColors.cD020FF,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 20.r,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            
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
                            trailing: SizedBox(
                              height: 28.h,
                              width: 74.w,
                              child: CustomsButton(
                                name: 'open',
                                callback: () {},
                              ),
                            ),
                          ),
                        ),
                      )
                     
                      .animate()
                      .slideX(
                        begin: -1.0,
                        end: 0.0,
                        curve: Curves.easeInOut,
                      )
                      .fadeIn(duration: 300.ms,)
                      ;
            },
          ),
              

              SliverToBoxAdapter(child: UIHelper.verticalSpace(26.h)),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      "Engrave the advance agent",
                      style: TextFontStyle.textStyle18c231F20poppins700
                          .copyWith(fontSize: 18.sp),
                    ),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    controller: _scaleController,
                    itemBuilder: (context, index) {
                      return AnimatedItem(
                        controller: _scaleController,
                    index: index,
                    
                        child: CustomCardWidget(
                          title: 'Advanced Agent ${index + 1}',
                          subtitle:
                              'Create and manage advanced AI agents with enhanced capabilities.',
                          buttonText: 'Create',
                          onButtonPressed: () {
                            // Handle button press
                          },
                          backgroundImagePath: Assets.images.cardbg1.path,
                        ),
                      );
                    },
                    itemCount: 10,
                    separatorBuilder: (BuildContext context, int index) {
                      return UIHelper.horizontalSpace(20.w);
                    },
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
