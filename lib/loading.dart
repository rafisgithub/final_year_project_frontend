import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:final_year_project_frontend/features/language/presentation/language_screen.dart';
import 'package:final_year_project_frontend/helpers/di.dart';
import 'package:final_year_project_frontend/navigation_screen.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:final_year_project_frontend/splash_screen.dart';
import 'helpers/helper_methods.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  
  bool _isLoading = true;
  bool _videoComplete = false;

  @override
  void initState() {
    loadInitialData();
    super.initState();
  }

  Future<void> loadInitialData() async {
    await setInitValue();
    
    // Restore access token if user is logged in
    bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
    if (isLoggedIn) {
      String? token = appData.read(kKeyAccessToken);
      if (token != null && token.isNotEmpty) {
        DioSingleton.instance.update(token);
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }
  
  void _onVideoComplete() {
    setState(() {
      _videoComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen with video until both loading is done AND video completes
    if (_isLoading || !_videoComplete) {
      return SplashScreen(onVideoComplete: _onVideoComplete);
    }else{
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //   NavigationService.navigateToReplacement(Routes.onbordingScreens);
    // });
      final isLoggedIn = appData.read(kKeyIsLoggedIn);
    if (isLoggedIn == true) {
      return const MainNavigationBar(pageNum: 0);

    }
    return const LanguageScreen().animate()
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
