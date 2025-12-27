import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/order_service.dart';
import 'package:final_year_project_frontend/features/order/presentation/customer_order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key});

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  bool _isLoading = true;
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final result = await OrderService.getCustomerOrders();
    if (mounted) {
      setState(() {
        if (result['success']) {
          _orders = result['data'] ?? [];
        }
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Keep background neutral
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white, // White text for contrast
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: AppColors.button, // Use primary color
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // White back icon
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.button))
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final orderDate = DateTime.parse(order['created_at']);
                final formattedDate = DateFormat(
                  'MMM dd, yyyy, hh:mm a',
                ).format(orderDate);

                // Count total items
                final items = order['order_items'] as List<dynamic>? ?? [];
                final itemCount = items.fold<int>(
                  0,
                  (sum, item) => sum + (item['quantity'] as int? ?? 0),
                );

                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
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
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerOrderDetailsScreen(
                              orderId: order['id'],
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order Header: ID and Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      order['status'],
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    order['status_display'] ??
                                        order['status']
                                            .toString()
                                            .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _getStatusColor(order['status']),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            // Store Info
                            Row(
                              children: [
                                Icon(
                                  Icons.storefront,
                                  size: 18.sp,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  order['seller_store_name'] ?? 'Unknown Store',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),

                            // Date
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

                            // Order Items Preview
                            if (items.isNotEmpty) ...[
                              Text(
                                'Items',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ...items.map<Widget>((item) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                        child: Image.network(
                                          '$imageUrl${item['product_thumbnail']}',
                                          width: 40.w,
                                          height: 40.w,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    width: 40.w,
                                                    height: 40.w,
                                                    color: Colors.grey[200],
                                                    child: Icon(
                                                      Icons.image,
                                                      size: 20.sp,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['product_name'] ?? 'Unknown',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              '${item['quantity']} x ৳${item['price']}',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              Divider(
                                height: 16.h,
                                thickness: 1,
                                color: Colors.grey[100],
                              ),
                            ],

                            // Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        fontWeight: FontWeight.bold,
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
    );
  }
}
