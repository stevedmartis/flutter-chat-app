import 'dart:ui';

import 'package:chat/models/plant.dart';
import 'package:flutter/material.dart';

class ImageCoverPlantExpanded extends StatefulWidget {
  const ImageCoverPlantExpanded({
    Key key,
    @required this.width,
    @required this.height,
    @required this.plant,
    @required this.fontsize,
  }) : super(key: key);

  final Plant plant;
  final double fontsize;
  final double width;

  final double height;

  @override
  _ImageCoverPlantExpandedState createState() =>
      _ImageCoverPlantExpandedState();
}

class _ImageCoverPlantExpandedState extends State<ImageCoverPlantExpanded> {
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
            image: NetworkImage(widget.plant.getCoverImg()),
            fit: BoxFit.cover,
            width: double.maxFinite,
          ),
        ));
  }
}
