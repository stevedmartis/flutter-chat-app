import 'package:chat/pages/product_detail_page.dart';

import 'package:flutter/material.dart';

class ShoesSizePreview extends StatelessWidget {
  final bool fullScreen;

  ShoesSizePreview({this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!this.fullScreen) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ShoesDetailPage()));
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (this.fullScreen) ? 5 : 30,
          vertical: (this.fullScreen) ? 5 : 0,
        ),
        child: Container(
          width: 100,
          height: (this.fullScreen) ? 100 : 100,
          decoration: BoxDecoration(
              color: Color(0xffFFCF53),
              borderRadius: (this.fullScreen)
                  ? BorderRadius.circular(40)
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
        ),
      ),
    );
  }
}
