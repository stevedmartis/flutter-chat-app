import 'dart:ui';

import 'package:chat/models/profiles.dart';
import 'package:flutter/material.dart';

class ImageHeaderExpanded extends StatefulWidget {
  const ImageHeaderExpanded({
    Key key,
    @required this.width,
    @required this.height,
    @required this.profile,
    @required this.fontsize,
  }) : super(key: key);

  final Profiles profile;
  final double fontsize;
  final double width;

  final double height;

  @override
  _ImageHeaderExpandedState createState() => _ImageHeaderExpandedState();
}

class _ImageHeaderExpandedState extends State<ImageHeaderExpanded> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        clipBehavior: Clip.antiAlias,
        child: InteractiveViewer(
          panEnabled: false, // Set it to false to prevent panning.
          boundaryMargin: EdgeInsets.all(80),
          minScale: 0.5,
          maxScale: 4,
          child: Image(
            image: NetworkImage(widget.profile.getHeaderImg()),
            fit: BoxFit.cover,
            width: double.maxFinite,
          ),
        ));
  }
}
