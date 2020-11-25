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
          /*   child: Column(
            children: [_ShoesShadow(), if (!this.fullScreen) _ShoesSize()],
          ), */
        ),
      ),
    );
  }
}

/* class _ShoesShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoesModel = Provider.of<ShoesModel>(context);

    return Padding(
      padding: const EdgeInsets.all(45),
      child: Stack(
        children: [
          Positioned(bottom: 10, right: 0, left: 20, child: _ShadowShoes()),
          Image(
            image: AssetImage(shoesModel.assetImage),
          )
        ],
      ),
    );
  }
}
 */
/* class _ShadowShoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.5,
      child: Container(
        width: 230,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [BoxShadow(color: Color(0xffEAA14E), blurRadius: 40)]),
      ),
    );
  }
}
 */
/* class _ShoesSize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SizeShoesBox(7),
          _SizeShoesBox(7.5),
          _SizeShoesBox(8),
          _SizeShoesBox(8.5),
          _SizeShoesBox(9),
          _SizeShoesBox(9.5)
        ],
      ),
    );
  }
}
 */
/* class _SizeShoesBox extends StatelessWidget {
  final double number;
  const _SizeShoesBox(this.number);

  @override
  Widget build(BuildContext context) {
    final shoesModel = Provider.of<ShoesModel>(context);

    return GestureDetector(
      onTap: () {
        final shoesModel = Provider.of<ShoesModel>(context, listen: false);

        shoesModel.size = this.number;
      },
      child: Container(
        alignment: Alignment.center,
        child: Text('${number.toString().replaceAll('.0', '')}',
            style: TextStyle(
                color: (this.number == shoesModel.size)
                    ? Colors.white
                    : Color(0xffF1A23A),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
            color: (this.number == shoesModel.size)
                ? Color(0xffF1A23A)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (this.number == shoesModel.size)
                BoxShadow(
                    color: Color(0xffF1A23A),
                    blurRadius: 10,
                    offset: Offset(0, 5))
            ]),
      ),
    );
  }
}
 */
