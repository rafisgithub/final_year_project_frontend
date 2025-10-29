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
import 'package:final_year_project_frontend/networks/dio/dio.dart';
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
      // DevicePreview(
      //   // enabled: !kReleaseMode,
      //   builder: (context) => const MyApp(), // Wrap your app
      // ),
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

    String countryCode = 'en_US';
     String language = appData.read(kKeyLanguage)??'bn_BD';
    // String countryCode = appData.read(kKeyCountryCode);
   var scrieensize = MediaQuery.sizeOf(context); 
    return ScreenUtilInit(
      //designSize: const Size(412, 892),
      designSize:  Size(scrieensize.width, scrieensize.height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) async {
            //  showMaterialDialog(context);
            },
            child: GetMaterialApp(
      //           //    showPerformanceOverlay: true,
      //            supportedLocales: L10n.all,
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
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
