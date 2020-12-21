import 'package:chat/models/profiles.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/pages/avatar_image.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/my_profile.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'avatar_user_chat.dart';

class Header extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final Profiles profile;
  final bool isUserAuth;

  const Header({
    Key key,
    this.maxHeight,
    this.minHeight,
    this.isUserAuth,
    @required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final animation = AlwaysStoppedAnimation(expandRatio);

        return FlexibleSpaceBar(
            centerTitle: true,
            title: Container(
              margin: EdgeInsets.only(top: 170),
              child: Stack(children: [
                ItemsUnderSliverAppBar(
                    profile: profile, isUserAuth: isUserAuth),
                Container(
                  padding: EdgeInsets.only(top: 90, left: 20),
                  child: Row(
                    children: [
                      Container(
                          child: Text('30 - 45 min',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.6),
                              ))),
                    ],
                  ),
                )
              ]),
            ),
            background: Image.network(
              'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
              fit: BoxFit.cover,
            ));
      },
    );
  }
}

class ItemsUnderSliverAppBar extends StatelessWidget {
  final Profiles profile;
  final bool isUserAuth;

  ItemsUnderSliverAppBar({this.profile, this.isUserAuth});

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (!isUserAuth)
                  Navigator.of(context).push(createRouteChat());
                else
                  Navigator.of(context).push(createRouteMyProfile());
              },
              child: Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(left: 50, top: 20),
                child: Hero(
                  tag: profile.user.uid,
                  child: Material(
                    type: MaterialType.transparency,
                    child: ImageUserChat(
                      width: 100,
                      height: 100,
                      profile: profile,
                      fontsize: 13,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              child: Center(
                child: FittedBox(
                  child: Text(
                    (profile.user.username.length >= 14)
                        ? profile.user.username.substring(0, 14) + '...'
                        : profile.user.username,
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
                      backgroundColor: currentTheme.scaffoldBackgroundColor),
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
                      backgroundColor: currentTheme.scaffoldBackgroundColor),
                )),
          ],
        ),
      ),
    );
  }
}

Route createRouteChat() {
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
  );
}

Route createRouteAvatarProfile(User user, Profiles profile) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AvatarImagePage(profile),
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
  );
}
