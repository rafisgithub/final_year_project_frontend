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
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: AppColors.button,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(icon: Icons.dashboard, text: 'Home'),
                GButton(icon: Icons.inventory_2, text: 'Products'),
                GButton(icon: Icons.shopping_bag, text: 'Orders'),
                GButton(icon: Icons.book, text: 'Due'),
                GButton(
                  icon: Icons.chat_bubble_outline,
                  text: 'Chat',
                  leading: _unreadMessageCount > 0
                      ? Stack(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: _selectedIndex == 4
                                  ? AppColors.button
                                  : Colors.black,
                              size: 24,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '$_unreadMessageCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
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
                  // Refresh unread count or reset if logic dictates;
                  // For now, re-fetching to keep sync or just simple navigation
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
