import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:final_year_project_frontend/networks/dio/dio.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';

class ProductService {
  // Get product details by ID
  static Future<Map<String, dynamic>> getProductDetails(int productId) async {
    try {
      if (kDebugMode) {
        print('Fetching product details for ID: $productId');
      }

      final response = await getHttp(
        '${Endpoints.productDetails}$productId/',
        null,
      );

      if (kDebugMode) {
        print('Product Details Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Product details retrieved successfully',
            'data': responseData['data'],
          };
        } else {
          return {
            'success': false,
            'message':
                responseData['message'] ?? 'Failed to load product details',
            'data': null,
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'data': null,
        };
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Product Details Error: ${e.message}');
        print('Error Response: ${e.response?.data}');
      }

      String errorMessage = 'Failed to load product details';

      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      }

      return {'success': false, 'message': errorMessage, 'data': null};
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'data': null,
      };
    }
  }

  // Get product categories
  static Future<Map<String, dynamic>> getProductCategories() async {
    try {
      final response = await getHttp(Endpoints.productCategories, null);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Product categories retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load categories'};
    } catch (e) {
      return {'success': false, 'message': 'Error fetching categories'};
    }
  }

  // Get diseased categories
  static Future<Map<String, dynamic>> getDiseasedCategories() async {
    try {
      final response = await getHttp(Endpoints.diseasedCategories, null);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Diseased categories retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {
        'success': false,
        'message': 'Failed to load diseased categories',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching diseased categories',
      };
    }
  }

  // Get target stages
  static Future<Map<String, dynamic>> getTargetStages() async {
    try {
      final response = await getHttp(Endpoints.targetStages, null);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ??
                'Target stages retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load target stages'};
    } catch (e) {
      return {'success': false, 'message': 'Error fetching target stages'};
    }
  }

  // Get product details for editing
  static Future<Map<String, dynamic>> getProductForEdit(int productId) async {
    try {
      final response = await getHttp(
        '${Endpoints.editProduct}$productId/',
        null,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Product retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {'success': false, 'message': 'Failed to load product details'};
    } catch (e) {
      if (kDebugMode) {
        print('Get Product For Edit Error: $e');
      }
      return {'success': false, 'message': 'Error fetching product details'};
    }
  }

  // Add Product
  static Future<Map<String, dynamic>> addProduct({
    required String name,
    required String price,
    required String discount,
    required String stock,
    required String description,
    required String category,
    required String targetStage,
    String? disease,
    File? thumbnail,
    List<File>? productImages,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'price': price,
        'discount': discount,
        'stock': stock,
        'description': description,
        'product_category': category,
        'target_stage': targetStage,
        if (disease != null && disease.isNotEmpty) 'diseased_category': disease,
      });

      if (thumbnail != null) {
        formData.files.add(
          MapEntry(
            'thumbnail',
            await MultipartFile.fromFile(
              thumbnail.path,
              filename: thumbnail.path.split('/').last,
            ),
          ),
        );
      }

      if (productImages != null && productImages.isNotEmpty) {
        for (var file in productImages) {
          formData.files.add(
            MapEntry(
              'product_images[]',
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await postHttpFormData(Endpoints.addProduct, formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Product added successfully',
            'data': responseData['data'],
          };
        }
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to add product',
      };
    } on DioException catch (e) {
      String errorMessage = 'Failed to add product';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      if (kDebugMode) {
        print('Add Product Error: $e');
      }
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  // Get Seller Products
  static Future<Map<String, dynamic>> getSellerProducts({
    String? name,
    String? category,
    String? disease,
    String? stage,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (name != null && name.isNotEmpty) queryParams['name'] = name;
      if (category != null && category != 'all') {
        queryParams['product_category'] = category;
      }
      if (disease != null && disease != 'all') {
        queryParams['diseased_category'] = disease;
      }
      if (stage != null && stage != 'all_stages' && stage != 'all') {
        queryParams['target_stage'] = stage;
      }

      final response = await getHttp(Endpoints.sellerProducts, queryParams);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Products retrieved successfully',
            'data': responseData['data'],
          };
        }
      }
      return {
        'success': false,
        'message': 'Failed to load products',
        'data': [],
      };
    } catch (e) {
      if (kDebugMode) {
        print('Get Seller Products Error: $e');
      }
      return {
        'success': false,
        'message': 'Error loading products',
        'data': [],
      };
    }
  }

  // Update Product Stock
  static Future<Map<String, dynamic>> updateStock({
    required int productId,
    required int stock,
  }) async {
    try {
      final data = {'stock': stock};

      final response = await patchHttp(
        '${Endpoints.updateStock}$productId/',
        data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message': responseData['message'] ?? 'Stock updated successfully',
          };
        }
      }
      return {'success': false, 'message': 'Failed to update stock'};
    } catch (e) {
      if (kDebugMode) {
        print('Update Stock Error: $e');
      }
      return {'success': false, 'message': 'Error updating stock'};
    }
  }

  // Update Product (PUT)
  static Future<Map<String, dynamic>> updateProduct({
    required int id,
    required String name,
    required String price,
    required String discount,
    required String stock,
    required String description,
    required String category,
    required String targetStage,
    String? disease,
    File? thumbnail,
    List<File>? productImages,
    List<int>? deleteImageIds,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'price': price,
        'discount': discount,
        'stock': stock,
        'description': description,
        'product_category': category,
        'target_stage': targetStage,
        if (disease != null && disease.isNotEmpty) 'diseased_category': disease,
      });

      if (deleteImageIds != null && deleteImageIds.isNotEmpty) {
        for (var id in deleteImageIds) {
          formData.fields.add(
            MapEntry('delete_product_images[]', id.toString()),
          );
        }
      }

      if (thumbnail != null) {
        formData.files.add(
          MapEntry(
            'thumbnail',
            await MultipartFile.fromFile(
              thumbnail.path,
              filename: thumbnail.path.split('/').last,
            ),
          ),
        );
      }

      if (productImages != null && productImages.isNotEmpty) {
        for (var file in productImages) {
          formData.files.add(
            MapEntry(
              'product_images[]',
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await putHttpFormData(
        '${Endpoints.updateProduct}$id/',
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Product updated successfully',
            'data': responseData['data'],
          };
        }
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to update product',
      };
    } on DioException catch (e) {
      String errorMessage = 'Failed to update product';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      if (kDebugMode) {
        print('Update Product Error: $e');
      }
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  // Delete Product
  static Future<Map<String, dynamic>> deleteProduct(int productId) async {
    try {
      final response = await deleteHttp(
        '${Endpoints.productDelete}$productId/',
        null,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Product deleted successfully',
          };
        }
      }
      return {'success': false, 'message': 'Failed to delete product'};
    } catch (e) {
      if (kDebugMode) {
        print('Delete Product Error: $e');
      }
      return {'success': false, 'message': 'Error deleting product'};
    }
  }
}
