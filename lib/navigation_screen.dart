import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:final_year_project_frontend/features/home/presentation/home.dart';
import 'package:final_year_project_frontend/features/scanner/presentation/scanner_screen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

class MainNavigationBar extends StatefulWidget {
  final int pageNum;
  const MainNavigationBar({super.key, required this.pageNum});

  @override
  _MainNavigationBarState createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  late int currentTab;
  final List<Widget> screens = [
    HomeScreen(),
    ScannerScreen(),
    HomeScreen(), // Replace with ChatScreen when created

  ];

  @override
  void initState() {
    super.initState();
    currentTab = widget.pageNum;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: screens[currentTab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Container(
            decoration: BoxDecoration(
             
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
              
            ),
            child: GNav(
              rippleColor: AppColors.button.withOpacity(0.2),
              hoverColor: AppColors.button.withOpacity(0.1),
              haptic: true,
              tabBorderRadius: 16.r,
              
              curve: Curves.easeOutCubic,
              duration: const Duration(milliseconds: 400),
              gap: 10.w,
              color: Colors.grey[500],
              activeColor: Colors.white,
              iconSize: 26.sp,
              textStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              tabBackgroundColor: AppColors.button,
              tabBackgroundGradient: LinearGradient(
                colors: [
                  AppColors.button,
                  AppColors.c28B446,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              tabMargin: EdgeInsets.symmetric(horizontal: 4.w),
              selectedIndex: currentTab,
              onTabChange: (index) {
                setState(() {
                  currentTab = index;
                });
              },
              tabs: [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                  iconActiveColor: Colors.white,
                  iconColor: Colors.grey[500],
                ),
                GButton(
                  icon: Icons.camera_alt_rounded,
                  text: 'Scan',
                  iconActiveColor: Colors.white,
                  iconColor: Colors.grey[500],
                ),
                GButton(
                  icon: Icons.chat,
                  text: 'Chat',
                  iconActiveColor: Colors.white,
                  iconColor: Colors.grey[500],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
