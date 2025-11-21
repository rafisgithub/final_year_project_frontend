import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/networks/search_service.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> storeData;

  const StoreDetailsScreen({super.key, required this.storeData});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentLanguage = 'en';
  
  // Search results
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  
  // Categories
  int _selectedCategoryId = 0; // 0 means ALL
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

  @override
  void initState() {
    super.initState();
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
            _searchResults = List<Map<String, dynamic>>.from(result['data'] ?? []);
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeOwner = widget.storeData['user'] ?? {};
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Store Info
          SliverAppBar(
            expandedHeight: widget.storeData['store_description'] != null ? 200.h : 140.h,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF0B7F22)),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(60.w, 8.h, 16.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Store Owner Avatar
                            CircleAvatar(
                              radius: 30.r,
                              backgroundColor: Colors.white,
                              backgroundImage: storeOwner['avatar'] != null
                                  ? NetworkImage('${imageUrl}${storeOwner['avatar']}')
                                  : null,
                              child: storeOwner['avatar'] == null
                                  ? Icon(
                                      Icons.store,
                                      size: 30.sp,
                                      color: AppColors.button,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 12.w),
                            // Store Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Store Name
                              Text(
                                widget.storeData['store_name'] ?? 'Store Name',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B7F22),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              // Owner Name
                              Text(
                                storeOwner['name'] ?? 'Owner Name',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Color(0xFF0B7F22).withOpacity(0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              // Address
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 12.sp, color: Color(0xFF0B7F22).withOpacity(0.8)),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      widget.storeData['store_address'] ?? 'Address not available',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Color(0xFF0B7F22).withOpacity(0.7),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              // Phone with action buttons
                              Row(
                                children: [
                                  Icon(Icons.phone, size: 12.sp, color: Color(0xFF0B7F22).withOpacity(0.8)),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      widget.storeData['store_contact_number'] ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Color(0xFF0B7F22).withOpacity(0.7),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  // WhatsApp Button
                                  InkWell(
                                    onTap: () async {
                                      final phone = widget.storeData['store_contact_number'] ?? '';
                                      if (phone.isNotEmpty) {
                                        try {
                                          final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
                                          final whatsappUrl = Uri.parse('https://wa.me/$cleanPhone');
                                          
                                          if (await canLaunchUrl(whatsappUrl)) {
                                            await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                                          } else {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('WhatsApp is not installed'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Could not open WhatsApp'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF25D366),
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.chat, size: 12.sp, color: Colors.white),
                                          SizedBox(width: 2.w),
                                          Text(
                                            'WhatsApp',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  // IMO Button
                                  InkWell(
                                    onTap: () async {
                                      final phone = widget.storeData['store_contact_number'] ?? '';
                                      if (phone.isNotEmpty) {
                                        try {
                                          final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
                                          final imoUrl = Uri.parse('imo:$cleanPhone');
                                          
                                          if (await canLaunchUrl(imoUrl)) {
                                            await launchUrl(imoUrl, mode: LaunchMode.externalApplication);
                                          } else {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('IMO is not installed'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Could not open IMO'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF4B9EE3),
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.videocam, size: 12.sp, color: Colors.white),
                                          SizedBox(width: 2.w),
                                          Text(
                                            'IMO',
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                          ],
                        ),
                        // About Store section
                        if (widget.storeData['store_description'] != null) ...[
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              // color: Color(0xFF0B7F22).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _translate('About Store', 'দোকান সম্পর্কে'),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0B7F22),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  widget.storeData['store_description'],
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Color(0xFF0B7F22).withOpacity(0.8),
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                
                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: _translate('Search products in this store...', 'এই দোকানে পণ্য খুঁজুন...'),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: AppColors.button),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    ),
                    onChanged: (value) {
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
                                        _translate('No products found', 'কোন পণ্য পাওয়া যায়নি'),
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
                                content: Text('Filtering by: $categoryName'),
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
                                color: isSelected ? category['color'] : Colors.grey.shade300,
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
                                  color: isSelected ? Colors.white : category['color'],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  categoryName,
                                  style: TextStyle(
                                    fontSize: 12.sp,
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
                  
                  // Products Grid (Placeholder)
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
                                color: Colors.black.withOpacity(0.05),
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
                                  child: Icon(Icons.image, size: 40.sp, color: Colors.grey),
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
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '৳${(index + 1) * 100}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.button,
                                      ),
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
