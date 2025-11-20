import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/auth_service.dart';
import 'package:final_year_project_frontend/networks/profile_service.dart';
import 'package:final_year_project_frontend/networks/advertisement_service.dart';
import 'package:final_year_project_frontend/networks/store_service.dart';
import 'package:final_year_project_frontend/networks/search_service.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Create a GlobalKey to access the ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  Map<String, dynamic>? _profileData;
  bool _isLoadingProfile = true;
  bool _isUpdatingAvatar = false;
  String _currentLanguage = 'en';
  String _searchType = 'product'; // 'product' or 'shop'
  
  final TextEditingController _searchController = TextEditingController();
  
  // Banner data from API
  List<Map<String, dynamic>> _banners = [];
  bool _isLoadingBanners = true;
  
  // Stores data from API
  List<Map<String, dynamic>> _stores = [];
  bool _isLoadingStores = true;
  
  // Search results
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 0,
      'nameEn': 'ALL',
      'nameBn': 'সব',
      'icon': Icons.grid_view,
      'color': AppColors.button
    },
    {
      'id': 1,
      'nameEn': 'Seeds',
      'nameBn': 'বীজ',
      'icon': Icons.eco,
      'color': Color(0xFF8BC34A)
    },
    {
      'id': 2,
      'nameBn': 'সার',
      'nameEn': 'Fertilizer',
      'icon': Icons.local_florist,
      'color': Color(0xFF795548)
    },
    {
      'id': 3,
      'nameEn': 'Pesticide',
      'nameBn': 'কীটনাশক',
      'icon': Icons.bug_report,
      'color': Color(0xFF009688)
    },
  ];
  
  int _currentBannerIndex = 0;
  int _selectedCategoryId = 0; // 0 means ALL

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadLanguage();
    _loadBanners();
    _loadStores();
  }

  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _showSearchResults = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSearchResults = true;
    });

    try {
      final result = await SearchService.searchProductAndSeller(
        searchFor: _searchType,
        name: query,
      );

      if (mounted) {
        setState(() {
          _isSearching = false;
          if (result['success']) {
            _searchResults = List<Map<String, dynamic>>.from(result['data'] ?? []);
          } else {
            _searchResults = [];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'No results found'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildProductSearchResults() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.75,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.network(
                  '${imageUrl}${product['thumbnail']}',
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        if (product['discount_price'] != null)
                          Text(
                            '৳${product['discount_price']}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.button,
                            ),
                          ),
                        SizedBox(width: 6.w),
                        if (product['discount_price'] != null)
                          Text(
                            '৳${product['price']}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        if (product['discount_price'] == null)
                          Text(
                            '৳${product['price']}',
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoreSearchResults() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final store = _searchResults[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store owner avatar
              CircleAvatar(
                radius: 30.r,
                backgroundColor: AppColors.button.withOpacity(0.1),
                backgroundImage: store['user']?['avatar'] != null
                    ? NetworkImage('${imageUrl}${store['user']['avatar']}')
                    : null,
                child: store['user']?['avatar'] == null
                    ? Icon(Icons.store, size: 30.sp, color: AppColors.button)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store['store_name'] ?? '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      store['user']?['name'] ?? '',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            store['store_address'] ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          store['store_contact_number'] ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _loadBanners() async {
    final result = await AdvertisementService.getAdvertisements();
    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _banners = List<Map<String, dynamic>>.from(result['data'] ?? []);
        }
        _isLoadingBanners = false;
      });
    }
  }
  
  Future<void> _loadStores() async {
    final result = await StoreService.getStoreList();
    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _stores = List<Map<String, dynamic>>.from(result['data'] ?? []);
        }
        _isLoadingStores = false;
      });
    }
  }
  
  Future<void> _loadLanguage() async {
    final language = GetStorage().read(kKeyLanguage) ?? 'en';
    if (mounted) {
      setState(() {
        _currentLanguage = language;
      });
    }
  }
  
  String _translate(String en, String bn) {
    return _currentLanguage == 'bn' ? bn : en;
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final result = await ProfileService.getProfile();
    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _profileData = result['data'];
        }
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _updateAvatar() async {
    try {
      final ImagePicker picker = ImagePicker();
      
      // Show image source selection dialog
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.button),
                title: Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.button),
                title: Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      // Pick image
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _isUpdatingAvatar = true;
      });

      // Upload avatar
      final result = await ProfileService.updateAvatar(
        avatarPath: image.path,
      );

      if (mounted) {
        setState(() {
          _isUpdatingAvatar = false;
        });

        if (result['success']) {
          // Reload profile to get updated avatar
          await _loadProfile();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Avatar updated successfully'),
              backgroundColor: AppColors.button,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to update avatar'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUpdatingAvatar = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,  // Assign the key to the Scaffold
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children:  <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.button,
                ),
                child: _isLoadingProfile
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Avatar
                          GestureDetector(
                            onTap: _isUpdatingAvatar ? null : _updateAvatar,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 30.r,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _profileData?['avatar'] != null
                                      ? NetworkImage('${imageUrl}${_profileData!['avatar']}')
                                      : null,
                                  child: _profileData?['avatar'] == null
                                      ? Icon(
                                          Icons.person,
                                          size: 35.sp,
                                          color: AppColors.button,
                                        )
                                      : null,
                                ),
                                if (_isUpdatingAvatar)
                                  Positioned.fill(
                                    child: CircleAvatar(
                                      radius: 30.r,
                                      backgroundColor: Colors.black.withOpacity(0.5),
                                      child: SizedBox(
                                        width: 24.w,
                                        height: 24.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.button,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.w,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 12.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Name
                          Text(
                            _profileData?['name'] ?? 'User Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          // Email
                          Text(
                            _profileData?['email'] ?? 'user@email.com',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),

            
              ListTile(
                leading: Icon(Icons.swap_horiz, color: AppColors.button),
                title: Text('Switch Role'),
                onTap: () async {
                  Navigator.pop(context);
                  
                  // Get current role from storage
                  final currentRole = GetStorage().read(kKeyRole) ?? 'Customer';
                  
                  // Show role selection dialog
                  final selectedRole = await showDialog<String>(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Switch Role',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Select your role to continue',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // Customer Option
                            InkWell(
                              onTap: () => Navigator.pop(context, 'Customer'),
                              borderRadius: BorderRadius.circular(16.r),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.h,
                                ),
                                decoration: BoxDecoration(
                                  color: currentRole == 'Customer'
                                      ? AppColors.button.withValues(alpha: 0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: currentRole == 'Customer'
                                        ? AppColors.button
                                        : Colors.grey.withValues(alpha: 0.3),
                                    width: currentRole == 'Customer' ? 2.w : 1.w,
                                  ),
                                  boxShadow: currentRole == 'Customer'
                                      ? [
                                          BoxShadow(
                                            color: AppColors.button.withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.w,
                                      height: 48.w,
                                      decoration: BoxDecoration(
                                        color: currentRole == 'Customer'
                                            ? AppColors.button.withValues(alpha: 0.15)
                                            : Colors.grey.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(
                                        Icons.person_outline,
                                        color: currentRole == 'Customer'
                                            ? AppColors.button
                                            : Colors.grey[600],
                                        size: 24.sp,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Customer',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: currentRole == 'Customer'
                                                  ? AppColors.button
                                                  : Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Browse and purchase products',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      duration: const Duration(milliseconds: 200),
                                      opacity: currentRole == 'Customer' ? 1.0 : 0.0,
                                      child: Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.button,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // Seller Option
                            InkWell(
                              onTap: () => Navigator.pop(context, 'Seller'),
                              borderRadius: BorderRadius.circular(16.r),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.h,
                                ),
                                decoration: BoxDecoration(
                                  color: currentRole == 'Seller'
                                      ? AppColors.button.withValues(alpha: 0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: currentRole == 'Seller'
                                        ? AppColors.button
                                        : Colors.grey.withValues(alpha: 0.3),
                                    width: currentRole == 'Seller' ? 2.w : 1.w,
                                  ),
                                  boxShadow: currentRole == 'Seller'
                                      ? [
                                          BoxShadow(
                                            color: AppColors.button.withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.w,
                                      height: 48.w,
                                      decoration: BoxDecoration(
                                        color: currentRole == 'Seller'
                                            ? AppColors.button.withValues(alpha: 0.15)
                                            : Colors.grey.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Icon(
                                        Icons.storefront_outlined,
                                        color: currentRole == 'Seller'
                                            ? AppColors.button
                                            : Colors.grey[600],
                                        size: 24.sp,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Seller',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: currentRole == 'Seller'
                                                  ? AppColors.button
                                                  : Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Manage your shop and products',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      duration: const Duration(milliseconds: 200),
                                      opacity: currentRole == 'Seller' ? 1.0 : 0.0,
                                      child: Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.button,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  if (selectedRole != null && selectedRole != currentRole) {
                    // Save to local storage
                    await GetStorage().write(kKeyRole, selectedRole);
                    
                    // Update profile data
                    if (mounted) {
                      setState(() {
                        if (_profileData != null) {
                          _profileData!['role'] = selectedRole;
                        }
                      });
                      
                      // Show confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Role switched to $selectedRole'),
                          backgroundColor: AppColors.button,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.language, color: AppColors.button),
                title: Text('Change Language'),
                onTap: () async {
                  Navigator.pop(context);
                  
                  // Show language selection dialog
                  final selectedLanguage = await showDialog<String>(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose Your Language',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Select your preferred language',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // English Option
                            InkWell(
                              onTap: () => Navigator.pop(context, 'en'),
                              borderRadius: BorderRadius.circular(16.r),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentLanguage == 'en'
                                      ? AppColors.button.withValues(alpha: 0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: _currentLanguage == 'en'
                                        ? AppColors.button
                                        : Colors.grey.withValues(alpha: 0.3),
                                    width: _currentLanguage == 'en' ? 2.w : 1.w,
                                  ),
                                  boxShadow: _currentLanguage == 'en'
                                      ? [
                                          BoxShadow(
                                            color: AppColors.button.withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.w,
                                      height: 48.w,
                                      decoration: BoxDecoration(
                                        color: _currentLanguage == 'en'
                                            ? AppColors.button.withValues(alpha: 0.1)
                                            : Colors.grey.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '🇬🇧',
                                          style: TextStyle(fontSize: 28.sp),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'English',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: _currentLanguage == 'en'
                                                  ? AppColors.button
                                                  : Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'English',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      duration: const Duration(milliseconds: 200),
                                      opacity: _currentLanguage == 'en' ? 1.0 : 0.0,
                                      child: Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.button,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // Bangla Option
                            InkWell(
                              onTap: () => Navigator.pop(context, 'bn'),
                              borderRadius: BorderRadius.circular(16.r),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 20.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentLanguage == 'bn'
                                      ? AppColors.button.withValues(alpha: 0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: _currentLanguage == 'bn'
                                        ? AppColors.button
                                        : Colors.grey.withValues(alpha: 0.3),
                                    width: _currentLanguage == 'bn' ? 2.w : 1.w,
                                  ),
                                  boxShadow: _currentLanguage == 'bn'
                                      ? [
                                          BoxShadow(
                                            color: AppColors.button.withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.w,
                                      height: 48.w,
                                      decoration: BoxDecoration(
                                        color: _currentLanguage == 'bn'
                                            ? AppColors.button.withValues(alpha: 0.1)
                                            : Colors.grey.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '🇧🇩',
                                          style: TextStyle(fontSize: 28.sp),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bangla',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: _currentLanguage == 'bn'
                                                  ? AppColors.button
                                                  : Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'বাংলা',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AnimatedOpacity(
                                      duration: const Duration(milliseconds: 200),
                                      opacity: _currentLanguage == 'bn' ? 1.0 : 0.0,
                                      child: Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.button,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  if (selectedLanguage != null && selectedLanguage != _currentLanguage) {
                    // Save to local storage
                    await GetStorage().write(kKeyLanguage, selectedLanguage);
                    
                    // Update UI
                    setState(() {
                      _currentLanguage = selectedLanguage;
                    });
                    
                    // Show confirmation
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            selectedLanguage == 'en' 
                                ? 'Language changed to English' 
                                : 'ভাষা বাংলায় পরিবর্তিত হয়েছে',
                          ),
                          backgroundColor: AppColors.button,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: AppColors.button),
                title: Text('Settings'),
              ),
              SizedBox(height: 250),
              ListTile(
                leading: Icon(Icons.logout, color: AppColors.button),
                title: Text('Logout'),
                onTap: () async {
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Logout', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    // Show loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // Call sign out API
                    final result = await AuthService.signOut();

                    if (mounted) {
                      // Close loading dialog
                      Navigator.pop(context);

                      if (result['success'] == true) {
                        // Navigate to sign in screen and clear navigation stack
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.signinScreen,
                          (route) => false,
                        );
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message'] ?? 'Logout failed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        // backgroundColor:  AppColors.button.withValues(alpha: 0.1),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            borderRadius: BorderRadius.circular(25.r),
            child: _isLoadingProfile
                ? CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.button.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 20.sp,
                      color: AppColors.button,
                    ),
                  )
                : CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.button.withOpacity(0.1),
                    backgroundImage: _profileData?['avatar'] != null
                        ? NetworkImage('${imageUrl}${_profileData!['avatar']}')
                        : null,
                    child: _profileData?['avatar'] == null
                        ? Icon(
                            Icons.person,
                            size: 20.sp,
                            color: AppColors.button,
                          )
                        : null,
                  ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _profileData?['name'] ?? 'Loading...',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.button,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              GetStorage().read(kKeyRole) ?? 'User',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.button,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          // Shopping Cart with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.button,
                  size: 24.sp,
                ),
                onPressed: () {
                  // Handle cart navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Shopping cart coming soon')),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          // Notifications with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.button,
                  size: 24.sp,
                ),
                onPressed: () {
                  // Handle notifications navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notifications coming soon')),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: _searchType == 'product'
                      ? _translate('Search products...', 'পণ্য খুঁজুন...')
                      : _translate('Search Store...', 'দোকান খুঁজুন...'),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(
                    _searchType == 'product' ? Icons.search : Icons.store_outlined,
                    color: AppColors.button,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.filter_list, color: AppColors.button),
                    onPressed: () async {
                      // Show search type selection dialog
                      final selectedType = await showDialog<String>(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _translate('Search For', 'খুঁজুন'),
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  _translate('Select what you want to search', 'আপনি কি খুঁজতে চান তা নির্বাচন করুন'),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                // Products Option
                                InkWell(
                                  onTap: () => Navigator.pop(context, 'product'),
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 20.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _searchType == 'product'
                                          ? AppColors.button.withValues(alpha: 0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: _searchType == 'product'
                                            ? AppColors.button
                                            : Colors.grey.withValues(alpha: 0.3),
                                        width: _searchType == 'product' ? 2.w : 1.w,
                                      ),
                                      boxShadow: _searchType == 'product'
                                          ? [
                                              BoxShadow(
                                                color: AppColors.button.withValues(alpha: 0.2),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48.w,
                                          height: 48.w,
                                          decoration: BoxDecoration(
                                            color: _searchType == 'product'
                                                ? AppColors.button.withValues(alpha: 0.15)
                                                : Colors.grey.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Icon(
                                            Icons.shopping_bag_outlined,
                                            color: _searchType == 'product'
                                                ? AppColors.button
                                                : Colors.grey[600],
                                            size: 24.sp,
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _translate('Products', 'পণ্য'),
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: _searchType == 'product'
                                                      ? AppColors.button
                                                      : Colors.black87,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                _translate('Search for products', 'পণ্য খুঁজুন'),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 200),
                                          opacity: _searchType == 'product' ? 1.0 : 0.0,
                                          child: Container(
                                            width: 28.w,
                                            height: 28.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.button,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                // Store Option
                                InkWell(
                                  onTap: () => Navigator.pop(context, 'store'),
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 20.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _searchType == 'store'
                                          ? AppColors.button.withValues(alpha: 0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: _searchType == 'store'
                                            ? AppColors.button
                                            : Colors.grey.withValues(alpha: 0.3),
                                        width: _searchType == 'store' ? 2.w : 1.w,
                                      ),
                                      boxShadow: _searchType == 'store'
                                          ? [
                                              BoxShadow(
                                                color: AppColors.button.withValues(alpha: 0.2),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48.w,
                                          height: 48.w,
                                          decoration: BoxDecoration(
                                            color: _searchType == 'shop'
                                                ? AppColors.button.withValues(alpha: 0.15)
                                                : Colors.grey.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Icon(
                                            Icons.store_outlined,
                                            color: _searchType == 'shop'
                                                ? AppColors.button
                                                : Colors.grey[600],
                                            size: 24.sp,
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _translate('Store', 'দোকান'),
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: _searchType == 'shop'
                                                      ? AppColors.button
                                                      : Colors.black87,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                _translate('Search for store', 'দোকান খুঁজুন'),
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration: const Duration(milliseconds: 200),
                                          opacity: _searchType == 'shop' ? 1.0 : 0.0,
                                          child: Container(
                                            width: 28.w,
                                            height: 28.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.button,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      if (selectedType != null) {
                        setState(() {
                          _searchType = selectedType;
                          _searchController.clear();
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              selectedType == 'product'
                                  ? _translate('Search mode: Products', 'অনুসন্ধান মোড: পণ্য')
                                  : _translate('Search mode: Store', 'অনুসন্ধান মোড: দোকান'),
                            ),
                            backgroundColor: AppColors.button,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                ),
                onSubmitted: (value) {
                  _handleSearch(value);
                },
                onChanged: (value) {
                  // Real-time search
                  _handleSearch(value);
                },
              ),
            ),
            
            // Search Results Section
            if (_showSearchResults)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _searchType == 'product'
                              ? _translate('Search Results - Products', 'অনুসন্ধান ফলাফল - পণ্য')
                              : _translate('Search Results - Stores', 'অনুসন্ধান ফলাফল - দোকান'),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.button,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: AppColors.button),
                          onPressed: () {
                            setState(() {
                              _showSearchResults = false;
                              _searchResults = [];
                              _searchController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _isSearching
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.h),
                              child: CircularProgressIndicator(
                                color: AppColors.button,
                              ),
                            ),
                          )
                        : _searchResults.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.h),
                                  child: Text(
                                    _translate('No results found', 'কোন ফলাফল পাওয়া যায়নি'),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              )
                            : _searchType == 'product'
                                ? _buildProductSearchResults()
                                : _buildStoreSearchResults(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            
            // Banner Section
            SizedBox(
              height: 140.h,
              child: _isLoadingBanners
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.button,
                      ),
                    )
                  : _banners.isEmpty
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.button,
                                AppColors.button.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 48.sp,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'No advertisements available',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : PageView.builder(
                          itemCount: _banners.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentBannerIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final banner = _banners[index];
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.network(
                                  '${imageUrl}${banner['banner_image']}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: AppColors.button.withOpacity(0.1),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                          color: AppColors.button,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.button,
                                            AppColors.c28B446,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.broken_image,
                                              size: 48.sp,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              'Image not available',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
            
            // Banner Indicators
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentBannerIndex == index ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _currentBannerIndex == index ? AppColors.button : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Store Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _translate('Nearby Stores', 'নিকটস্থ দোকানসমূহ'),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.button,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_translate('View all stores coming soon', 'সব দোকান শীঘ্রই আসছে'))),
                      );
                    },
                    child: Text(
                      _translate('See All', 'সব দেখুন'),
                      style: TextStyle(color: AppColors.button),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 8.h),
            
            SizedBox(
              height: 110.h,
              child: _isLoadingStores
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.button,
                      ),
                    )
                  : _stores.isEmpty
                      ? Center(
                          child: Text(
                            _translate('No stores available', 'কোন দোকান উপলব্ধ নেই'),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemCount: _stores.length,
                          itemBuilder: (context, index) {
                            final store = _stores[index];
                            // Only show stores that have a store_name (are sellers)
                            if (store['store_name'] == null || store['store_name'].toString().isEmpty) {
                              return SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () {
                                // Navigate to shop details
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Opening ${store['name']}\'s store details...')),
                                );
                              },
                              child: Container(
                                width: 120.w,
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30.r,
                                      backgroundColor: AppColors.button.withValues(alpha: 0.1),
                                      backgroundImage: store['avatar'] != null && store['avatar'].toString().isNotEmpty
                                          ? NetworkImage('${imageUrl}${store['avatar']}')
                                          : null,
                                      child: store['avatar'] == null || store['avatar'].toString().isEmpty
                                          ? Icon(
                                              Icons.store,
                                              size: 30.sp,
                                              color: AppColors.button,
                                            )
                                          : null,
                                    ),
                                    SizedBox(height: 6.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                                      child: Text(
                                        store['name'] ?? 'Store',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 12.sp),
                                        SizedBox(width: 2.w),
                                        Text(
                                          (store['avg_rating'] ?? 0.0).toString(),
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        if (store['total_reviews'] != null && store['total_reviews'] > 0) ...[
                                          SizedBox(width: 2.w),
                                          Text(
                                            '(${store['total_reviews']})',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            
            SizedBox(height: 24.h),
            
            // Categories Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                _translate('Product Categories', 'পণ্যের বিভাগ'),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.button,
                ),
              ),
            ),
            
            SizedBox(height: 8.h),
            
            SizedBox(
              height: 90.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final categoryName = _translate(category['nameEn'], category['nameBn']);
                  final isSelected = _selectedCategoryId == category['id'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = category['id'];
                      });
                      // Filter products by category
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_translate('Filtering by', 'ফিল্টার করা হচ্ছে')} $categoryName...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      width: 90.w,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: isSelected ? category['color'] : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? category['color'] : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category['icon'],
                            size: 28.sp,
                            color: isSelected ? Colors.white : category['color'],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            categoryName,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Products Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _translate('Products', 'পণ্য'),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.button,
                    ),
                  ),
                  Text(
                    _selectedCategoryId == 0 
                        ? _translate('All Products', 'সব পণ্য')
                        : _translate(
                            _categories.firstWhere((c) => c['id'] == _selectedCategoryId)['nameEn'],
                            _categories.firstWhere((c) => c['id'] == _selectedCategoryId)['nameBn'],
                          ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Products Grid (Placeholder for now)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.75,
                ),
                itemCount: 6, // Placeholder count
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image Placeholder
                        Container(
                          height: 120.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 40.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product ${index + 1}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '৳ ${(index + 1) * 100}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.button,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 12.sp, color: Colors.amber),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
