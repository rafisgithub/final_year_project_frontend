import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class TransformMatrices {
  static Matrix4 scaleDown(TransformableListItem item) {
    const endScaleBound = 0.3;
    final animationProgress = item.visibleExtent.clamp(0, item.size.height) / item.size.height;
    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

      paintTransform
        ..translate(item.size.width / 2)
        ..scale(scale)
        ..translate(-item.size.width / 2);
    }

    return paintTransform;
  }

  static Matrix4 rotate(TransformableListItem item) {
    const maxRotationTurnsInRadians = pi / 2.0;
    final animationProgress = 1 - item.visibleExtent.clamp(0, item.size.height) / item.size.height;
    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final isEven = item.index?.isEven ?? false;
      final FractionalOffset fractionalOffset;
      final int rotateDirection;

      switch (item.position) {
        case TransformableListItemPosition.topEdge:
          fractionalOffset = isEven
              ? FractionalOffset.bottomLeft
              : FractionalOffset.bottomRight;
          rotateDirection = isEven ? -1 : 1;
          break;
        case TransformableListItemPosition.middle:
          return paintTransform;
        case TransformableListItemPosition.bottomEdge:
          fractionalOffset =
              isEven ? FractionalOffset.topLeft : FractionalOffset.topRight;
          rotateDirection = isEven ? 1 : -1;
          break;
      }

      final rotateAngle = animationProgress * maxRotationTurnsInRadians;
      final translation = fractionalOffset.alongSize(item.size);

      paintTransform
        ..translate(translation.dx, translation.dy)
        ..rotateZ(rotateDirection * rotateAngle)
        ..translate(-translation.dx, -translation.dy);
    }

    return paintTransform;
  }

  static Matrix4 wheel(TransformableListItem item) {
    const maxRotationTurnsInRadians = pi / 5.0;
    const minScale = 0.6;
    const maxScale = 1.0;
    const depthFactor = 0.01;

    final medianOffset = item.constraints.viewportMainAxisExtent / 2;
    final animationProgress =
        1 - (item.offset.dy - medianOffset).abs() / medianOffset;
    final scale = minScale + (maxScale - minScale) * animationProgress.clamp(0, 1);

    final translationOffset = FractionalOffset.center.alongSize(item.size);
    final rotationMatrix = Matrix4.identity()
      ..setEntry(3, 2, depthFactor)
      ..rotateX(maxRotationTurnsInRadians * animationProgress)
      ..scale(scale);

    final result = Matrix4.identity()
      ..translate(translationOffset.dx, translationOffset.dy)
      ..multiply(rotationMatrix)
      ..translate(-translationOffset.dx, -translationOffset.dy);

    return result;
  }

  static Matrix4 fadeInOut(TransformableListItem item) {
    const endScale = 0.4; // Adjusted for more visible effect
    final animationProgress = item.visibleExtent.clamp(0, item.size.height) / item.size.height;
    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final scale = endScale + ((1 - endScale) * animationProgress);

      paintTransform
        ..translate(item.size.width / 2, item.size.height / 2)
        ..scale(scale, scale, 1.0)
        ..translate(-item.size.width / 2, -item.size.height / 2);
    }

    return paintTransform;
  }

  static Matrix4 parallax(TransformableListItem item) {
    const maxShift = 100.0; // Increased for noticeable effect
    final medianOffset = item.constraints.viewportMainAxisExtent / 2;
    final animationProgress = ((item.offset.dy - medianOffset).abs() / medianOffset).clamp(0, 1);
    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final isEven = item.index?.isEven ?? false;
      final shiftDirection = isEven ? 1 : -1;
      final shift = maxShift * animationProgress * shiftDirection;

      paintTransform.translate(shift, 0.0);
    }

    return paintTransform;
  }

  static Matrix4 slideIn(TransformableListItem item) {
    const maxSlide = 200.0; // Increased for visibility
    final animationProgress = item.visibleExtent.clamp(0, item.size.height) / item.size.height;
    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final isTop = item.position == TransformableListItemPosition.topEdge;
      final slide = maxSlide * (1 - animationProgress) * (isTop ? -1 : 1);

      paintTransform.translate(0.0, slide);
    }

    return paintTransform;
  }

  static Matrix4 flip(TransformableListItem item) {
    const maxFlipAngle = pi;
    final animationProgress = 1 - item.visibleExtent.clamp(0, item.size.height) / item.size.height;
    final paintTransform = Matrix4.identity();

    if (item.position != TransformableListItemPosition.middle) {
      final isEven = item.index?.isEven ?? false;
      final flipDirection = isEven ? 1 : -1;
      final translation = FractionalOffset.center.alongSize(item.size);

      paintTransform
        ..translate(translation.dx, translation.dy)
        ..rotateY(flipDirection * maxFlipAngle * animationProgress)
        ..translate(-translation.dx, -translation.dy);
    }

    return paintTransform;
  }
   static Matrix4 macStyle(TransformableListItem item) {
    /// Mac Dock-like zoom animation: center items are zoomed in, edge items are smaller
    const maxScale = 1.2; // Maximum scale for center item
    const minScale = 0.8; // Minimum scale for edge items

    /// Calculate progress based on distance from viewport center
    final medianOffset = item.constraints.viewportMainAxisExtent / 2;
    final distanceFromCenter = (item.offset.dy - medianOffset).abs();
    final normalizedDistance = (distanceFromCenter / medianOffset).clamp(0, 1);
    
    /// Invert progress: 1 at center (full zoom), 0 at edges (min scale)
    final animationProgress = 1 - normalizedDistance;

    final paintTransform = Matrix4.identity();

    /// Apply scaling to all items, with strongest effect at center
    final scale = minScale + (maxScale - minScale) * animationProgress;
    
    /// Center the scale transformation
    paintTransform
      ..translate(item.size.width / 2, item.size.height / 2)
      ..scale(scale)
      ..translate(-item.size.width / 2, -item.size.height / 2);

    return paintTransform;
  }
}