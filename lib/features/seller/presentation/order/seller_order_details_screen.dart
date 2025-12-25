import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/networks/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SellerOrderDetailsScreen extends StatefulWidget {
  final int orderId;
  const SellerOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<SellerOrderDetailsScreen> createState() =>
      _SellerOrderDetailsScreenState();
}

class _SellerOrderDetailsScreenState extends State<SellerOrderDetailsScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _order = {};
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final result = await OrderService.getOrderDetails(widget.orderId);

    if (mounted) {
      if (result['success']) {
        setState(() {
          _order = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cF2F0F0,
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: TextStyle(
            fontFamily: 'Eurostile',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.c3D4040,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.c3D4040),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  SizedBox(height: 16.h),
                  _buildCustomerSection(),
                  SizedBox(height: 16.h),
                  _buildItemsSection(),
                  SizedBox(height: 16.h),
                  _buildSummarySection(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHeaderSection() {
    final date = _order['created_at'] != null
        ? DateFormat(
            'dd MMM yyyy, hh:mm a',
          ).format(DateTime.parse(_order['created_at']))
        : 'Unknown Date';

    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${_order['id']}',
                style: TextStyle(
                  fontFamily: 'Eurostile',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c3D4040,
                ),
              ),
              _buildStatusChip(_order['status']),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Placed on $date',
            style: TextStyle(fontSize: 12.sp, color: AppColors.c8993A4),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.c3D4040,
            ),
          ),
          Divider(color: AppColors.cF2F0F0, height: 24.h),
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.cF2F0F0,
                backgroundImage: _order['customer_avatar'] != null
                    ? NetworkImage('$imageUrl${_order['customer_avatar']}')
                    : null,
                child: _order['customer_avatar'] == null
                    ? Icon(Icons.person, color: AppColors.c8993A4, size: 24.sp)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _order['customer_name'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.c3D4040,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (_order['customer_email'] != null)
                      Text(
                        _order['customer_email'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.c8993A4,
                        ),
                      ),
                    if (_order['customer_phone'] != null)
                      Text(
                        _order['customer_phone'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.c8993A4,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (_order['delivery_address'] != null) ...[
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.sp,
                  color: AppColors.button,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    _order['delivery_address'],
                    style: TextStyle(fontSize: 13.sp, color: AppColors.c3D4040),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    final items = _order['order_items'] as List<dynamic>? ?? [];

    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${items.length})',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.c3D4040,
            ),
          ),
          Divider(color: AppColors.cF2F0F0, height: 24.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.cF2F0F0, height: 24.h),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.cF2F0F0,
                      borderRadius: BorderRadius.circular(8.r),
                      image: item['product_thumbnail'] != null
                          ? DecorationImage(
                              image: NetworkImage(
                                '$imageUrl${item['product_thumbnail']}',
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['product_name'] ?? 'Unknown Product',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.c3D4040,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${item['quantity']} x ৳${item['price']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.c8993A4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '৳${item['subtotal']}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.c3D4040,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.c3D4040,
                ),
              ),
              Text(
                '৳${_order['total_amount']}',
                style: TextStyle(
                  fontFamily: 'Eurostile',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.button,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color color;
    Color textColor;
    switch (status?.toLowerCase()) {
      case 'pending':
        color = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'confirmed':
        color = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        break;
      case 'delivered':
        color = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        color = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        (status ?? 'Unknown').toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
