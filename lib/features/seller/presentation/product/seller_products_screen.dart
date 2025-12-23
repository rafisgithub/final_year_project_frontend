import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/features/seller/presentation/product/add_product_screen.dart';
import 'package:final_year_project_frontend/networks/product_service.dart';

class SellerProductsScreen extends StatefulWidget {
  const SellerProductsScreen({super.key});

  @override
  State<SellerProductsScreen> createState() => _SellerProductsScreenState();
}

class _SellerProductsScreenState extends State<SellerProductsScreen> {
  // Dummy products list with new fields for testing
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Fresh Apple',
      'price': '180',
      'stock': '50',
      'image': 'assets/images/apple.png',
      'category': 'fertilizer',
      'diseased_category': 'chili_leaf_curl',
      'target_stage': 'seeding',
    },
    {
      'name': 'Banana',
      'price': '60',
      'stock': '120',
      'image': 'assets/images/banana.png',
      'category': 'fertilizer',
      'diseased_category': 'chili_healthy',
      'target_stage': 'harvest',
    },
    {
      'name': 'Fertilizer A',
      'price': '500',
      'stock': '20',
      'image': 'assets/images/apple.png',
      'category': 'fertilizer',
      'diseased_category': 'corn_common_rust',
      'target_stage': 'seeding',
    },
    {
      'name': 'Potato',
      'price': '40',
      'stock': '100',
      'image': 'assets/images/potato.png',
      'category': 'seed',
      'diseased_category': 'potato_early_blight',
      'target_stage': 'germination',
    },
    {
      'name': 'Tomato',
      'price': '80',
      'stock': '80',
      'image': 'assets/images/tomato.png',
      'category': 'pesticide',
      'diseased_category': 'chili_leaf_curl',
      'target_stage': 'flowering',
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  // Filter States
  String _selectedCategoryKey = 'all';
  String _selectedDiseaseKey =
      'all'; // Assuming 'all' meant "All Diseases" or similar
  String _selectedStageKey = 'all';

  // Data Lists
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _diseasedCategories = [];
  List<Map<String, dynamic>> _targetStages = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllFilters();
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
          }

          // Process Diseases
          if (results[1]['success']) {
            _diseasedCategories = List<Map<String, dynamic>>.from(
              results[1]['data'],
            );
            _diseasedCategories.insert(0, {'key': 'all', 'value': 'সব রোগ'});
          }

          // Process Stages
          if (results[2]['success']) {
            _targetStages = List<Map<String, dynamic>>.from(results[2]['data']);
            // Check if 'all_stages' is already there or we need 'all' key
            // The API example showed "all_stages". We might need to handle 'all' logic manually if the key is 'all_stages' for "All"
            // But my internal logic uses 'all'. Let's see.
            // If API returns a specific "All Key", I should use that.
            // API returned "all_stages". I'll default my selection to that if it exists, otherwise 'all'

            // Check if API already has an 'All' option.
            // Categories had 'all'.
            // Stages had 'all_stages'.
            // Diseases example didn't explicitly show 'all' but it's safe to add one locally for "No Filter"

            _selectedStageKey = 'all_stages'; // As per API response
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

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch = product['name'].toString().toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );

      final matchesCategory =
          _selectedCategoryKey == 'all' ||
          product['category'] == _selectedCategoryKey;

      final matchesDisease =
          _selectedDiseaseKey == 'all' ||
          product['diseased_category'] == _selectedDiseaseKey;

      final matchesStage =
          _selectedStageKey == 'all_stages' || // Matches API's "All" key
          _selectedStageKey == 'all' || // Fallback
          product['target_stage'] == _selectedStageKey;

      return matchesSearch && matchesCategory && matchesDisease && matchesStage;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  Widget _buildFilterSection(
    String title,
    List<Map<String, dynamic>> items,
    String selectedKey,
    Function(String) onSelected,
    bool isEnglish,
  ) {
    if (items.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items.map((item) {
              final key = item['key'];
              final value = item['value'];
              final isSelected = selectedKey == key;

              final label = isEnglish
                  ? _capitalize(key.toString())
                  : value.toString();

              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (selected) => onSelected(key),
                  backgroundColor: Colors.grey[100],
                  selectedColor: AppColors.button.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.button : Colors.grey[800],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: isSelected ? AppColors.button : Colors.transparent,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check language
    final isEnglish = GetStorage().read(kKeyLanguage) == kKeyEnglish;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Products',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 16.h),

                // Filters
                _isLoading
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: AppColors.button,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterSection(
                            'Category',
                            _categories,
                            _selectedCategoryKey,
                            (key) => setState(() => _selectedCategoryKey = key),
                            isEnglish,
                          ),
                          _buildFilterSection(
                            'Disease',
                            _diseasedCategories,
                            _selectedDiseaseKey,
                            (key) => setState(() => _selectedDiseaseKey = key),
                            isEnglish,
                          ),
                          _buildFilterSection(
                            'Stage',
                            _targetStages,
                            _selectedStageKey,
                            (key) => setState(() => _selectedStageKey = key),
                            isEnglish,
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64.sp,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _filteredProducts.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Product Image Placeholder
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Stock: ${product['stock']}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 4,
                                    children: [
                                      Text(
                                        product['category'],
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: AppColors.button,
                                        ),
                                      ),
                                      Text(
                                        '|',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        product['diseased_category']
                                            .toString()
                                            .replaceAll('_', ' '),
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '৳ ${product['price']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.button,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        size: 20.sp,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {},
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                    ),
                                    SizedBox(width: 8.w),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        size: 20.sp,
                                        color: AppColors.button,
                                      ),
                                      onPressed: () {},
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Product Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
        backgroundColor: AppColors.button,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
