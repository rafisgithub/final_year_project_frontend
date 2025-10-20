import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/features/agents/presentation/agents_screen.dart';
import 'package:final_year_project_frontend/features/home/presentation/home.dart';
import 'package:final_year_project_frontend/features/job_List/presentation/job_list_screen.dart';
import 'package:final_year_project_frontend/features/messageing/chating_screen.dart';
import 'package:final_year_project_frontend/features/profile_settings/presentation/profile_seting_screen.dart';
import 'package:final_year_project_frontend/gen/assets.gen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/provider/main_page_view_provider.dart';
import 'package:provider/provider.dart';

class MainNavigationBar extends StatefulWidget {
  final int pageNum;
  const MainNavigationBar({Key? key, required this.pageNum}) : super(key: key);

  @override
  _MainNavigationBarState createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  late int currentTab;
  final List<Widget> screens = [
    HomeScreen(),
    AgentsScreen(),
    JobListScreen(),
    MyChatPage(),
  ];

  @override
  void initState() {
    super.initState();
    currentTab = widget.pageNum;
    final pageViewProvider = Provider.of<MainPageViewProvider>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c050915,
      resizeToAvoidBottomInset: true,
      body: screens[currentTab],
      bottomNavigationBar: Container(
        color: AppColors.c050915, // Background color for the nav bar
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: SafeArea(
          child: GNav(
            rippleColor:
                Colors.grey[800]!, // Tab button ripple color when pressed
            hoverColor: Colors.grey[700]!, // Tab button hover color
            haptic: true, // Haptic feedback
            tabBorderRadius: 100.r, // Rounded corners for tabs
            duration: const Duration(
              milliseconds: 900,
            ), // Tab animation duration
            gap: 8.w, // Gap between icon and text
            color: Colors.white.withOpacity(0.7), // Unselected icon/text color
            activeColor: Colors.white, // Selected icon/text color
            iconSize: 24.w, // Icon size
                
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ), // Tab padding
            // Fallback background color
            onTabChange: (index) {
              setState(() {
                currentTab = index;
              });
            },
            tabs: [
              GButton(
                icon: Icons.home, // Replace with your asset icon
                leading: CircleAvatar(
                  backgroundColor: currentTab == 0
                      ? Colors.transparent
                      : AppColors.c1F1538,
                  child: Image(
                    image: AssetImage(Assets.icons.homeicon.path),
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                text: 'Home',
                backgroundGradient: LinearGradient(
                  colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                ),
              ),
              GButton(
                borderRadius: BorderRadius.circular(100.r),
                icon: Icons.person, // Replace with your asset icon
                leading: CircleAvatar(
                  backgroundColor: currentTab == 1
                      ? Colors.transparent
                      : AppColors.c1F1538,
                  child: Image(
                    image: AssetImage(Assets.icons.agentsicon.path),
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                text: 'Agent',
                backgroundGradient: LinearGradient(
                  colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                ),
              ),
              GButton(
                icon: Icons.list, // Replace with your asset icon
                leading: CircleAvatar(
                  backgroundColor: currentTab == 2
                      ? Colors.transparent
                      : AppColors.c1F1538,
                  child: Image(
                    image: AssetImage(Assets.icons.listicon.path),
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                text: 'Job list',
                backgroundGradient: LinearGradient(
                  colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                ),
              ),
              GButton(
                icon: Icons.person_outline, // Replace with your asset icon
                leading: CircleAvatar(
                  backgroundColor: currentTab == 3
                      ? Colors.transparent
                      : AppColors.c1F1538,
                  child: Image(
                    image: AssetImage(Assets.icons.profileicon.path),
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
                text: 'Profile',
                backgroundGradient: LinearGradient(
                  colors: [AppColors.c8B3AFF, AppColors.cD020FF],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
