import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/order/seller_order_details_screen.dart';
import 'package:final_year_project_frontend/networks/order_service.dart';
import 'package:final_year_project_frontend/networks/product_service.dart';
import 'package:intl/intl.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  bool _isLoading = true;
  List<dynamic> _recentOrders = [];
  Map<String, dynamic> _stats = {
    'total_products': 0,
    'pending_orders': 0,
    'total_sales': 0.0,
    'total_dues': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      // 1. Fetch Orders to calculate stats and get recent list
      final orderResult = await OrderService.getSellerOrders(status: 'all');

      // 2. Fetch Products to get count
      final productResult = await ProductService.getSellerProducts();

      if (mounted) {
        setState(() {
          // Process Orders
          if (orderResult['success']) {
            final List<dynamic> orders = orderResult['data'] ?? [];
            _recentOrders = orders.take(5).toList(); // Top 5 recent

            // Calculate Stats
            int pendingCount = 0;
            double totalSales = 0;

            for (var order in orders) {
              if (order['status'] == 'pending') {
                pendingCount++;
              }
              if (order['status'] == 'delivered') {
                totalSales +=
                    double.tryParse(order['total_amount'].toString()) ?? 0;
              }
            }

            _stats['pending_orders'] = pendingCount;
            _stats['total_sales'] = totalSales;
          }

          // Process Products
          if (productResult['success']) {
            final List<dynamic> products = productResult['data'] ?? [];
            _stats['total_products'] = products.length;
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('Error loading dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Match customer screen background
      appBar: AppBar(
        title: Text(
          'Seller Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: AppColors.button,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.button))
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              color: AppColors.button,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // ... Stats Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          'Total Products',
                          '${_stats['total_products']}',
                          Icons.inventory_2_outlined,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Pending Orders',
                          '${_stats['pending_orders']}',
                          Icons.pending_actions_outlined,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Total Sales',
                          '৳ ${_stats['total_sales'].toStringAsFixed(0)}',
                          Icons.attach_money,
                          AppColors.button,
                        ),
                        _buildStatCard(
                          'Total Dues',
                          '৳ 0', // Placeholder as API doesn't provide this yet
                          Icons.account_balance_wallet_outlined,
                          Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Orders',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // ... List View
                    _recentOrders.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Text(
                                'No orders yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _recentOrders.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 16.h),
                            itemBuilder: (context, index) {
                              final order = _recentOrders[index];
                              final status = order['status'] ?? 'pending';
                              final orderDate = DateTime.parse(
                                order['created_at'],
                              );
                              final formattedDate = DateFormat(
                                'MMM dd, yyyy, hh:mm a',
                              ).format(orderDate);
                              final itemCount =
                                  (order['order_items'] as List?)?.fold<int>(
                                    0,
                                    (sum, item) =>
                                        sum + (item['quantity'] as int? ?? 0),
                                  ) ??
                                  0;

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SellerOrderDetailsScreen(
                                                orderId: order['id'],
                                              ),
                                        ),
                                      );
                                      _loadDashboardData(); // Refresh on return
                                    },
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Order #${order['id']}',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.button,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 6.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(
                                                    status,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        20.r,
                                                      ),
                                                ),
                                                child: Text(
                                                  status.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: _getStatusColor(
                                                      status,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12.h),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 12.r,
                                                backgroundColor:
                                                    Colors.grey[200],
                                                child: Icon(
                                                  Icons.person,
                                                  size: 14.sp,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                order['user_name'] ??
                                                    'Customer', // Assuming user_name is available or use fallback
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          Divider(
                                            height: 24.h,
                                            thickness: 1,
                                            color: Colors.grey[100],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '$itemCount Items',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Total: ',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Text(
                                                    '৳${order['total_amount']}',
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.button,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
