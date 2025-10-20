import 'package:final_year_project_frontend/provider/auth_provider.dart';
import 'package:final_year_project_frontend/provider/dashboard_provider.dart';
import 'package:final_year_project_frontend/provider/experience_provider.dart';
import 'package:final_year_project_frontend/provider/main_page_view_provider.dart';
import 'package:final_year_project_frontend/provider/review_provider.dart';
import 'package:final_year_project_frontend/provider/staff_page_view_provider.dart';

import 'package:provider/provider.dart';

import '../provider/provides.dart';

var providers = [
  //New
  ChangeNotifierProvider<ExperienceProvider>(
    create: ((context) => ExperienceProvider()),
  ),

  ChangeNotifierProvider<AuthProvider>(
    create: ((context) => AuthProvider()),
  ),
  ChangeNotifierProvider<DashboardProvider>(
    create: ((context) => DashboardProvider()),
  ),
  // Old

  ChangeNotifierProvider<ItemOptionIndex>(
    create: ((context) => ItemOptionIndex()),
  ),
  // ChangeNotifierProvider<DateTimeProvider>(
  //   create: ((context) => DateTimeProvider()),
  // ),
  ChangeNotifierProvider<VoucherProvider>(
    create: ((context) => VoucherProvider()),
  ),
  ChangeNotifierProvider<ReviewProvider>(
    create: ((context) => ReviewProvider()),
  ),

  ChangeNotifierProvider<PlcaeMarkAddress>(
    create: ((context) => PlcaeMarkAddress()),
  ),
  ChangeNotifierProvider<GenericBool>(
    create: ((context) => GenericBool()),
  ),
  ChangeNotifierProvider<SelectedSubCat>(
    create: ((context) => SelectedSubCat()),
  ),
  ChangeNotifierProvider<GenericProvider>(
    create: ((context) => GenericProvider()),
  ),
  ChangeNotifierProvider<CartCounter>(
    create: ((context) => CartCounter()),
  ),

  ChangeNotifierProvider<StaffPageViewProvider>(
    create: ((context) => StaffPageViewProvider()),
  ),
  ChangeNotifierProvider<MainPageViewProvider>(
    create: ((context) => MainPageViewProvider()),
  ),
];
