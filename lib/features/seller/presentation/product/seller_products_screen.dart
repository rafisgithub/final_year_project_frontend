import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/product/add_product_screen.dart';
import 'package:final_year_project_frontend/networks/product_service.dart';
import 'package:final_year_project_frontend/features/seller/presentation/product/edit_product_screen.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';

class SellerProductsScreen extends StatefulWidget {
  const SellerProductsScreen({super.key});

  @override
  State<SellerProductsScreen> createState() => _SellerProductsScreenState();
}

class _SellerProductsScreenState extends State<SellerProductsScreen> {
  // Data Lists
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _diseasedCategories = [];
  List<Map<String, dynamic>> _targetStages = [];

  final TextEditingController _searchController = TextEditingController();

  // Debounce for search
  Timer? _debounce;

  // Filter States
  String _selectedCategoryKey = 'all';
  String _selectedDiseaseKey = 'all';
  String _selectedStageKey = 'all_stages';

  bool _isLoading = true;
  bool _isProductsLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllFilters();
    _fetchProducts();
  }

  Future<void> _fetchAllFilters() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        ProductService.getProductCategories(),
        ProductService.getDiseasedCategories(),
        ProductService.getTargetStages(),
      ]);

      if (mounted) {
        setState(() {
          // Process Categories
          if (results[0]['success']) {
            _categories = List<Map<String, dynamic>>.from(results[0]['data']);
            if (!_categories.any((element) => element['key'] == 'all')) {
              _categories.insert(0, {'key': 'all', 'value': 'All Categories'});
            }
          }

          // Process Diseases
          if (results[1]['success']) {
            _diseasedCategories = List<Map<String, dynamic>>.from(
              results[1]['data'],
            );
            _diseasedCategories.insert(0, {
              'key': 'all',
              'value': 'All Diseases (সব রোগ)',
            });
          }

          // Process Stages
          if (results[2]['success']) {
            _targetStages = List<Map<String, dynamic>>.from(results[2]['data']);
            if (!_targetStages.any(
              (element) => element['key'] == 'all_stages',
            )) {
              _targetStages.insert(0, {
                'key': 'all_stages',
                'value': 'All Stages',
              });
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load filters')));
      }
    }
  }

  Future<void> _fetchProducts() async {
    if (!mounted) return;
    setState(() => _isProductsLoading = true);

    try {
      final response = await ProductService.getSellerProducts(
        name: _searchController.text,
        category: _selectedCategoryKey,
        disease: _selectedDiseaseKey,
        stage: _selectedStageKey,
      );

      if (mounted) {
        if (response['success']) {
          setState(() {
            _products = List<Map<String, dynamic>>.from(response['data']);
          });
        } else {
          // Optionally show error for products fetch, or just empty list
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() => _isProductsLoading = false);
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchProducts();
    });
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildDropdownFilter(
    String hint,
    List<Map<String, dynamic>> items,
    String? selectedKey,
    Function(String?) onSelected,
  ) {
    final menuEntries = items.map((item) {
      return DropdownMenuEntry<String>(
        value: item['key'],
        label: item['value'],
      );
    }).toList();

    return DropdownMenu<String>(
      initialSelection: selectedKey,
      label: Text(hint),
      dropdownMenuEntries: menuEntries,
      onSelected: onSelected,
      width: 320.w,
      enableFilter: true, // Enable search
      menuHeight: 300.h,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.c3D4040,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cF2F0F0,
      appBar: AppBar(
        title: Text(
          'My Products',
          style: TextFontStyle.textStyle20c3D4040EurostileW700Center,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  style: TextStyle(
                    fontFamily: 'Eurostile',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.c3D4040,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search your products...',
                    hintStyle: TextStyle(
                      fontFamily: 'Eurostile',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.c8993A4,
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.c8993A4),
                    filled: true,
                    fillColor: AppColors.cF2F0F0,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                  ),
                  onChanged: _onSearchChanged,
                ),
                SizedBox(height: 16.h),

                // Filters
                _isLoading
                    ? Center(
                        child: LinearProgressIndicator(color: AppColors.button),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: _buildDropdownFilter(
                              'Category',
                              _categories,
                              _selectedCategoryKey,
                              (value) {
                                setState(
                                  () => _selectedCategoryKey = value ?? 'all',
                                );
                                _fetchProducts();
                              },
                            ),
                          ),
                          SizedBox(height: 12.h),

                          if (_selectedCategoryKey != 'all') ...[
                            Center(
                              child: _buildDropdownFilter(
                                'Target Stage',
                                _targetStages,
                                _selectedStageKey,
                                (value) {
                                  setState(
                                    () => _selectedStageKey =
                                        value ?? 'all_stages',
                                  );
                                  _fetchProducts();
                                },
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Center(
                              child: _buildDropdownFilter(
                                'Target Disease',
                                _diseasedCategories,
                                _selectedDiseaseKey,
                                (value) {
                                  setState(
                                    () => _selectedDiseaseKey = value ?? 'all',
                                  );
                                  _fetchProducts();
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
              ],
            ),
          ),

          if (_isProductsLoading)
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.button),
              ),
            ),

          Expanded(
            child: !_isProductsLoading && _products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64.sp,
                          color: AppColors.c8993A4,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No products found',
                          style: TextFontStyle.textStyle16c8993A4EurostileField,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _products.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      return _buildProductCard(product);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
          // Refresh list when coming back
          _fetchProducts();
        },
        backgroundColor: AppColors.button,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add Product",
          style: TextFontStyle.textStyle14cFFFFFFpoppinw400.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final double price = double.tryParse(product['price'].toString()) ?? 0.0;
    final double discountPrice =
        double.tryParse(product['discount_price'].toString()) ?? 0.0;

    // Calculate percentage for badge
    double discountPercentage = 0.0;
    if (price > 0 && discountPrice < price) {
      discountPercentage = ((price - discountPrice) / price) * 100;
    }

    final bool hasDiscount = discountPercentage > 0;

    // Construct thumbnail ImageProvider
    ImageProvider? thumbnailProvider;
    if (product['thumbnail'] != null) {
      String thumbPath = product['thumbnail'];
      if (thumbPath.startsWith('http')) {
        thumbnailProvider = NetworkImage(thumbPath);
      } else {
        if (thumbPath.startsWith('assets/')) {
          thumbnailProvider = AssetImage(thumbPath);
        } else {
          thumbnailProvider = NetworkImage('$imageUrl$thumbPath');
        }
      }
    }

    return GestureDetector(
      onTap: () {
        // Swallow taps on the card to prevent unwanted navigation
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.cF2F0F0,
                  borderRadius: BorderRadius.circular(12.r),
                  image: thumbnailProvider != null
                      ? DecorationImage(
                          image: thumbnailProvider,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: thumbnailProvider == null
                    ? Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.c8993A4,
                      )
                    : null,
              ),
              SizedBox(width: 12.w),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product['name'],
                            style: TextStyle(
                              fontFamily: 'Eurostile',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.c3D4040,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.more_vert,
                              size: 20.sp,
                              color: AppColors.c8993A4,
                            ),
                            onSelected: (value) async {
                              if (value == 'edit') {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (c) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                final result =
                                    await ProductService.getProductForEdit(
                                      product['id'],
                                    );
                                Navigator.pop(context); // Close loading

                                if (result['success']) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProductScreen(
                                        product: result['data'],
                                      ),
                                    ),
                                  );
                                  _fetchProducts(); // Refresh after edit
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['message'])),
                                  );
                                }
                              } else if (value == 'delete') {
                                _showDeleteConfirmationDialog(
                                  context,
                                  product['id'],
                                );
                              } else if (value == 'update_stock') {
                                _showUpdateStockDialog(context, product);
                              }
                            },
                            color: Colors.white,
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 18.sp,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.c3D4040,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'update_stock',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.inventory,
                                        size: 18.sp,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Update Stock',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.c3D4040,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        size: 18.sp,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.c3D4040,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Category & Stock
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.button.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            _capitalize(product['product_category'] ?? ''),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.button,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Stock: ${product['stock']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.c8993A4,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Pricing
                    Row(
                      children: [
                        Text(
                          '৳${discountPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.button,
                            fontFamily: 'Eurostile',
                          ),
                        ),
                        if (hasDiscount) ...[
                          SizedBox(width: 6.w),
                          Text(
                            '৳${price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.c8993A4,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '-${discountPercentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
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
        ),
      ),
    );
  }

  void _showUpdateStockDialog(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    final TextEditingController _stockController = TextEditingController(
      text: product['stock'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Update Stock",
          style: TextStyle(
            fontFamily: 'Eurostile',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.c3D4040,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Stock: ${product['stock']}",
              style: TextStyle(fontSize: 14.sp, color: AppColors.c8993A4),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "New Stock Quantity",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newStock = int.tryParse(_stockController.text);
              if (newStock != null) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (c) => Center(child: CircularProgressIndicator()),
                );

                final result = await ProductService.updateStock(
                  productId: product['id'],
                  stock: newStock,
                );

                Navigator.pop(context);

                if (result['success']) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result['message'])));
                  _fetchProducts();
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result['message'])));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invalid stock quantity")),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.button),
            child: Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Product",
          style: TextStyle(
            fontFamily: 'Eurostile',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.c3D4040,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this product? This action cannot be undone.",
          style: TextStyle(fontSize: 14.sp, color: AppColors.c3D4040),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppColors.c8993A4)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context); // Close confirm dialog

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (c) => Center(child: CircularProgressIndicator()),
              );

              final result = await ProductService.deleteProduct(productId);

              if (result['success']) {
                // Close loading and maybe wait a bit/refresh
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(result['message'])));
                _fetchProducts();
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(result['message'])));
              }
            },
            child: Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
