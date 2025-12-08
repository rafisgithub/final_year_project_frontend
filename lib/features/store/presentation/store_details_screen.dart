import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/networks/search_service.dart';
import 'package:final_year_project_frontend/networks/store_service.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

class StoreDetailsScreen extends StatefulWidget {
  final int storeId;
  final Map<String, dynamic>?
  storeData; // Optional - will be fetched if not provided

  const StoreDetailsScreen({super.key, required this.storeId, this.storeData});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentLanguage = 'en';

  // Store data
  Map<String, dynamic>? _storeData;
  bool _isLoadingStore = false;
  String? _storeError;

  // Search results
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;

  // Products data
  List<Map<String, dynamic>> _products = [];
  bool _isLoadingProducts = false;
  String? _productsError;

  // Categories
  int _selectedCategoryId = 0; // 0 means ALL
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 0,
      'nameEn': 'ALL',
      'nameBn': 'সব',
      'icon': Icons.grid_view,
      'color': AppColors.button,
    },
    {
      'id': 1,
      'nameEn': 'Seed',
      'nameBn': 'বীজ',
      'icon': Icons.eco,
      'color': Color(0xFF8BC34A),
    },
    {
      'id': 2,
      'nameBn': 'সার',
      'nameEn': 'Fertilizer',
      'icon': Icons.local_florist,
      'color': Color(0xFF795548),
    },
    {
      'id': 3,
      'nameEn': 'Pesticide',
      'nameBn': 'কীটনাশক',
      'icon': Icons.bug_report,
      'color': Color(0xFF009688),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadStoreDetails();
    _loadProducts(); // Load products on init
  }

  Future<void> _loadStoreDetails() async {
    // Use provided data if available, otherwise fetch from API
    if (widget.storeData != null) {
      setState(() {
        _storeData = widget.storeData;
      });
      return;
    }

    setState(() {
      _isLoadingStore = true;
      _storeError = null;
    });

    try {
      final result = await StoreService.getStoreDetails(widget.storeId);

      if (mounted) {
        setState(() {
          _isLoadingStore = false;
          if (result['success']) {
            _storeData = result['data'];
          } else {
            _storeError = result['message'];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStore = false;
          _storeError = 'Failed to load store details';
        });
      }
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

  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
      _productsError = null;
    });

    try {
      // Get category name from selected category
      String? categoryName;
      if (_selectedCategoryId != 0) {
        final selectedCategory = _categories.firstWhere(
          (cat) => cat['id'] == _selectedCategoryId,
          orElse: () => {},
        );
        categoryName = selectedCategory['nameEn']?.toString().toLowerCase();
      }

      // Get search query if searching
      String? productName = _searchController.text.isNotEmpty
          ? _searchController.text
          : null;

      final result = await StoreService.getStoreProducts(
        storeId: widget.storeId,
        categoryName: categoryName,
        productName: productName,
      );

      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
          if (result['success']) {
            _products = List<Map<String, dynamic>>.from(result['data'] ?? []);
          } else {
            _productsError = result['message'];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProducts = false;
          _productsError = 'Failed to load products';
        });
      }
    }
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
      // Search only for products in this store
      final result = await SearchService.searchProductAndSeller(
        searchFor: 'product',
        name: query,
      );

      if (mounted) {
        setState(() {
          _isSearching = false;
          if (result['success']) {
            _searchResults = List<Map<String, dynamic>>.from(
              result['data'] ?? [],
            );
          } else {
            _searchResults = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
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
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40.sp,
                        color: Colors.grey,
                      ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoadingStore) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.button),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: CircularProgressIndicator(color: AppColors.button)),
      );
    }

    // Show error state
    if (_storeError != null || _storeData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.button),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                _storeError ?? 'Failed to load store details',
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _loadStoreDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                ),
                child: Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Store Cover Photo Banner Header
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            backgroundColor: AppColors.button,
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.button,
                  size: 20.sp,
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover Photo
                  if (_storeData!['store_cover_photo'] != null)
                    Image.network(
                      '${imageUrl}${_storeData!['store_cover_photo']}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.button.withOpacity(0.8),
                                AppColors.button,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.store,
                              size: 80.sp,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.button.withOpacity(0.8),
                            AppColors.button,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.store,
                          size: 80.sp,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  // Gradient Overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Store Info Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Store Name
                          Text(
                            _storeData!['store_name'] ?? 'Store Name',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          // Owner Name
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16.sp,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                _storeData!['name'] ?? 'Owner Name',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white.withOpacity(0.95),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          // Rating and Reviews
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 18.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${_storeData!['avg_rating']?.toStringAsFixed(1) ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '${_storeData!['total_reviews'] ?? 0} ${_translate('reviews', 'রিভিউ')}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.95),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // Contact Info Card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _translate('Contact Information', 'যোগাযোগের তথ্য'),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.button,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Phone Number
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.button.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.phone,
                              size: 24.sp,
                              color: AppColors.button,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _translate('Phone Number', 'ফোন নম্বর'),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  _storeData!['phone_number'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Message Seller Button
                      InkWell(
                        onTap: () {
                          // TODO: Navigate to messaging screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _translate(
                                  'Messaging feature coming soon!',
                                  'মেসেজিং সুবিধা শীঘ্রই আসছে!',
                                ),
                              ),
                              backgroundColor: AppColors.button,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.button,
                                AppColors.button.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.button.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.message_rounded,
                                size: 22.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                _translate(
                                  'Message Seller',
                                  'বিক্রেতাকে মেসেজ করুন',
                                ),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // About Store section
                if (_storeData!['store_description'] != null) ...[
                  SizedBox(height: 16.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _translate('About Store', 'দোকান সম্পর্কে'),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.button,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          _storeData!['store_description'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 16.h),

                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: _translate(
                        'Search products in this store...',
                        'এই দোকানে পণ্য খুঁজুন...',
                      ),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: AppColors.button),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.button,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                    ),
                    onChanged: (value) {
                      _handleSearch(value);
                    },
                  ),
                ),

                // Search Results Section
                if (_showSearchResults)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _translate('Search Results', 'অনুসন্ধান ফলাফল'),
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
                                    _translate(
                                      'No products found',
                                      'কোন পণ্য পাওয়া যায়নি',
                                    ),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              )
                            : _buildProductSearchResults(),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),

                // Categories Section
                if (!_showSearchResults) ...[
                  SizedBox(height: 16.h),
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
                        final categoryName = _translate(
                          category['nameEn'],
                          category['nameBn'],
                        );
                        final isSelected =
                            _selectedCategoryId == category['id'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryId = category['id'];
                            });
                            // Reload products when category changes
                            _loadProducts();
                          },
                          child: Container(
                            width: 90.w,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? category['color']
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? category['color']
                                    : Colors.grey.shade300,
                                width: 2.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category['icon'],
                                  size: 32.sp,
                                  color: isSelected
                                      ? Colors.white
                                      : category['color'],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  categoryName,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
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
                    child: Text(
                      _translate('Available Products', 'উপলব্ধ পণ্য'),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.button,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Products Grid
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _isLoadingProducts
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.h),
                              child: CircularProgressIndicator(
                                color: AppColors.button,
                              ),
                            ),
                          )
                        : _productsError != null
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.h),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48.sp,
                                    color: Colors.red,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    _productsError!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  SizedBox(height: 16.h),
                                  ElevatedButton(
                                    onPressed: _loadProducts,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.button,
                                    ),
                                    child: Text(
                                      _translate('Retry', 'আবার চেষ্টা করুন'),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _products.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.h),
                              child: Text(
                                _translate(
                                  'No products found',
                                  'কোন পণ্য পাওয়া যায়নি',
                                ),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio: 0.75,
                                ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final product = _products[index];
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
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12.r),
                                      ),
                                      child: product['thumbnail'] != null
                                          ? Image.network(
                                              '${imageUrl}${product['thumbnail']}',
                                              height: 120.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      height: 120.h,
                                                      color: Colors.grey[200],
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 40.sp,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Container(
                                              height: 120.h,
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.image,
                                                size: 40.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'] ?? 'Product',
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
                                              if (product['discount_price'] !=
                                                  null) ...[
                                                Text(
                                                  '৳${product['discount_price']}',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.button,
                                                  ),
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  '৳${product['price']}',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ] else ...[
                                                Text(
                                                  '৳${product['price']}',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.button,
                                                  ),
                                                ),
                                              ],
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
