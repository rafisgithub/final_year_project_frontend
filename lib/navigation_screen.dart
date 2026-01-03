import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:final_year_project_frontend/features/home/presentation/home.dart';
import 'package:final_year_project_frontend/features/scanner/presentation/scanner_screen.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/features/chat/presentation/chat_list_screen.dart';
import 'package:final_year_project_frontend/features/chat/data/chat_service.dart';

class MainNavigationBar extends StatefulWidget {
  final int pageNum;
  const MainNavigationBar({super.key, required this.pageNum});

  @override
  _MainNavigationBarState createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  late int currentTab;
  int _unreadMessageCount = 0;

  final List<Widget> screens = [
    HomeScreen(),
    ScannerScreen(),
    ChatListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    currentTab = widget.pageNum;
    _loadUnreadMessages();
  }

  Future<void> _loadUnreadMessages() async {
    try {
      final result = await ChatService.getUnreadMessageCount();
      if (mounted && result['success'] == true) {
        setState(() {
          _unreadMessageCount = result['data']['unread_count'] ?? 0;
        });
      }
    } catch (e) {
      debugPrint('Error loading unread messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
        if (shouldPop ?? false) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: screens[currentTab]),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r),
              topRight: Radius.circular(25.r),
            ),
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
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
                    colors: [AppColors.button, AppColors.c28B446],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 14.h,
                  ),
                  tabMargin: EdgeInsets.symmetric(horizontal: 4.w),
                  selectedIndex: currentTab,
                  onTabChange: (index) {
                    setState(() {
                      currentTab = index;
                    });
                    // Refresh count if switching to tabs other than Chat,
                    // or maybe just refresh periodically.
                    // For now, let's refresh when tab changes.
                    _loadUnreadMessages();
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
                      leading: _unreadMessageCount > 0
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: currentTab == 2
                                      ? Colors.white
                                      : Colors.grey[500],
                                  size: 26.sp,
                                ),
                                Positioned(
                                  top: -8,
                                  right: -8,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      '$_unreadMessageCount',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : null,
                      text: 'Chat',
                      iconActiveColor: Colors.white,
                      iconColor: Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
