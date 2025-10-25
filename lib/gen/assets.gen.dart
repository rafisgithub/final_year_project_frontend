// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsColorGen {
  const $AssetsColorGen();

  /// File path: assets/color/colors.xml
  String get colors => 'assets/color/colors.xml';

  /// File path: assets/color/sheikhfahmidisl_flutter.code-workspace
  String get sheikhfahmidislFlutter =>
      'assets/color/sheikhfahmidisl_flutter.code-workspace';

  /// List of all assets
  List<String> get values => [colors, sheikhfahmidislFlutter];
}

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/EuroStyleNormal.ttf
  String get euroStyleNormal => 'assets/fonts/EuroStyleNormal.ttf';

  /// File path: assets/fonts/EurostarBlack.ttf
  String get eurostarBlack => 'assets/fonts/EurostarBlack.ttf';

  /// File path: assets/fonts/EurostarRegular.ttf
  String get eurostarRegular => 'assets/fonts/EurostarRegular.ttf';

  /// File path: assets/fonts/Gotham-Black.otf
  String get gothamBlack => 'assets/fonts/Gotham-Black.otf';

  /// File path: assets/fonts/Gotham-Book.ttf
  String get gothamBook => 'assets/fonts/Gotham-Book.ttf';

  /// File path: assets/fonts/Gotham-Font.zip
  String get gothamFont => 'assets/fonts/Gotham-Font.zip';

  /// File path: assets/fonts/Gotham-Light.ttf
  String get gothamLight => 'assets/fonts/Gotham-Light.ttf';

  /// File path: assets/fonts/GothamRnd-Bold.otf
  String get gothamRndBold => 'assets/fonts/GothamRnd-Bold.otf';

  /// File path: assets/fonts/GothamRnd-Medium.otf
  String get gothamRndMedium => 'assets/fonts/GothamRnd-Medium.otf';

  /// File path: assets/fonts/eurostile.TTF
  String get eurostile => 'assets/fonts/eurostile.TTF';

  /// List of all assets
  List<String> get values => [
    euroStyleNormal,
    eurostarBlack,
    eurostarRegular,
    gothamBlack,
    gothamBook,
    gothamFont,
    gothamLight,
    gothamRndBold,
    gothamRndMedium,
    eurostile,
  ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/agentsicon.png
  AssetGenImage get agentsicon =>
      const AssetGenImage('assets/icons/agentsicon.png');

  /// File path: assets/icons/aiicon.png
  AssetGenImage get aiicon => const AssetGenImage('assets/icons/aiicon.png');

  /// File path: assets/icons/companyicon.png
  AssetGenImage get companyicon =>
      const AssetGenImage('assets/icons/companyicon.png');

  /// File path: assets/icons/googleicon.png
  AssetGenImage get googleicon =>
      const AssetGenImage('assets/icons/googleicon.png');

  /// File path: assets/icons/homeicon.png
  AssetGenImage get homeicon =>
      const AssetGenImage('assets/icons/homeicon.png');

  /// File path: assets/icons/listicon.png
  AssetGenImage get listicon =>
      const AssetGenImage('assets/icons/listicon.png');

  /// File path: assets/icons/locationicon.png
  AssetGenImage get locationicon =>
      const AssetGenImage('assets/icons/locationicon.png');

  /// File path: assets/icons/manyicon.png
  AssetGenImage get manyicon =>
      const AssetGenImage('assets/icons/manyicon.png');

  /// File path: assets/icons/profileicon.png
  AssetGenImage get profileicon =>
      const AssetGenImage('assets/icons/profileicon.png');

  /// File path: assets/icons/raactiveAiicon.png
  AssetGenImage get raactiveAiicon =>
      const AssetGenImage('assets/icons/raactiveAiicon.png');

  /// File path: assets/icons/robotAiicon.png
  AssetGenImage get robotAiicon =>
      const AssetGenImage('assets/icons/robotAiicon.png');

  /// File path: assets/icons/robotAiicon2.png
  AssetGenImage get robotAiicon2 =>
      const AssetGenImage('assets/icons/robotAiicon2.png');

  /// File path: assets/icons/successtick.png
  AssetGenImage get successtick =>
      const AssetGenImage('assets/icons/successtick.png');

  /// File path: assets/icons/textaiicon.png
  AssetGenImage get textaiicon =>
      const AssetGenImage('assets/icons/textaiicon.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    agentsicon,
    aiicon,
    companyicon,
    googleicon,
    homeicon,
    listicon,
    locationicon,
    manyicon,
    profileicon,
    raactiveAiicon,
    robotAiicon,
    robotAiicon2,
    successtick,
    textaiicon,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/splashicom.png
  AssetGenImage get splashicom =>
      const AssetGenImage('assets/images/splashicom.png');

  /// List of all assets
  List<AssetGenImage> get values => [splashicom];
}

class Assets {
  const Assets._();

  static const $AssetsColorGen color = $AssetsColorGen();
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
