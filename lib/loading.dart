import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:final_year_project_frontend/features/onbording/presentation/onbording.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/splash_screen.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
import 'package:final_year_project_frontend/navigation_screen.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  
  bool _isLoading = true;

  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  loadInitialData() async {
    await setInitValue();
    // bool data = appData.read(kKeyIsLoggedIn) ?? false;

    // bool data2 = appData.read(kKeyIsLoggedIn2) ?? false;
    // if (data) {
    //   String token = appData.read(kKeyAccessToken);
    //   DioSingleton.instance.update(token);
    // } else if (data2) {
    //   String token = appData.read(kKeyAccessToken2);
    //   DioSingleton.instance.update(token);
    // } else {
    //   // DioSingleton.instance.update("");

    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }else{
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //   NavigationService.navigateToReplacement(Routes.onbordingScreens);
    // });
    return const OnbordingScreens().animate()
  .fadeIn(duration: 500.ms) ;
    }
    // If client is logged in
    // else if ((appData.read(kKeyIsLoggedIn) == true && appData.read(kkeyUserType) == "client") ||
    //     (appData.read(kKeyIsLoggedIn2) == true && appData.read(kkeyUserType) == "client")) {
    //   return const MainNavigationBar(pageNum: 0);
    // }
    // // If staff is logged in and profile is done
    // // else if (appData.read(kKeyIsLoggedIn2) == true && appData.read(kkeystafprofiledone) == true) {
    // //   return const StaffNavigationScreen(pageNum: 0);
    // // }
    // // If staff is logged in and profile is done
    // else if ((appData.read(kKeyIsLoggedIn2) == true && appData.read(kkeyUserType) == "staff") ||
    //     (appData.read(kKeyIsLoggedIn) == true && appData.read(kkeyUserType) == "staff")) {
    //   return const StaffNavigationScreen(pageNum: 0);
    // }
    // // Otherwise, show onboarding
    // else {
    //   log("${appData.read(kKeyIsLoggedIn2)}  ${appData.read(kkeystafprofiledone)}");
    //   // if (appData.read(kKeyIsLoggedIn2) == true && appData.read(kkeystafprofiledone) == false) {
    //   //   return const StaffProfessionalProfileScreen();
    //   // }
    //   return const OnboardingScreen();
    // }
  }
}
