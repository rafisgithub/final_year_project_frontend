import 'package:animated_item/animated_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_%20gradient_text.dart';
import 'package:final_year_project_frontend/common_widgets/coustom_statusbar.dart';
import 'package:final_year_project_frontend/common_widgets/customs_button.dart';
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
            slivers: [],
          ),
        ),
      ),
    );
  }
}
