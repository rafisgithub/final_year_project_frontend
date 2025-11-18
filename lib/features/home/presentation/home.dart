import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/auth_service.dart';
import 'package:final_year_project_frontend/networks/profile_service.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

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
  String _currentLanguage = 'en';
  
  final TextEditingController _searchController = TextEditingController();
  
  // Sample data - replace with API calls later
  final List<Map<String, dynamic>> _banners = [
    {'title': 'Special Offer 20% OFF', 'color': AppColors.button, 'icon': Icons.local_offer},
    {'title': 'New Arrivals', 'color': AppColors.c28B446, 'icon': Icons.new_releases},
    {'title': 'Fresh Products', 'color': AppColors.button, 'icon': Icons.shopping_bag},
  ];
  
  final List<Map<String, dynamic>> _shops = [
    {'id': 1, 'name': 'Green Farm Store', 'owner': 'John Doe', 'initials': 'GF', 'color': AppColors.button, 'rating': 4.5},
    {'id': 2, 'name': 'Fresh Harvest', 'owner': 'Jane Smith', 'initials': 'FH', 'color': AppColors.c28B446, 'rating': 4.8},
    {'id': 3, 'name': 'Organic Market', 'owner': 'Bob Wilson', 'initials': 'OM', 'color': AppColors.button, 'rating': 4.3},
    {'id': 4, 'name': 'Farm Direct', 'owner': 'Alice Brown', 'initials': 'FD', 'color': AppColors.c28B446, 'rating': 4.6},
  ];
  
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 1,
      'nameEn': 'Seeds',
      'nameBn': 'বীজ',
      'icon': Icons.grass,
      'color': Color(0xFF8BC34A)
    },
    {
      'id': 2,
      'nameBn': 'সার',
      'nameEn': 'Fertilizer',
      'icon': Icons.science,
      'color': Color(0xFF795548)
    },
    {
      'id': 3,
      'nameEn': 'Pesticide',
      'nameBn': 'কীটনাশক',
      'icon': Icons.water_drop,
      'color': Color(0xFF009688)
    },
  ];
  
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadLanguage();
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
                leading: Icon(Icons.home, color: AppColors.button),
                title: Text('Home'),
              ),
              ListTile(
                leading: Icon(Icons.swap_horiz, color: AppColors.button),
                title: Text('Switch Role'),
                onTap: () {
                  // Handle switch role action
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.language, color: AppColors.button),
                title: Text('Change Language'),
                onTap: () {
                  // Handle change language action
                  Navigator.pop(context);
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
        backgroundColor:  AppColors.button.withValues(alpha: 0.1),
        elevation: 2,
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
                  hintText: _translate('Search products...', 'পণ্য খুঁজুন...'),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: AppColors.button),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.filter_list, color: AppColors.button),
                    onPressed: () {
                      // Handle filter action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Filter options coming soon')),
                      );
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
                  // Handle search
                  if (value.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Searching for: $value')),
                    );
                  }
                },
              ),
            ),
            
            // Banner Section
            SizedBox(
              height: 180.h,
              child: PageView.builder(
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
                      gradient: LinearGradient(
                        colors: [
                          banner['color'],
                          banner['color'].withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            banner['icon'],
                            size: 48.sp,
                            color: Colors.white,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            banner['title'],
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
            
            // Shops Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _translate('Featured Shops', 'ফিচার্ড দোকান'),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.button,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_translate('View all shops coming soon', 'সব দোকান শীঘ্রই আসছে'))),
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
            
            SizedBox(height: 12.h),
            
            SizedBox(
              height: 140.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: _shops.length,
                itemBuilder: (context, index) {
                  final shop = _shops[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to shop details
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${shop['name']} details...')),
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
                            radius: 35.r,
                            backgroundColor: shop['color'],
                            child: Text(
                              shop['initials'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              shop['name'],
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 14.sp),
                              SizedBox(width: 4.w),
                              Text(
                                shop['rating'].toString(),
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
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.button,
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.85,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final categoryName = _translate(category['nameEn'], category['nameBn']);
                return GestureDetector(
                  onTap: () {
                    // Filter products by category
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${_translate('Filtering by', 'ফিল্টার করা হচ্ছে')} $categoryName...')),
                    );
                  },
                  child: Container(
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
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: category['color'].withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            category['icon'],
                            size: 32.sp,
                            color: category['color'],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            categoryName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
