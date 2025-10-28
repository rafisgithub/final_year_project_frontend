import 'package:flutter/material.dart';

import 'package:final_year_project_frontend/gen/colors.gen.dart';


class OnBoardingScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: AppColors.cFFFFFF),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
