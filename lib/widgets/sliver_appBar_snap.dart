import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'dart:async';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class ImageMask extends StatefulWidget {
  final ImageProvider image;
  final double width;
  final double height;
  final Widget child;

  const ImageMask(
      {@required this.image, this.width, this.height, @required this.child});

  @override
  _ImageMaskState createState() => _ImageMaskState();
}

class _ImageMaskState extends State<ImageMask> {
  Future<Shader> _shader;

  @override
  void initState() {
    super.initState();
    _shader = _loadShader(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _shader,
      builder: (_, AsyncSnapshot<Shader> snapshot) {
        return snapshot.connectionState != ConnectionState.done ||
                snapshot.hasError
            ? SizedBox(width: widget.width, height: widget.height)
            : ShaderMask(
                blendMode: BlendMode.dstATop,
                shaderCallback: (bounds) => snapshot.data,
                child: widget.child,
              );
      },
    );
  }

  Future<Shader> _loadShader(BuildContext context) async {
    final completer = Completer<ImageInfo>();

    // use the ResizeImage provider to resolve the image in the required size
    ResizeImage(widget.image,
            width: widget.width.toInt(), height: widget.height.toInt())
        .resolve(ImageConfiguration(size: Size(widget.width, widget.height)))
        .addListener(
            ImageStreamListener((info, _) => completer.complete(info)));

    final info = await completer.future;
    return ImageShader(
      info.image,
      TileMode.clamp,
      TileMode.clamp,
      Float64List.fromList(Matrix4.identity().storage),
    );
  }
}
