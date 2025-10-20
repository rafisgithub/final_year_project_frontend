import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_%20gradient_text.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/features/agents/widgets/custom_card_widget.dart';

import 'package:final_year_project_frontend/gen/assets.gen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/my_animation.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor:AppColors.c050915,
        title: GradientText(
          text: 'Agents',
          gradient: LinearGradient(
            colors: [AppColors.c8B3AFF, AppColors.cD020FF],
          ),
          style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
            fontSize: 24.sp,
          ),
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
                child: Row(
                  children: [
                    Text(
                      "Enroll your featured agent",
                      style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
              TransformableSliverList.builder(
                itemCount: 6,
                getTransformMatrix: TransformMatrices.fadeInOut,
                itemBuilder: (context, index) {
                  return CustomCardWidget(
                    backgroundImagePath:
                        Assets.images.cardbg1.path,
                    title: 'Job appiler agent ${index + 1}',
                    subtitle: ' A master of generating interactive app in seconds ${index + 1}.',
                    buttonText: 'Open',
                    onButtonPressed: () {
                      // Handle button press
                    },
                  );
                },
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}

class AppsColors {}
