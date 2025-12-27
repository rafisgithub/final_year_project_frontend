import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/due/add_due_screen.dart';

class DueListScreen extends StatefulWidget {
  const DueListScreen({super.key});

  @override
  State<DueListScreen> createState() => _DueListScreenState();
}

class _DueListScreenState extends State<DueListScreen> {
  // Enhanced Dummy Data with Status and ID
  List<Map<String, dynamic>> _dues = [
    {
      'id': 1,
      'name': 'Karim Uddin',
      'amount': '500',
      'note': 'Took rice and dal',
      'date': '20 Dec, 2024',
      'status': 'unpaid',
    },
    {
      'id': 2,
      'name': 'Rahim Mia',
      'amount': '1200',
      'note': 'Monthly groceries bill',
      'date': '18 Dec, 2024',
      'status': 'unpaid',
    },
    {
      'id': 3,
      'name': 'Salma Begum',
      'amount': '150',
      'note': 'Milk and eggs',
      'date': '15 Dec, 2024',
      'status': 'paid',
    },
    {
      'id': 4,
      'name': 'Bashir Ahmed',
      'amount': '3400',
      'note': 'Fertilizer credit',
      'date': '10 Dec, 2024',
      'status': 'unpaid',
    },
  ];

  List<Map<String, dynamic>> _filteredDues = [];
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All'; // 'All', 'Unpaid', 'Paid'

  @override
  void initState() {
    super.initState();
    _filteredDues = _dues;
    _searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDues = _dues.where((due) {
        final matchesQuery = due['name'].toLowerCase().contains(query);
        final matchesStatus =
            _filterStatus == 'All' ||
            (_filterStatus == 'Unpaid' && due['status'] == 'unpaid') ||
            (_filterStatus == 'Paid' && due['status'] == 'paid');
        return matchesQuery && matchesStatus;
      }).toList();
    });
  }

  void _toggleStatus(int id) {
    setState(() {
      final index = _dues.indexWhere((element) => element['id'] == id);
      if (index != -1) {
        final currentStatus = _dues[index]['status'];
        _dues[index]['status'] = currentStatus == 'unpaid' ? 'paid' : 'unpaid';
        _filterList(); // Re-apply filter
      }
    });
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
            onPressed: () {
              _toggleStatus(due['id']);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Status updated successfully",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: AppColors.button,
                ),
              );
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
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search customer name...',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[400],
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.button),
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

                // Filter Tabs (Tabs style)
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
            child: _filteredDues.isEmpty
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
                    itemCount: _filteredDues.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final due = _filteredDues[index];
                      return _buildDueCard(due);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDueScreen()),
          );
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
          _filterList();
        });
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

  Widget _buildDueCard(Map<String, dynamic> due) {
    bool isPaid = due['status'] == 'paid';
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
          onTap: () {
            // Show details or edit dialog
            _showStatusChangeDialog(due);
          },
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
                            due['name'],
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
                        due['note'],
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
                            due['date'],
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
                      '৳ ${due['amount']}',
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
