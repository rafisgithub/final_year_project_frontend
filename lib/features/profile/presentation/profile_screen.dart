import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String role;

  const ProfileScreen({super.key, required this.userData, required this.role});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _fatherNameController;

  // Customer specific
  late TextEditingController _addressController;
  late TextEditingController _dobController;

  // Seller specific
  late TextEditingController _storeNameController;
  late TextEditingController _storeContactController;
  late TextEditingController _storeAddressController;
  late TextEditingController _storeDescriptionController;

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = widget.userData['user'] ?? {};

    _nameController = TextEditingController(text: user['name'] ?? '');
    _phoneController = TextEditingController(text: user['phone_number'] ?? '');
    _emailController = TextEditingController(text: user['email'] ?? '');
    _fatherNameController = TextEditingController(
      text: user['father_name'] ?? '',
    );

    // Customer fields
    _addressController = TextEditingController(
      text: widget.userData['address'] ?? '',
    );
    _dobController = TextEditingController(text: widget.userData['dob'] ?? '');

    // Seller fields
    _storeNameController = TextEditingController(
      text: widget.userData['store_name'] ?? '',
    );
    _storeContactController = TextEditingController(
      text: widget.userData['store_contact_number'] ?? '',
    );
    _storeAddressController = TextEditingController(
      text: widget.userData['store_address'] ?? '',
    );
    _storeDescriptionController = TextEditingController(
      text: widget.userData['store_description'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _fatherNameController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _storeNameController.dispose();
    _storeContactController.dispose();
    _storeAddressController.dispose();
    _storeDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> updateData = {
      'name': _nameController.text,
      'father_name': _fatherNameController.text,
      // 'email': _emailController.text, // Email usually not editable directly
      // 'phone_number': _phoneController.text, // Phone usually not editable directly
    };

    if (widget.role == 'customer') {
      updateData['address'] = _addressController.text;
      updateData['dob'] = _dobController.text;
    } else if (widget.role == 'seller') {
      updateData['store_name'] = _storeNameController.text;
      updateData['store_contact_number'] = _storeContactController.text;
      updateData['store_address'] = _storeAddressController.text;
      updateData['store_description'] = _storeDescriptionController.text;
    }

    final result = await ProfileService.updateProfile(
      data: updateData,
      role: widget.role,
    );

    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _isEditing = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userData['user'] ?? {};
    final avatarUrl = user['avatar'] != null
        ? '$imageUrl${user['avatar']}'
        : null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // 1. Curved Header Background
          Container(
            height: 280.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.button,
                  AppColors.button.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
          ),

          // 2. Custom App Bar
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button with Glass visual effect
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  // Edit/Save Button
                  InkWell(
                    onTap: () {
                      if (_isEditing) {
                        _updateProfile();
                      } else {
                        setState(() {
                          _isEditing = true;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Main Content
          Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Avatar Section (Overlapping)
                    SizedBox(height: 20.h),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          Container(
                            width: 130.r,
                            height: 130.r,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 60.r,
                              backgroundColor: Colors.white,
                              backgroundImage: avatarUrl != null
                                  ? NetworkImage(avatarUrl)
                                  : null,
                              child: avatarUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60.sp,
                                      color: AppColors.button,
                                    )
                                  : null,
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.button,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                    // User Name Display (Non-editable view)
                    if (!_isEditing) ...[
                      Text(
                        _nameController.text,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Still on header bg
                        ),
                      ),
                      Text(
                        widget.role.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],

                    SizedBox(height: 40.h), // Push content down past header
                    // Sections
                    _buildSectionCard(
                      title: 'Personal Information',
                      icon: Icons.person_outline,
                      children: [
                        _buildModernTextField(
                          'Full Name',
                          _nameController,
                          Icons.badge_outlined,
                        ),
                        _buildModernTextField(
                          'Father Name',
                          _fatherNameController,
                          Icons.family_restroom,
                        ),
                        _buildModernTextField(
                          'Email',
                          _emailController,
                          Icons.email_outlined,
                          readOnly: true,
                        ),
                        _buildModernTextField(
                          'Phone',
                          _phoneController,
                          Icons.phone_outlined,
                          readOnly: true,
                        ),
                      ],
                    ),

                    if (widget.role == 'customer')
                      _buildSectionCard(
                        title: 'Address & Details',
                        icon: Icons.home_outlined,
                        children: [
                          _buildModernTextField(
                            'Date of Birth',
                            _dobController,
                            Icons.cake_outlined,
                          ),
                          _buildModernTextField(
                            'Address',
                            _addressController,
                            Icons.location_on_outlined,
                            maxLines: 2,
                          ),
                        ],
                      ),

                    if (widget.role == 'seller')
                      _buildSectionCard(
                        title: 'Store Information',
                        icon: Icons.storefront_outlined,
                        children: [
                          _buildModernTextField(
                            'Store Name',
                            _storeNameController,
                            Icons.store,
                          ),
                          _buildModernTextField(
                            'Store Contact',
                            _storeContactController,
                            Icons.contact_phone_outlined,
                          ),
                          _buildModernTextField(
                            'Store Address',
                            _storeAddressController,
                            Icons.map_outlined,
                            maxLines: 2,
                          ),
                          _buildModernTextField(
                            'Description',
                            _storeDescriptionController,
                            Icons.description_outlined,
                            maxLines: 3,
                          ),
                        ],
                      ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.button),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.button.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: AppColors.button, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[100]),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    bool readOnly = false,
  }) {
    // Only show field if it has value or we are editing
    if (!readOnly && !_isEditing && controller.text.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: _isEditing && !readOnly
                  ? Colors.grey[50]
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              border: _isEditing && !readOnly
                  ? Border.all(color: Colors.grey[300]!)
                  : null,
            ),
            child: Row(
              crossAxisAlignment: maxLines > 1
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                if (_isEditing)
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Icon(
                      icon,
                      size: 20.sp,
                      color: _isEditing ? Colors.grey[400] : AppColors.button,
                    ),
                  ),
                Expanded(
                  child: _isEditing && !readOnly
                      ? TextField(
                          controller: controller,
                          maxLines: maxLines,
                          decoration: InputDecoration(
                            hintText: 'Enter $label',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: _isEditing ? 0 : 0,
                              vertical: 12.h,
                            ),
                            isDense: true,
                          ),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            controller.text.isEmpty ? 'N/A' : controller.text,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          if (!_isEditing) Divider(height: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }
}
