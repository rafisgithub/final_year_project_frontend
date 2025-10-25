import 'dart:io';
import 'package:final_year_project_frontend/features/language/presentation/language_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_year_project_frontend/features/onbording/presentation/onbording.dart';
import 'package:final_year_project_frontend/features/sign_In/presentation/forgot_password_screen.dart';

import 'package:final_year_project_frontend/features/sign_In/presentation/otp_verification_screen.dart';
import 'package:final_year_project_frontend/features/sign_In/presentation/password_update_success_screen.dart';
import 'package:final_year_project_frontend/features/sign_In/presentation/reset_password_screen.dart';
import 'package:final_year_project_frontend/features/sign_In/presentation/sign_in_screen.dart';


import 'package:final_year_project_frontend/features/sign_up/presentation/sign_up_screen.dart';



import 'package:final_year_project_frontend/navigation_screen.dart';
import '../loading.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();

  static Routes get instance => _routes;
  static const String loadingScreen = '/loading';
  static const String onbordingScreens = '/onbordingScreens';
  static const String languageScreen = '/languageScreen';
  static const String signinScreen = '/signInScreen';
  static const String otpVerificationScreen = '/otpVerificationScreen';
  static const String otpSuccessfullScreen = '/otpSuccessfullScreen';
  static const String forgotPasswordscreen = '/forgotPasswordscreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String passwordUpdateSuccessScreen = '/passwordUpdateSuccessScreen';
  static const String selectLanguage = '/selectLanguage';
  static const String signUpScreen = '/signUpScreen';
  static const String signUpWithWorkingArea = '/SignUpWithWorkingArea';
  static const String vehicleInfo = '/vehicleInfo';
  static const String driversLicense = '/DriversLicense';
  static const String vehicleRegistrationInspection = '/vehicleRegistrationInspection';
  static const String vehicleInsurance = '/vehicleInsurance';
  static const String diamondSticker = '/diamondSticker';
  static const String tLCLicense = '/tLCLicense';
  static const String documentsVerified = '/documentsVerified';
  static const String termsAndConditions = '/termsAndConditions';
  static const String privacyPolicy = '/privacyPolicy';
  static const String allDone = '/allDone';
  static const String rejectRequest = '/rejectRequest';
  static const String mainNavigationBar = '/mainNavigationBar';
  
 
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loadingScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const Loading(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const Loading());
      case Routes.onbordingScreens:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const OnbordingScreens(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const OnbordingScreens());
      case Routes.languageScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const LanguageScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const LanguageScreen());
      case Routes.signinScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const SignInScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const SignInScreen());
      case Routes.otpVerificationScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const OtpVerificationScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const OtpVerificationScreen());
      case Routes.forgotPasswordscreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const ForgotPasswordscreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const ForgotPasswordscreen());
      case Routes.resetPasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const ResetPasswordScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const ResetPasswordScreen());
      case Routes.passwordUpdateSuccessScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const PasswordUpdateSuccessScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const PasswordUpdateSuccessScreen());

      case Routes.signUpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const SignUpScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const SignUpScreen());

    
      case Routes.documentsVerified:

      case Routes.mainNavigationBar:
      final args = settings.arguments as Map? ?? {};
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget:  MainNavigationBar(pageNum: args['pageNum'],), settings: settings)
            : CupertinoPageRoute(builder: (context) =>  MainNavigationBar(pageNum: args['pageNum'],));

      // case Routes.uploadedStaffInfoScreen:
      //   final args = settings.arguments as Map? ?? {};
      //   // Use a default empty list if args["csvData"] is null
      //   final csvData = args["data"] as List<List<dynamic>>? ?? [];

      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(
      //           widget: UploadedStaffInfoScreen(data: csvData),
      //           settings: settings,
      //         )
      //       : CupertinoPageRoute(
      //           builder: (context) => UploadedStaffInfoScreen(data: csvData),
      //         );

      // case Routes.jobDetailTwoScreens:
      //       return Platform.isAndroid
      //           ? _FadedTransitionRoute(
      //               widget: const JobDetail(), settings: settings)
      //           : CupertinoPageRoute(builder: (context) => const StaffTypeScreen());

      // case Routes.fullTimeJobScreen:
      //   return Platform.isAndroid
      //       ? _FadedTransitionRoute(


      default:
        return null;
    }
  }
}
class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
      : super(
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
              child: child,
            );
          },
        );
}


class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
