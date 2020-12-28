import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

class ProfileCardPainter extends CustomPainter {
  ProfileCardPainter(
      {@required this.color,
      @required this.avatarRadius,
      @required this.image});

  static const double _margin = 6;
  final Color color;
  final double avatarRadius;

  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds =
        Rect.fromLTWH(0, 0, size.width, size.height - avatarRadius);

    final centerAvatar = Offset(shapeBounds.left + 70, shapeBounds.bottom);
    final avatarRect =
        Rect.fromCircle(center: centerAvatar, radius: avatarRadius)
            .inflate(_margin);
/* 
    final curvedShapeBounds = Rect.fromLTRB(
      shapeBounds.left,
      shapeBounds.top + shapeBounds.height * 0.35,
      shapeBounds.right,
      shapeBounds.bottom,
    ); */

    _drawBackground(canvas, shapeBounds, avatarRect);
    //_drawCurvedShape(canvas, curvedShapeBounds, avatarRect);
  }

  void _drawBackground(Canvas canvas, Rect bounds, Rect avatarRect) {
    final paint = Paint()..color = color;

    final backgroundPath = Path()
      ..moveTo(bounds.left, bounds.top)
      ..lineTo(bounds.bottomLeft.dx, bounds.bottomLeft.dy)
      ..arcTo(avatarRect, -pi, pi, false)
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy)
      ..lineTo(bounds.topRight.dx, bounds.topRight.dy)
      ..close();

    canvas.drawPath(
        backgroundPath,
        paint
          ..shader = ImageShader(image, TileMode.mirror, TileMode.mirror,
              Float64List.fromList(Matrix4.identity().scaled(0.5).storage))
          ..style = PaintingStyle.fill);
  }

  /*  void _drawCurvedShape(Canvas canvas, Rect bounds, Rect avatarRect) {
    //  final colors = [];
    // final stops = [0.0, 0.3, 1.0];
    //final gradient = LinearGradient(colors: colors, stops: stops);
    final paint = Paint();
    //..shader = gradient.createShader(bounds);
    final handlePoint = Offset(bounds.left + (bounds.width * 0.25), bounds.top);

    final curvePath = Path()
      ..moveTo(bounds.bottomLeft.dx, bounds.bottomLeft.dy)
      ..arcTo(avatarRect, -pi, pi, false)
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy)
      ..lineTo(bounds.topRight.dx, bounds.topRight.dy)
      ..quadraticBezierTo(handlePoint.dx, handlePoint.dy, bounds.bottomLeft.dx,
          bounds.bottomLeft.dy)
      ..close();

    // canvas.drawPath(curvePath, paint);

    canvas.drawPath(
        curvePath,
        paint
          ..shader = ImageShader(image, TileMode.mirror, TileMode.mirror,
              Float64List.fromList(Matrix4.identity().scaled(0.5).storage))
          ..style = PaintingStyle.fill);
  }
 */
  @override
  bool shouldRepaint(ProfileCardPainter oldDelegate) {
    return avatarRadius != oldDelegate.avatarRadius ||
        color != oldDelegate.color;
  }
}
