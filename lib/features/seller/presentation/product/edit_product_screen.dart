import 'dart:io';

import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:final_year_project_frontend/networks/product_service.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
// ignore: unused_import
import 'package:final_year_project_frontend/networks/dio/dio.dart'; // check if needed for other things or just ensure imageUrl is available.
// imageUrl is top level in endpoints.dart, so importing endpoints.dart should suffice if it's exported.
// Re-checking endpoints.dart content.

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  // Form Fields
  String _name = '';
  String _stock = '';
  String _description = '';

  // Controllers for live updates
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;

  double _discountedPrice = 0.0;

  // Dropdown Selections
  String? _selectedCategory;
  String? _selectedDisease;
  String? _selectedStage;

  // Images
  // Existing thumbnail URL
  String? _existingThumbnail;
  // New thumbnail file
  File? _thumbnail;

  // New gallery images
  List<File> _newProductImages = [];
  // Existing gallery images
  List<dynamic> _existingProductImages = [];
  // Deleted existing image IDs
  final List<int> _deletedImageIds = [];

  // Data Sources (Same as AddProduct)
  final Map<String, String> _categories = {
    'all': 'All (সকল)',
    'fertilizer': 'Fertilizer (সার)',
    'pesticide': 'Pesticide (কীটনাশক)',
    'seed': 'Seed (বীজ)',
  };

  final Map<String, String> _growthStages = {
    'pre_planting': 'Pre-planting (বীজ বপনের পূর্বে)',
    'seeding': 'Seeding (বীজ বপন)',
    'germination': 'Germination (অঙ্কুরোদগম)',
    'seedling': 'Seedling (চারা অবস্থা)',
    'early_growth': 'Early Growth (প্রাথমিক বৃদ্ধি)',
    'vegetative': 'Vegetative (সক্রিয় বৃদ্ধি)',
    'flowering': 'Flowering (ফুল আসা)',
    'fruit_set': 'Fruit Set (ফল ধরা)',
    'fruit_development': 'Fruit Development (ফল বিকাশ)',
    'maturity': 'Maturity (পরিপক্বতা)',
    'harvest': 'Harvest (ফসল তোলা)',
    'all_stages': 'All Stages (সব পর্যায়)',
  };

  final Map<String, String> _diseases = {
    'chili_leaf_curl': 'Chili Curl Virus (মরিচের পাতা কোঁকড়ানো রোগ)',
    'chili_fungus_spot': 'Chili Fungus Spot (মরিচের পাতায় ছত্রাকের দাগ)',
    'chili_leaf_spot': 'Chili Leaf Spot (মরিচের পাতায় দাগ)',
    'chili_nutrition_deficiency':
        'Chili Nutrition Deficiency (মরিচে পুষ্টির অভাব)',
    'chili_white_spot': 'Chili White Spot (মরিচে সাদা দাগ)',
    'chili_whitefly': 'Chili Whitefly (মরিচে সাদা মাছি)',
    'chili_yellowish': 'Chili Yellowish (মরিচের পাতা হলুদ হয়ে যাওয়া)',
    'corn_common_rust': 'Corn Common Rust (ভুট্টায় মরচে)',
    'corn_gray_leaf_spot': 'Corn Gray Leaf Spot (ভুট্টার পাতায় ধূসর দাগ)',
    'corn_northern_leaf_blight':
        'Corn Northern Leaf Blight (ভুট্টার পাতায় পোড়া দাগ)',
    'corn_nutrient_deficiency': 'Corn User Deficiency (ভুট্টায় পুষ্টির অভাব)',
    'jute_mosaic': 'Jute Mosaic (পাটে মোজাইক রোগ)',
    'jute_cescospora': 'Jute Cescospora (পাটের পাতায় পোড়া দাগ)',
    'jute_nutrition_deficiency':
        'Jute Nutrition Deficiency (পাটে পুষ্টির অভাব)',
    'paddy_bacterial_blight': 'Paddy Bacterial Blight (ধানের পাতা পোড়া রোগ)',
    'paddy_brown_spot': 'Paddy Brown Spot (ধানের পাতায় বাদামী দাগ)',
    'paddy_leaf_smut': 'Paddy Leaf Smut (ধানের পাতায় কালো দাগ)',
    'paddy_hispa': 'Paddy Hispa (ধানের হিসপা পোকা)',
    'paddy_tungro': 'Paddy Tungro (ধানের টুংরো রোগ)',
    'potato_bacteria': 'Potato Bacteria (আলুর পঁচা রোগ)',
    'potato_early_blight': 'Potato Early Blight (আলুর আগের দাগ)',
    'potato_fungi': 'Potato Fungi (আলুর পাতায় ফাঙ্গাস)',
    'potato_late_blight': 'Potato Late Blight (আলুর শেষে দাগ)',
    'potato_pest': 'Potato Pest (আলুর পোকামাকড়)',
    'potato_virus': 'Potato Virus (আলুর ভাইরাস)',
  };

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final p = widget.product;

    _name = p['name'] ?? '';
    _stock = p['stock'].toString();
    _description = p['description'] ?? '';

    // Calculate initial discount percentage from price/discount_price or use discount field if available?
    // API has 'discount_price' and 'price'.
    // If we want to show 'Discount %' field, we need to reverse calc.
    // Or if API sends 'discount' field (percentage), use that. User said 'discount_price' is there.
    // Let's assume user wants to edit Price and Discount Percentage again.
    // We can try to calc percentage.
    double price = double.tryParse(p['price'].toString()) ?? 0.0;
    double discountPrice =
        double.tryParse(p['discount_price'].toString()) ?? 0.0;
    double discount = 0.0;

    // Check if 'discount' field exists in response (sometimes it's null or not there)
    // If not, calculate.
    if (p['discount'] != null) {
      discount = double.tryParse(p['discount'].toString()) ?? 0.0;
    } else {
      if (price > 0 && discountPrice < price) {
        discount = ((price - discountPrice) / price) * 100;
      }
    }

    _nameController = TextEditingController(text: _name);
    _priceController = TextEditingController(text: price.toString());
    _discountController = TextEditingController(
      text: discount.toInt().toString(),
    ); // Show int for cleaner UI
    _stockController = TextEditingController(text: _stock);
    _descriptionController = TextEditingController(text: _description);

    _selectedCategory = p['product_category'];
    _selectedStage = p['target_stage'];
    _selectedDisease = p['diseased_category'];

    // Map keys might need validation against our lists to avoid dropdown errors if API sends unknown key
    if (_selectedCategory != null &&
        !_categories.containsKey(_selectedCategory))
      _selectedCategory = null;
    if (_selectedStage != null && !_growthStages.containsKey(_selectedStage))
      _selectedStage = null;
    if (_selectedDisease != null && !_diseases.containsKey(_selectedDisease))
      _selectedDisease = null;

    _existingThumbnail = p['thumbnail'];

    if (p['product_images'] != null && p['product_images'] is List) {
      _existingProductImages = p['product_images'];
    }

    _calculateDiscountedPrice();
    _priceController.addListener(_calculateDiscountedPrice);
    _discountController.addListener(_calculateDiscountedPrice);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _calculateDiscountedPrice() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;

    setState(() {
      _discountedPrice = price - (price * discount / 100);
    });
  }

  Future<void> _submitProduct() async {
    if (_validateForm()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final result = await ProductService.updateProduct(
        id: widget.product['id'],
        name: _nameController.text,
        price: _priceController.text,
        discount: _discountController.text,
        stock: _stockController.text,
        description: _descriptionController.text,
        category: _selectedCategory!,
        targetStage: _selectedStage!,
        disease: _selectedDisease,
        thumbnail: _thumbnail, // Only sends if not null
        productImages: _newProductImages,
        deleteImageIds: _deletedImageIds,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product Updated Successfully!'),
              backgroundColor: AppColors.button,
            ),
          );
          Navigator.pop(context); // Go back
        } else {
          _showErrorSnackBar(result['message']);
        }
      }
    }
  }

  Future<void> _pickThumbnail() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _thumbnail = File(image.path);
        // If we pick new one, we hide existing one visually or replace it
      });
    }
  }

  Future<void> _pickProductImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _newProductImages.addAll(images.map((e) => File(e.path)));
      });
    }
  }

  void _removeNewProductImage(int index) {
    setState(() {
      _newProductImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      final img = _existingProductImages[index];
      if (img['id'] != null) {
        _deletedImageIds.add(img['id']);
      }
      _existingProductImages.removeAt(index);
    });
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;
    if (_selectedCategory == null) {
      _showErrorSnackBar('Please select a category');
      return false;
    }
    if (_selectedStage == null) {
      _showErrorSnackBar('Please select a growth stage');
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Product',
          style: TextFontStyle.textStyle20c3D4040EurostileW700Center.copyWith(
            color: Colors.black,
            fontSize: 20.sp,
          ),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail Section
              _buildSectionTitle('Product Thumbnail'),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: _pickThumbnail,
                child: Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cF2F0F0,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.cD5D5D5),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _thumbnail != null
                      ? Image.file(_thumbnail!, fit: BoxFit.cover)
                      : (_existingThumbnail != null
                            ? Image.network(
                                _existingThumbnail!.startsWith('http')
                                    ? _existingThumbnail!
                                    : '$imageUrl$_existingThumbnail',
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_rounded,
                                    size: 40.sp,
                                    color: AppColors.c8993A4,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Tap to upload new thumbnail',
                                    style: TextFontStyle
                                        .textStyle12c7E7E7Epoppins400,
                                  ),
                                ],
                              )),
                ),
              ),
              if (_thumbnail != null || _existingThumbnail != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _pickThumbnail,
                      icon: Icon(
                        Icons.edit,
                        size: 16.sp,
                        color: AppColors.button,
                      ),
                      label: Text(
                        "Change",
                        style: TextStyle(color: AppColors.button),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 24.h),

              // General Information
              _buildSectionTitle('General Information'),
              SizedBox(height: 16.h),
              _buildLabel('Product Name'),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter product name',
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
              ),
              SizedBox(height: 16.h),

              _buildLabel('Description'),
              _buildTextField(
                controller: _descriptionController,
                hint: 'Enter detailed description...',
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Description is required' : null,
              ),
              SizedBox(height: 24.h),

              // Categories & Stages
              _buildSectionTitle('Classification'),
              SizedBox(height: 16.h),
              _buildLabel('Category'),
              _buildDropdown(
                hint: 'Select Category',
                items: _categories,
                selectedKey: _selectedCategory,
                onSelected: (val) => setState(() => _selectedCategory = val),
              ),

              SizedBox(height: 16.h),

              _buildLabel('Growth Stage'),
              _buildDropdown(
                hint: 'Select Target Stage',
                items: _growthStages,
                selectedKey: _selectedStage,
                onSelected: (val) => setState(() => _selectedStage = val),
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Text(
                    "Is this for a specific disease?",
                    style: TextFontStyle.textStyle16c3D4040EurostileW500,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              _buildLabel('Target Disease (Optional)'),
              _buildDropdown(
                hint: 'Select Disease (if applicable)',
                items: _diseases,
                selectedKey: _selectedDisease,
                onSelected: (val) => setState(() => _selectedDisease = val),
              ),
              SizedBox(height: 24.h),

              // Pricing & Stock
              _buildSectionTitle('Pricing & Inventory'),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Price (৳)'),
                        _buildTextField(
                          controller: _priceController,
                          hint: '0.00',
                          inputType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Discount (%)'),
                        _buildTextField(
                          controller: _discountController,
                          hint: '0',
                          inputType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.button.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.button.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Final Price:",
                      style: TextFontStyle.textStyle16c3D4040EurostileW500,
                    ),
                    Text(
                      "৳ ${_discountedPrice.toStringAsFixed(2)}",
                      style: TextFontStyle.textStyle20c3D4040EurostileW700Center
                          .copyWith(color: AppColors.button),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              _buildLabel('Stock Quantity'),
              _buildTextField(
                controller: _stockController,
                hint: 'Available stock',
                inputType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 24.h),

              // Gallery (Adding new images only for now)
              _buildSectionTitle('Add New Images (Gallery)'),
              SizedBox(height: 10.h),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount:
                    _existingProductImages.length +
                    _newProductImages.length +
                    1,
                itemBuilder: (context, index) {
                  if (index ==
                      _existingProductImages.length +
                          _newProductImages.length) {
                    return GestureDetector(
                      onTap: _pickProductImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cF2F0F0,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.cD5D5D5),
                        ),
                        child: Icon(Icons.add, color: AppColors.c8993A4),
                      ),
                    );
                  }

                  // Existing Images
                  if (index < _existingProductImages.length) {
                    final imgData = _existingProductImages[index];
                    final imgUrl = imgData['image']; // based on API sample
                    final fullUrl = imgUrl.startsWith('http')
                        ? imgUrl
                        : '$imageUrl$imgUrl';

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                              image: NetworkImage(fullUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -5,
                          right: -5,
                          child: GestureDetector(
                            onTap: () => _removeExistingImage(index),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 10.r,
                              child: Icon(
                                Icons.close,
                                size: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // New Images
                  final newIndex = index - _existingProductImages.length;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: FileImage(_newProductImages[newIndex]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap: () => _removeNewProductImage(newIndex),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 10.r,
                            child: Icon(
                              Icons.close,
                              size: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 40.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Update Product',
                          style: TextFontStyle.textStyle14cFFFFFFpoppinw400
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                        ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextFontStyle.textStyle18c231F20poppins700.copyWith(
        color: AppColors.c3D4040,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextFontStyle.textStyle16c3D4040EurostileW500.copyWith(
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildTextField({
    String? hint,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      style: TextFontStyle.textStyle16c3D4040EurostileW500,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextFontStyle.textStyle16c8993A4EurostileField,
        filled: true,
        fillColor: AppColors.cF2F0F0,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required Map<String, String> items,
    required ValueChanged<String?> onSelected,
    String? hint,
    String? selectedKey,
  }) {
    // If selectedKey is not in the items, we can't show it as initialSelection.
    // However, we pre-washed keys in initState.

    return DropdownMenu<String>(
      width: double.infinity,
      initialSelection: selectedKey,
      hintText: hint,
      enableFilter: true,
      requestFocusOnTap: true,
      menuHeight: 300.h,
      textStyle: TextFontStyle.textStyle16c3D4040EurostileW500,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cF2F0F0,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      dropdownMenuEntries: items.entries.map((entry) {
        return DropdownMenuEntry<String>(
          value: entry.key,
          label: entry.value,
          style: MenuItemButton.styleFrom(
            textStyle: TextFontStyle.textStyle16c3D4040EurostileW500.copyWith(
              fontSize: 14.sp,
            ),
          ),
        );
      }).toList(),
      onSelected: onSelected,
    );
  }
}
