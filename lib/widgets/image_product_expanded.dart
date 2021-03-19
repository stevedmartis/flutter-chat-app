import 'dart:ui';

import 'package:chat/models/products.dart';
import 'package:chat/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageCoverProductExpanded extends StatefulWidget {
  const ImageCoverProductExpanded({
    Key key,
    @required this.width,
    @required this.height,
    @required this.product,
    @required this.fontsize,
  }) : super(key: key);

  final Product product;
  final double fontsize;
  final double width;

  final double height;

  @override
  _ImageCoverProductExpandedState createState() =>
      _ImageCoverProductExpandedState();
}

class _ImageCoverProductExpandedState extends State<ImageCoverProductExpanded> {
  Product product;
  @override
  void initState() {
    final productService = Provider.of<ProductService>(context, listen: false);
    product = (productService.productProfile != null)
        ? productService.productProfile.product
        : productService.product;

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
            image: NetworkImage(product.getCoverImg()),
            fit: BoxFit.cover,
            width: double.maxFinite,
          ),
        ));
  }
}
