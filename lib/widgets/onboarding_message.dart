import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingMessages extends StatelessWidget {
  final String title;
  final String message;
  final String image;
  final double left;
  final double width;
  final double height;
  const OnboardingMessages(
      {Key key,
      this.title,
      this.message,
      this.image,
      this.left,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 50,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GTWalsheimPro',
              color: Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Center(
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: _size.width - 50,
                  height: _size.width - 50,
                  child: SvgPicture.asset("assets/images/intro-background.svg",
                      semanticsLabel: 'Acme Logo'),
                ),
              ),
              Positioned(
                top: 50,
                left: this.left,
                child: Container(
                  width: _size.width * width,
                  height: _size.height * height,
                  child: SvgPicture.asset(image, semanticsLabel: 'Acme Logo'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
