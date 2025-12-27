import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/order_service.dart';
import 'package:intl/intl.dart';

class AddDueScreen extends StatefulWidget {
  final int? dueId; // Optional for Edit

  const AddDueScreen({super.key, this.dueId});

  @override
  State<AddDueScreen> createState() => _AddDueScreenState();
}

class _AddDueScreenState extends State<AddDueScreen> {
  final _formKey = GlobalKey<FormState>();
  String _amount = '';
  String _note = '';
  String _phoneNumber = '';
  int? _selectedCustomerId;
  DateTime _selectedDate = DateTime.now();
  String _status = 'unpaid';
  final List<String> _statusOptions = ['unpaid', 'paid'];

  List<Map<String, dynamic>> _customers = [];
  bool _isLoadingCustomers = false;
  bool _isLoadingDetails = false;
  bool _isSubmitting = false;

  final TextEditingController _customerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    if (widget.dueId != null) {
      _fetchDueDetails();
    }
  }

  Future<void> _fetchDueDetails() async {
    setState(() => _isLoadingDetails = true);
    final result = await OrderService.getDueDetails(widget.dueId!);
    if (mounted) {
      setState(() {
        _isLoadingDetails = false;
        if (result['success']) {
          final due = result['data'];
          _selectedCustomerId = due['customer'] ?? due['customer_id'];

          _phoneNumber = due['phone_number'] ?? '';

          // Try to fill phone from customer list if empty
          if (_phoneNumber.isEmpty &&
              _customers.isNotEmpty &&
              _selectedCustomerId != null) {
            final customer = _customers.firstWhere(
              (c) => c['id'] == _selectedCustomerId,
              orElse: () => {},
            );
            if (customer.isNotEmpty) {
              _phoneNumber = customer['phone_number'] ?? '';
            }
          }

          _amount = (due['due_amount'] ?? 0).toString();
          _note = due['notes'] ?? '';
          _status = due['status'] ?? 'unpaid';
          if (due['payment_date'] != null) {
            _selectedDate = DateTime.parse(due['payment_date']);
          }
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      });
    }
  }

  Future<void> _fetchCustomers() async {
    setState(() => _isLoadingCustomers = true);
    final result = await OrderService.getAllCustomers();
    if (result['success']) {
      setState(() {
        _customers = List<Map<String, dynamic>>.from(result['data']);
        _isLoadingCustomers = false;

        // If we have details but no phone, try to find it in customer list
        if (_phoneNumber.isEmpty && _selectedCustomerId != null) {
          final customer = _customers.firstWhere(
            (c) => c['id'] == _selectedCustomerId,
            orElse: () => {},
          );
          if (customer.isNotEmpty) {
            _phoneNumber = customer['phone_number'] ?? '';
          }
        }
      });
    } else {
      setState(() => _isLoadingCustomers = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    }
  }

  Future<void> _submitDueEntry() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a customer')));
      return;
    }

    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);

    Map<String, dynamic> result;

    if (widget.dueId != null) {
      result = await OrderService.updateDue(
        id: widget.dueId!,
        customerId: _selectedCustomerId!,
        phoneNumber:
            _phoneNumber, // Ensure phone is sent. If empty, backend might complain or keep old.
        amount: double.parse(_amount),
        paymentDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        notes: _note,
        status: _status,
      );
    } else {
      result = await OrderService.addDue(
        customerId: _selectedCustomerId!,
        phoneNumber: _phoneNumber,
        amount: double.parse(_amount),
        paymentDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        notes: _note,
        status: _status,
      );
    }

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
      if (result['success']) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: AppColors.button)),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.dueId != null ? 'Update Due Entry' : 'Add Due Entry',
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
      body: _isLoadingDetails
          ? Center(child: CircularProgressIndicator(color: AppColors.button))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Name
                    _buildLabel('Customer Name'),
                    _isLoadingCustomers
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: AppColors.button,
                              ),
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              return DropdownMenu<int>(
                                width: constraints.maxWidth,
                                controller: _customerController,
                                initialSelection:
                                    _selectedCustomerId, // Set initial selection
                                enableFilter: true,
                                requestFocusOnTap: true,
                                leadingIcon: const Icon(Icons.search),
                                label: const Text('Select Customer'),
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                ),
                                dropdownMenuEntries: _customers.map((customer) {
                                  return DropdownMenuEntry<int>(
                                    value: customer['id'],
                                    label: customer['name'],
                                  );
                                }).toList(),
                                onSelected: (int? id) {
                                  setState(() {
                                    _selectedCustomerId = id;
                                  });
                                },
                              );
                            },
                          ),
                    SizedBox(height: 16.h),

                    // Phone Number
                    _buildLabel('Phone Number'),
                    TextFormField(
                      controller: TextEditingController(
                        text: _phoneNumber,
                      ), // Use controller or key to update value
                      // If using controller, need to manage it.
                      // Simpler: use key.
                      key: ValueKey(_phoneNumber),
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration('Enter phone number'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter phone number' : null,
                      onSaved: (value) => _phoneNumber = value!,
                      onChanged: (val) => _phoneNumber = val,
                    ),
                    SizedBox(height: 16.h),

                    // Amount
                    _buildLabel('Due Amount'),
                    TextFormField(
                      key: ValueKey(_amount),
                      initialValue: _amount,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('0.00'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                      onSaved: (value) => _amount = value!,
                      onChanged: (val) => _amount = val,
                    ),
                    SizedBox(height: 16.h),

                    // Note/Items
                    _buildLabel('Note / Items Purchased'),
                    TextFormField(
                      key: ValueKey(_note),
                      initialValue: _note,
                      maxLines: 3,
                      decoration: _inputDecoration('e.g., Rice 5kg, Oil 1L...'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please add a note' : null,
                      onSaved: (value) => _note = value!,
                      onChanged: (val) => _note = val,
                    ),
                    SizedBox(height: 16.h),

                    // Status Dropdown
                    _buildLabel('Status'),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: _inputDecoration('Select Status'),
                      items: _statusOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _status = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Date
                    _buildLabel('Payment Date'),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd MMM, yyyy').format(_selectedDate),
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.sp,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: AppColors.button,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitDueEntry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.button,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.dueId != null
                                    ? 'Update Entry'
                                    : 'Save Entry',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }
}
