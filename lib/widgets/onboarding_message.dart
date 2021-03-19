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
              fontSize: _size.width / 20,
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
              fontSize: _size.width / 25,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Center(
          child: Stack(
            children: [
              Container(
                width: _size.width / 1.1,
                height: _size.width,
                child: SvgPicture.asset("assets/images/intro-background.svg",
                    semanticsLabel: 'Acme Logo'),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: _size.height / 8, left: _size.width / 7),
                width: _size.width / 1.7,
                height: _size.width / 2.0,
                child: SvgPicture.asset(image, semanticsLabel: 'Acme Logo'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
