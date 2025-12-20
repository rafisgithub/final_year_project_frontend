import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

class AddDueScreen extends StatefulWidget {
  const AddDueScreen({super.key});

  @override
  State<AddDueScreen> createState() => _AddDueScreenState();
}

class _AddDueScreenState extends State<AddDueScreen> {
  final _formKey = GlobalKey<FormState>();
  String _customerName = '';
  String _amount = '';
  String _note = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Due Entry',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Name
              _buildLabel('Customer Name'),
              TextFormField(
                decoration: _inputDecoration('Enter customer name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
                onSaved: (value) => _customerName = value!,
              ),
              SizedBox(height: 16.h),

              // Amount
              _buildLabel('Due Amount'),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('0.00'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onSaved: (value) => _amount = value!,
              ),
              SizedBox(height: 16.h),

              // Note/Items
              _buildLabel('Note / Items Purchased'),
              TextFormField(
                maxLines: 3,
                decoration: _inputDecoration('e.g., Rice 5kg, Oil 1L...'),
                validator: (value) =>
                    value!.isEmpty ? 'Please add a note' : null,
                onSaved: (value) => _note = value!,
              ),
              SizedBox(height: 16.h),

              // Date (Defaults to today for UI)
              _buildLabel('Date'),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 40.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Logic to save due entry would go here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Due Entry Added!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red for debt/due
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Save Entry',
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
