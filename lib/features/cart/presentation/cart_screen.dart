import 'package:final_year_project_frontend/constants/app_constants.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/cart_service.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:final_year_project_frontend/features/profile/presentation/profile_screen.dart';
import 'package:final_year_project_frontend/networks/profile_service.dart';
import 'package:get_storage/get_storage.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, dynamic>? _cartData;
  bool _isLoading = true;
  String? _error;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadCart();
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

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await CartService.getCart();

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result['success']) {
            _cartData = result['data'];
          } else {
            _error = result['message'];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load cart';
        });
      }
    }
  }

  Future<void> _updateQuantity(int cartItemId, int quantity) async {
    // Show loading indicator or optimistic update could be done here
    // For now, let's just show a loading dialog or simply wait
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: AppColors.button)),
    );

    try {
      final result = await CartService.updateCartItem(
        cartItemId: cartItemId,
        quantity: quantity,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        if (result['success']) {
          _loadCart(); // Refresh cart to get updated totals
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to update quantity'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating quantity')));
      }
    }
  }

  Future<void> _clearCart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_translate('Clear Cart', 'কার্ট খালি করুন')),
        content: Text(
          _translate(
            'Are you sure you want to remove all items?',
            'আপনি কি নিশ্চিত যে আপনি সমস্ত আইটেম সরাতে চান?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_translate('Cancel', 'বাতিল')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              _translate('Clear', 'খালি করুন'),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: AppColors.button)),
    );

    try {
      final result = await CartService.clearCart();
      if (mounted) {
        Navigator.pop(context); // Close loading
        if (result['success']) {
          _loadCart();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to clear cart'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error clearing cart')));
      }
    }
  }

  Future<void> _removeItem(int cartItemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_translate('Remove Item', 'আইটেম সরান')),
        content: Text(
          _translate(
            'Are you sure you want to remove this item?',
            'আপনি কি নিশ্চিত যে আপনি এই আইটেমটি সরাতে চান?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_translate('Cancel', 'বাতিল')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              _translate('Remove', 'সরান'),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: AppColors.button)),
    );

    try {
      final result = await CartService.removeFromCart(cartItemId);
      if (mounted) {
        Navigator.pop(context); // Close loading
        if (result['success']) {
          _loadCart();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to remove item'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error removing item')));
      }
    }
  }

  Future<void> _placeOrder({int? sellerId}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: AppColors.button)),
    );

    try {
      final result = await CartService.placeOrder(sellerId: sellerId);

      if (mounted) {
        Navigator.pop(context); // Close loading

        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Order placed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadCart();
        } else {
          // Check for specific profile completion error
          if (result['message'] ==
              "Please complete your profile with name and phone number") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message']),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Update Profile',
                  textColor: Colors.yellow,
                  onPressed: () async {
                    // Trigger profile update navigation
                    await _navigateToProfileUpdate();
                  },
                ),
              ),
            );

            // Create a slight delay before auto-navigating if user doesn't click action
            // Or just navigate immediately? User said "this redrect profile update pages"
            await _navigateToProfileUpdate();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Failed to place order'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error placing order')));
      }
    }
  }

  Future<void> _navigateToProfileUpdate() async {
    // Fetch profile first to get data
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: AppColors.button)),
    );

    final role = GetStorage().read(kKeyRole) ?? 'customer'; // Default role
    final profileResult = await ProfileService.getProfile(role: role);

    if (mounted) {
      Navigator.pop(context); // Close loading

      if (profileResult['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(userData: profileResult['data'], role: role),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile for update')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          _translate('My Cart', 'আমার কার্ট'),
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.button),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red),
            onPressed:
                (_cartData?['seller_wise_items'] as List?)?.isEmpty == true
                ? null
                : _clearCart,
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.button));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              _error!,
              style: TextStyle(color: Colors.red, fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
              ),
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final sellerSections =
        (_cartData?['seller_wise_items'] as List<dynamic>?) ?? [];

    if (sellerSections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              _translate('Your cart is empty', 'আপনার কার্ট খালি'),
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: sellerSections.length,
      itemBuilder: (context, index) {
        return _buildSellerSection(sellerSections[index]);
      },
    );
  }

  Widget _buildSellerSection(Map<String, dynamic> section) {
    final seller = section['seller'] ?? {};
    final items = (section['items'] as List<dynamic>?) ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seller Header
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundImage: seller['avatar'] != null
                      ? NetworkImage('$imageUrl${seller['avatar']}')
                      : null,
                  child: seller['avatar'] == null
                      ? Icon(Icons.store, size: 16.r)
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seller['store_name'] ?? 'Unknown Store',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        seller['name'] ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Items
          ...items.map((item) => _buildCartItem(item)),
          // Seller Total & Checkout
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _translate('Subtotal', 'উপমোট'),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      '৳${section['total_price']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _placeOrder(sellerId: seller['id']);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.button,
                      side: BorderSide(color: AppColors.button),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      _translate(
                        'Place Order from this Store',
                        'এই দোকান থেকে অর্ডার করুন',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
        children: [
          // Product Image
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey[100],
            ),
            child: item['product_thumbnail'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      '$imageUrl${item['product_thumbnail']}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : Icon(Icons.image_not_supported, color: Colors.grey),
          ),
          SizedBox(width: 12.w),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['product_name'] ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Price: ৳${item['product_price']}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if ((item['quantity'] ?? 1) > 1) {
                              _updateQuantity(
                                item['id'],
                                (item['quantity'] ?? 1) - 1,
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            '${item['quantity'] ?? 1}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _updateQuantity(
                              item['id'],
                              (item['quantity'] ?? 1) + 1,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.button),
                              borderRadius: BorderRadius.circular(4.r),
                              color: AppColors.button,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '৳${item['subtotal']}',
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
          IconButton(
            onPressed: () => _removeItem(item['id']),
            icon: Icon(Icons.close, color: Colors.grey, size: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomBar() {
    if (_isLoading ||
        _error != null ||
        (_cartData?['seller_wise_items'] as List?)?.isEmpty == true) {
      return null;
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _translate('Total', 'মোট'),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '৳${_cartData?['total_price'] ?? 0}',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.button,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _placeOrder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                _translate('Place Order All', 'সব অর্ডার করুন'),
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
    );
  }
}
