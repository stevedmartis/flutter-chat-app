import 'package:chat/pages/my_profile.dart';
import 'package:flutter/material.dart';

class StyledLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 0,
                child: Icon(
                  Icons.place_sharp,
                  size: 32,
                  color: Colors.black,
                ),
              ),
              Expanded(
                  flex: 0,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text('Logo',
                          style:
                              TextStyle(fontSize: 24, color: Colors.black)))),
            ]));
  }
}

Route createRouteMyProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.fastLinearToSlowEaseIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 700),
  );
}
