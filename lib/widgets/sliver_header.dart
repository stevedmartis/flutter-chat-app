import 'package:chat/models/usuario.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'avatar_user_chat.dart';

class Header extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final User user;

  const Header({
    Key key,
    this.maxHeight,
    this.minHeight,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final animation = AlwaysStoppedAnimation(expandRatio);

        return FlexibleSpaceBar(
            centerTitle: true,
            title: Container(
                margin: EdgeInsets.only(top: 200),
                child: Container(child: ItemsUnderSliverAppBar(user: user))),
            background: Image.network(
              'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
              fit: BoxFit.cover,
            ));
      },
    );
  }
}

class ItemsUnderSliverAppBar extends StatelessWidget {
  final User user;

  ItemsUnderSliverAppBar({this.user});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      child: Row(
        children: [
          Center(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(left: 20),
                    child: Hero(
                      tag: user.uid,
                      child: ImageUserChat(
                        width: 100,
                        height: 100,
                        user: user,
                        fontsize: 13,
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 100),
                  padding: EdgeInsets.all(10),
                  width: 100,
                  height: 100,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        (user.name.length >= 14)
                            ? user.name.substring(0, 14) + '...'
                            : user.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(left: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: CircleAvatar(
                          minRadius: 20,
                          child: FittedBox(
                            child: Icon(
                              Icons.share,
                              size: 15,
                              color: currentTheme.accentColor,
                            ),
                          ),
                          backgroundColor:
                              currentTheme.scaffoldBackgroundColor),
                    )),
                Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(left: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: CircleAvatar(
                          minRadius: 10,
                          child: FittedBox(
                            child: Icon(
                              Icons.favorite,
                              size: 15,
                              color: currentTheme.accentColor,
                            ),
                          ),
                          backgroundColor:
                              currentTheme.scaffoldBackgroundColor),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ChatPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
