import 'dart:ui';

import 'package:chat/models/visit.dart';
import 'package:flutter/material.dart';

class ImageCoverVisitExpanded extends StatefulWidget {
  const ImageCoverVisitExpanded({
    Key key,
    @required this.width,
    @required this.height,
    @required this.visit,
    @required this.fontsize,
  }) : super(key: key);

  final Visit visit;
  final double fontsize;
  final double width;

  final double height;

  @override
  _ImageCoverVisitExpandedState createState() =>
      _ImageCoverVisitExpandedState();
}

class _ImageCoverVisitExpandedState extends State<ImageCoverVisitExpanded> {
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
            image: NetworkImage(widget.visit.getCoverImg()),
            fit: BoxFit.cover,
            width: double.maxFinite,
          ),
        ));
  }
}
