import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/ui_helpers.dart';

class OnbordingWidget extends StatefulWidget {
  final PageController? pageController;
  final String? onboardingimage;
  final Text? onboardingtitle;
  final Text? onboardingtext;

  const OnbordingWidget({
    super.key,
    this.pageController,
    this.onboardingimage,
    this.onboardingtitle,
    this.onboardingtext,
  });

  @override
  State<OnbordingWidget> createState() => _OnbordingWidgetState();
}

class _OnbordingWidgetState extends State<OnbordingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UIHelper.verticalSpace(71.h),
        Image(image: AssetImage(widget.onboardingimage ?? '')),
        UIHelper.verticalSpace(40.h),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothPageIndicator(
            controller: widget.pageController!,
            count: 3,
            effect: WormEffect(
              dotColor: AppColors.c73010B,
              strokeWidth: 2,
              spacing: 15.w,
              dotHeight: 10.h,
              dotWidth: 10.w,
              paintStyle: PaintingStyle.stroke,
              activeDotColor: AppColors.c73010B,
            ),
          ),
        ),
        UIHelper.verticalSpace(40.h),
        widget.onboardingtitle ?? Text(''),
        UIHelper.verticalSpace(16.h),
        widget.onboardingtext ?? Text(''),
      ],
    );
  }
}
