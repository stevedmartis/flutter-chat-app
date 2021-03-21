import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/register_page.dart';

import 'package:chat/widgets/header_curve_signin.dart';
import 'package:flutter/material.dart';

class OnBoardingSelector extends StatefulWidget {
  final List<Widget> pages;

  const OnBoardingSelector({
    Key key,
    this.pages,
  }) : super(key: key);

  @override
  _OnBoardingSelectorState createState() => _OnBoardingSelectorState();
}

class _OnBoardingSelectorState extends State<OnBoardingSelector> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    bool _isLastPage = widget.pages.length == this._currentPage + 1;

    Size _size = MediaQuery.of(context).size;

    const List<Color> blackGradients = [
      Color(0xff1A1A1A),
      Color(0xff1A1A1A),
      Color(0xff1A1A1A),
    ];

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          width: double.infinity,
          height: _size.height,
          child: PageView(
            physics: ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                this._currentPage = page;
              });
            },
            children: widget.pages,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: _size.height / 2,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _buildPageIndicator(),
          ),
        ),
        SizedBox(
          height: (_isLastPage) ? 115 : 150,
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              top: _size.height * 0.82, bottom: _size.height * 0.1),
          child: GestureDetector(
              child: roundedRectButton("Entrar!", orangeGradients, false, true),
              onTap: () => {Navigator.push(context, _createRuteLogIn())}),
        ),
        Container(
          alignment: Alignment.center,
          padding:
              EdgeInsets.only(top: _size.height * 0.9, left: 60, right: 60),
          child: GestureDetector(
              child: roundedRectButton(
                  "Registrarme!", blackGradients, false, false),
              onTap: () => {Navigator.push(context, _createRuteSignUp())}),
        ),
      ],
    );
  }

  Route _createRuteSignUp() {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            RegisterPage(),
        transitionDuration: Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);

          return FadeTransition(
              child: child,
              opacity:
                  Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation));
        });
  }

  Route _createRuteLogIn() {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            LoginPage(),
        transitionDuration: Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);

          return FadeTransition(
              child: child,
              opacity:
                  Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation));
        });
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    int numberOfPages = widget.pages.length;
    for (int i = 0; i < numberOfPages; i++) {
      list.add(_indicator(numberOfPages, i));
    }
    return list;
  }

  Widget _indicator(int numberOfPages, int index) {
    double _size;

    Color _color;

    if (_currentPage >= index - 0.5 && _currentPage < index + 0.5) {
      _size = 20;
      _color = Color(0xff34EC9C);
    } else {
      _size = 15;
      _color = Color(0xff1C181D);
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: _size,
      width: _size,
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        decoration: new BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.white.withOpacity(0.30),
            width: 1.5,
          ),
        ),
        child: Container(
          decoration: new BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class StyledLogoCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RichText(
          textAlign: TextAlign.center,
          text: new TextSpan(
            children: [
              TextSpan(
                text: "Leafety",
                style: TextStyle(
                  letterSpacing: -1,
                  fontFamily: 'GTWalsheimPro',
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
