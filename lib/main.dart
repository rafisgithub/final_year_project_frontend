// ignore_for_file: deprecated_member_use
import 'package:auto_animated/auto_animated.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/helpers/di.dart';
import 'package:final_year_project_frontend/helpers/language.dart';
import 'package:final_year_project_frontend/helpers/register_provider.dart';
import 'package:final_year_project_frontend/loading.dart';
import 'package:provider/provider.dart';
import 'helpers/helper_methods.dart';
import 'helpers/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await _requestPermissions();
  await GetStorage.init();
  diSetup();
  // initiInternetChecker();

  DioSingleton.instance.create();

  runApp(
    const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    setInitValue();
    return MultiProvider(
      providers: providers,
      child: AnimateIfVisibleWrapper(
        showItemInterval: const Duration(milliseconds: 150),
        child: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
           // showMaterialDialog(context);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return const UtillScreenMobile();
            },
          ),
        ),
      ),
    );
  }
}

class UtillScreenMobile extends StatelessWidget {
  const UtillScreenMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
      //String language = 'ru_RU';
      //String language = 'en_US';

     String language = appData.read(kKeyLanguage)??'bn_BD';
   var screenSize = MediaQuery.sizeOf(context);
    return ScreenUtilInit(
      designSize:  Size(screenSize.width, screenSize.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) async {
            //  showMaterialDialog(context);
            },
            child: GetMaterialApp(

                useInheritedMediaQuery: true,
                locale: Locale(language),
                translations: LocalString(),
                theme: ThemeData(
                    unselectedWidgetColor: Colors.white,
                    useMaterial3: false,
                    scaffoldBackgroundColor: AppColors.cFFFFFF,
                    appBarTheme: const AppBarTheme(
                        color: AppColors.cFFFFFF, elevation: 0)),
                debugShowCheckedModeBanner: false,
                builder: (context, widget) {
                  return MediaQuery(
                      data: MediaQuery.of(context), child: widget!);
                },
                navigatorKey: NavigationService.navigatorKey,
                onGenerateRoute: RouteGenerator.generateRoute,
                home: const Loading()));
      },
    );
  }
}
