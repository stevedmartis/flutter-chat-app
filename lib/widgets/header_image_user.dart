import 'dart:ui';

import 'package:chat/models/profiles.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      clipBehavior: Clip.antiAlias,
      child: (widget.profile.imageHeader != "")
          ? InteractiveViewer(
              panEnabled: false, // Set it to false to prevent panning.
              boundaryMargin: EdgeInsets.all(80),
              minScale: 0.5,
              maxScale: 4,
              child: Image(
                image: NetworkImage(widget.profile.getHeaderImg()),
                fit: BoxFit.cover,
                width: double.maxFinite,
              ),
            )
          : Container(
              margin: EdgeInsets.only(bottom: 300),
              //padding: EdgeInsets.all(0),
              width: double.maxFinite,
              height: double.maxFinite,
              child: CircleAvatar(
                child: Text(
                  widget.profile.user.username.substring(0, 2).toUpperCase(),
                  style: TextStyle(fontSize: widget.fontsize),
                ),
                backgroundColor: currentTheme.accentColor,
              ),
            ),
    );
  }
}
