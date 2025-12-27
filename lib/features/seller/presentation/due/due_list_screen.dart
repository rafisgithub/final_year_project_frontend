import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/due/add_due_screen.dart';
import 'package:final_year_project_frontend/networks/order_service.dart';

class DueListScreen extends StatefulWidget {
  const DueListScreen({super.key});

  @override
  State<DueListScreen> createState() => _DueListScreenState();
}

class _DueListScreenState extends State<DueListScreen> {
  List<Map<String, dynamic>> _dues = [];
  bool _isLoading = false;
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All'; // 'All', 'Unpaid', 'Paid'

  @override
  void initState() {
    super.initState();
    _fetchDues(); // Initial fetch
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDues() async {
    setState(() => _isLoading = true);

    final result = await OrderService.getDues(
      customerName: _searchController.text.trim(),
      statusFilter: _filterStatus.toLowerCase(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _dues = List<Map<String, dynamic>>.from(result['data']);
        } else {
          _dues = []; // Clear list on error or empty
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchDues();
    });
  }

  Future<void> _deleteDue(int id) async {
    final bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Delete Due?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.c3D4040,
              ),
            ),
            content: Text("Are you sure you want to delete this entry?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Delete", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      // Show loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Deleting...")));

      final result = await OrderService.deleteDue(id);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
        if (result['success']) {
          _fetchDues(); // Refresh list
        }
      }
    }
  }

  void _showStatusChangeDialog(Map<String, dynamic> due) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Update Status",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.c3D4040,
          ),
        ),
        content: Text(
          due['status'] == 'unpaid'
              ? "Mark this due as Settled/Paid?"
              : "Mark this due as Unpaid?",
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first

              // Determine new status
              final currentStatus = due['status'] ?? 'unpaid';
              final newStatus = currentStatus == 'unpaid' ? 'paid' : 'unpaid';

              // Show loading indicator or simple snackbar
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Updating status...")));

              final result = await OrderService.updateDueStatus(
                due['id'],
                newStatus,
              );

              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(result['message'])));

                if (result['success']) {
                  _fetchDues(); // Refresh list to show updated status
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.button),
            child: Text("Confirm", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Credit Book',
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
      body: Column(
        children: [
          // Header with Search and Filter
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            decoration: BoxDecoration(
              color: AppColors.button,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.button.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search customer name...',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: GestureDetector(
                      onTap: _fetchDues, // Allow taping icon to search
                      child: Icon(Icons.search, color: AppColors.button),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                  ),
                ),
                SizedBox(height: 16.h),

                // Filter Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFilterTab('All'),
                    SizedBox(width: 12.w),
                    _buildFilterTab('Unpaid'),
                    SizedBox(width: 12.w),
                    _buildFilterTab('Paid'),
                  ],
                ),
              ],
            ),
          ),

          // List Content
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.button),
                  )
                : _dues.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.request_page_outlined,
                          size: 64.sp,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No records found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _dues.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final due = _dues[index];
                      return _buildDueCard(due);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDueScreen()),
          );
          _fetchDues(); // Refresh list after returning
        },
        backgroundColor: AppColors.button,
        elevation: 4,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add Entry",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String title) {
    final bool isSelected = _filterStatus == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterStatus = title;
        });
        _fetchDues();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.button : Colors.white,
          ),
        ),
      ),
    );
  }

  void _showDueActions(Map<String, dynamic> due) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Manage Due Entry",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.h),
            _buildActionTile(
              icon: Icons.edit,
              color: Colors.blue,
              label: "Edit Entry",
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDueScreen(dueId: due['id']),
                  ),
                );
                _fetchDues();
              },
            ),
            _buildActionTile(
              icon: Icons.sync,
              color: Colors.orange,
              label: due['status'] == 'paid'
                  ? "Mark as Unpaid"
                  : "Mark as Paid",
              onTap: () {
                Navigator.pop(context);
                _showStatusChangeDialog(due);
              },
            ),
            _buildActionTile(
              icon: Icons.delete,
              color: Colors.red,
              label: "Delete Entry",
              onTap: () {
                Navigator.pop(context);
                _deleteDue(due['id']);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDueCard(Map<String, dynamic> due) {
    bool isPaid =
        (due['status'] ?? 'unpaid').toString().toLowerCase() == 'paid';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _showDueActions(due),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            due['customer_name'] ?? due['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          if (isPaid)
                            Icon(
                              Icons.check_circle,
                              size: 16.sp,
                              color: Colors.green,
                            ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        due['notes'] ?? due['note'] ?? 'No notes',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            due['payment_date'] ?? due['date'] ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      // Handle amount as string or number safely
                      '৳ ${due['due_amount'] ?? due['amount'] ?? 0}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPaid ? Colors.green : Colors.red,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isPaid
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        isPaid ? "PAID" : "UNPAID",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: isPaid ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
