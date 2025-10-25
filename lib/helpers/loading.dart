import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:final_year_project_frontend/gen/colors.gen.dart';

import '../gen/assets.gen.dart';

Widget loadingIndicatorCircle({
  required BuildContext context,
  Color? color,
  double? size,
}) {
  double loaderSize = 100.sp;
  return DotLottieLoader.fromAsset(Assets.images.splashicom.path,
      frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
    if (dotlottie != null) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.cFFFFFF,
              borderRadius: BorderRadius.circular(8.r)),
          child: Lottie.memory(dotlottie.animations.values.single,
              height: loaderSize, width: loaderSize),
        ),
      );
    } else {
      return Container();
    }
  });
}

// Widget shimmer({
//   required BuildContext context,
//   double? height,
//   double? width,
// }) {
//   return Center(
//     child: Container(
//       width: width,
//       child:
//           Lottie.asset(Assets.json.shimmer, height: height, fit: BoxFit.fill),
//     ),
//   );
// }

// Widget noDataFound({
//   required BuildContext context,
//   Color? color,
//   double? size,
// }) {
//   double loaderSize = 250.sp;
//   return DotLottieLoader.fromAsset(Assets.animations.noData,
//       frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
//     if (dotlottie != null) {
//       return Center(
//         child: Container(
//           child: Lottie.memory(dotlottie.animations.values.single,
//               height: loaderSize, width: loaderSize),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   });
// }

// Widget errorData({
//   required BuildContext context,
//   Color? color,
//   double? size,
// }) {
//   double loaderSize = 250.sp;
//   return DotLottieLoader.fromAsset(Assets.animations.error,
//       frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
//     if (dotlottie != null) {
//       return Center(
//         child: Container(
//           child: Lottie.memory(dotlottie.animations.values.single,
//               height: loaderSize, width: loaderSize),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   });
// }
