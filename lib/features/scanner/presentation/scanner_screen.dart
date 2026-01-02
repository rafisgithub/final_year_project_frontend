import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

import 'dart:io';
import 'package:final_year_project_frontend/features/scanner/data/ai_service.dart';
import 'package:final_year_project_frontend/features/scanner/data/disease_response_model.dart';
import 'package:final_year_project_frontend/constants/text_font_style.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart'; // For imageUrl
import 'package:final_year_project_frontend/features/product/presentation/product_details_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isFlashOn = false;

  // Add a loading state specifically for AI processing
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        if (mounted) {
          setState(() {
            _errorMessage = 'No cameras found on this device';
            _isLoading = false;
          });
        }
        return;
      }

      // Use back camera (index 0)
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize camera: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isProcessing) {
      return;
    }

    try {
      final XFile image = await _cameraController!.takePicture();

      if (mounted) {
        setState(() {
          _isProcessing = true;
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Processing image...'),
        //     backgroundColor: AppColors.button,
        //     duration: Duration(seconds: 1),
        //   ),
        // );

        // Process the image for disease detection
        final result = await AiService.detectDisease(File(image.path));

        setState(() {
          _isProcessing = false;
        });

        if (result['success']) {
          final response = result['data'] as DiseaseDetectionResponse;
          if (response.data != null) {
            _showResultBottomSheet(response.data!);
          } else {
            _showErrorSnackBar('No disease data found.');
          }
        } else {
          _showErrorSnackBar(result['message'] ?? 'Failed to detect disease.');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        _showErrorSnackBar('Error taking picture: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showResultBottomSheet(DiseaseData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Indicator
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Disease Name
                  Text(
                    'Detected Disease',
                    style: TextFontStyle.textStyle16c8993A4EurostileW400
                        .copyWith(fontSize: 14.sp, color: AppColors.c7E7E7E),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    data.disease?.replaceAll('__', ' ').replaceAll('_', ' ') ??
                        'Unknown',
                    style: TextFontStyle.textStyle24c3D4040EurostileW700
                        .copyWith(color: AppColors.button, fontSize: 24.sp),
                  ),

                  // Confidence
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.button.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Confidence: ${data.confidence?.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: AppColors.button,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                  Divider(),
                  SizedBox(height: 16.h),

                  // Products Header
                  Text(
                    'Recommended Products',
                    style: TextFontStyle.textStyle20c3D4040EurostileW700Center
                        .copyWith(
                          fontSize: 18.sp,
                          // textAlign: TextAlign.left,
                        ),
                  ),
                  SizedBox(height: 16.h),

                  // Products List
                  if (data.products != null && data.products!.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.products!.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final product = data.products![index];
                        return GestureDetector(
                          onTap: () {
                            if (product.id != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    productId: product.id!,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                // Product Image
                                if (product.thumbnail != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      // Handle if thumbnail already has full URL or needs base URL
                                      product.thumbnail!.startsWith('http')
                                          ? product.thumbnail!
                                          : '$imageUrl${product.thumbnail}',
                                      width: 60.w,
                                      height: 60.w,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 60.w,
                                                height: 60.w,
                                                color: Colors.grey[200],
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    ),
                                  )
                                else
                                  Container(
                                    width: 60.w,
                                    height: 60.w,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                    ),
                                  ),

                                SizedBox(width: 12.w),

                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name ?? 'Unknown Product',
                                        style: TextFontStyle
                                            .textStyle16c3D4040EurostileW500
                                            .copyWith(fontSize: 15.sp),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Price: ${product.price ?? 'N/A'}',
                                        style: TextStyle(
                                          color: AppColors.c7E7E7E,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      if (product.discountPrice != null)
                                        Text(
                                          'Discount: ${product.discountPrice}',
                                          style: TextStyle(
                                            color: AppColors.button,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.sp,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: Text("No recommended products found."),
                      ),
                    ),

                  SizedBox(height: 20.h),
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Optionally resume camera or reset state
                        _initializeCamera();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text('Done', style: TextStyle(fontSize: 16.sp)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // Re-initialize camera when bottom sheet closes if needed to resume preview
      // _initializeCamera();
      // Note: Camera might still be active in background, but often previews pause.
      // If preview freezes, we might need to resume it.
    });
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.button),
                  SizedBox(height: 16.h),
                  Text(
                    'Initializing camera...',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ],
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 64.sp),
                    SizedBox(height: 16.h),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });
                        _initializeCamera();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.button,
                      ),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_isCameraInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _cameraController!.value.previewSize!.height,
                  height: _cameraController!.value.previewSize!.width,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),

          // Loading Overlay during processing
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.button),
                    SizedBox(height: 16.h),
                    Text(
                      'Analyzing Crop...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Please wait',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),

          // Top Bar
          if (!_isProcessing)
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      'Scan Crop Leaf',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                        onPressed: _toggleFlash,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Camera Frame/Guide
          if (_isCameraInitialized && !_isProcessing)
            Center(
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.button, width: 3),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.eco,
                      color: AppColors.button.withOpacity(0.3),
                      size: 80.sp,
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Instructions and Capture Button
          if (!_isProcessing)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Text(
                        'Position the leaf within the frame',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Gallery Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                              onPressed: () {
                                // TODO: Open gallery
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Gallery feature coming soon',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 40.w),
                          // Capture Button
                          GestureDetector(
                            onTap: _isCameraInitialized ? _takePicture : null,
                            child: Container(
                              width: 70.w,
                              height: 70.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                color: AppColors.button,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 32.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 40.w),
                          // Switch Camera Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.flip_camera_android,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                              onPressed: () {
                                // TODO: Switch camera
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Camera switch coming soon'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
