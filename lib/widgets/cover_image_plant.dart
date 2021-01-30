import 'package:chat/models/plant.dart';

import 'package:flutter/material.dart';

class CoverImagePlant extends StatefulWidget {
  const CoverImagePlant({
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
  _CoverImagePlantState createState() => _CoverImagePlantState();
}

class _CoverImagePlantState extends State<CoverImagePlant> {
  @override
  Widget build(BuildContext context) {
    return (widget.plant.coverImage != "")
        ? Container(
            child: Image(
              image: NetworkImage(widget.plant.getCoverImg()),
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          )
        : Container(
            child: Image(
              image: AssetImage('assets/images/empty_image.png'),
              fit: BoxFit.cover,
              width: double.maxFinite,
            ),
          );
  }
}
