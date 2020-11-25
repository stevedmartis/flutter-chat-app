import 'package:chat/pages/users_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomAppBarHeader extends StatelessWidget {
  final bool showContent;

  @override
  CustomAppBarHeader({this.showContent = true});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Container(
      child: Row(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
                //globalKey.currentState.openEndDrawer();
              },
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: ImageUserChat(
                  user: user,
                  fontsize: 15,
                ),
              ),
            ),
          ),
          Center(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff202020),
                          Color(0xff1D1D1D),
                          Color(0xff161616),
                        ]),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          spreadRadius: -5,
                          blurRadius: 10,
                          offset: Offset(0, 5))
                    ],
                  ),
                  child: _SearchContent())),
          Container(
              padding: EdgeInsets.all(5.0),
              child: FaIcon(FontAwesomeIcons.slidersH, size: 25)),
        ],
      ),
    );
  }
}

class _SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(0.30);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icon( FontAwesomeIcons.chevronLeft, color: Colors.black54 ),

            Icon(Icons.search, color: color),
            SizedBox(width: 20),
            Container(
                margin: EdgeInsets.only(top: 0),
                child: Text('Buscar contacto...',
                    style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.w500))),
          ],
        ));
  }
}

class CustomAppBarIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                  //globalKey.currentState.openEndDrawer();
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                  //globalKey.currentState.openEndDrawer();
                },
              ),
            ],
          )),
    );
  }
}
