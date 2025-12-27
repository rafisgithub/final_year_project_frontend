import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/dashboard/seller_dashboard_screen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/product/seller_products_screen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/order/seller_orders_screen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/due/due_list_screen.dart';
import 'package:final_year_project_frontend/features/chat/data/chat_service.dart';
import 'package:final_year_project_frontend/features/chat/presentation/chat_list_screen.dart';

class SellerNavigationScreen extends StatefulWidget {
  const SellerNavigationScreen({super.key});

  @override
  State<SellerNavigationScreen> createState() => _SellerNavigationScreenState();
}

class _SellerNavigationScreenState extends State<SellerNavigationScreen> {
  int _selectedIndex = 0;
  int _unreadMessageCount = 0;

  final List<Widget> _screens = [
    SellerDashboardScreen(),
    SellerProductsScreen(),
    SellerOrdersScreen(),
    DueListScreen(),
    ChatListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUnreadMessages();
  }

  Future<void> _loadUnreadMessages() async {
    final result = await ChatService.getUnreadMessageCount();
    if (mounted && result['success'] == true) {
      setState(() {
        _unreadMessageCount = result['data']['unread_count'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.05), // Softer shadow
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: GNav(
              rippleColor: AppColors.button.withOpacity(0.1),
              hoverColor: AppColors.button.withOpacity(0.1),
              gap: 8,
              activeColor: AppColors.button,
              iconSize: 22.sp,
              textStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.button,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              duration: const Duration(milliseconds: 300),
              tabBackgroundColor: AppColors.button.withOpacity(0.1),
              color: Colors.grey[500], // Inactive icon color
              tabs: [
                const GButton(icon: Icons.grid_view_rounded, text: 'Home'),
                const GButton(
                  icon: Icons.inventory_2_rounded,
                  text: 'Products',
                ),
                const GButton(icon: Icons.shopping_bag_rounded, text: 'Orders'),
                const GButton(icon: Icons.receipt_long_rounded, text: 'Due'),
                GButton(
                  icon: Icons.chat_bubble_rounded,
                  text: 'Chat',
                  leading: _unreadMessageCount > 0
                      ? Stack(
                          children: [
                            Icon(
                              Icons.chat_bubble_rounded,
                              color: _selectedIndex == 4
                                  ? AppColors.button
                                  : Colors.grey[500],
                              size: 22.sp,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 14.w,
                                  minHeight: 14.w,
                                ),
                                child: Text(
                                  '$_unreadMessageCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                if (index == 4) {
                  _loadUnreadMessages();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
