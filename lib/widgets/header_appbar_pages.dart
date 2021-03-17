import 'package:animate_do/animate_do.dart';
import 'package:chat/models/notification.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/pages/messages.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/pages/search_Principal_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomAppBarHeaderPages extends StatefulWidget {
  final bool showContent;
  final String title;
  final bool isAdd;

  final Widget action;

  @override
  CustomAppBarHeaderPages(
      {this.showContent = false,
      @required this.title,
      this.action,
      this.isAdd = false});

  @override
  _CustomAppBarHeaderState createState() => _CustomAppBarHeaderState();
}

class _CustomAppBarHeaderState extends State<CustomAppBarHeaderPages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final currentTheme = Provider.of<ThemeChanger>(context);

    final profile = authService.profile;

    final size = MediaQuery.of(context).size;
    final int number = Provider.of<NotificationModel>(context).number;

    return Container(
      color: (currentTheme.customTheme)
          ? (!widget.showContent)
              ? currentTheme.currentTheme.cardColor
              : Colors.black
          : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                {
                  Navigator.push(context, _createRoute());
                }
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(left: 10),
                child: Hero(
                  tag: profile.user.uid,
                  child: Material(
                    type: MaterialType.transparency,
                    child: ImageUserChat(
                      width: 100,
                      height: 100,
                      profile: profile,
                      fontsize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          (widget.isAdd)
              ? SizedBox(
                  width: 50,
                )
              : SizedBox(
                  width: 10,
                ),
          (widget.showContent)
              ? GestureDetector(
                  onTap: () => showSearch(
                      context: context,
                      delegate: DataSearch(userAuth: profile)),
                  child: Center(
                      child: Container(

                          // color: Colors.black,
                          //  margin: EdgeInsets.only(left: 10, right: 10),
                          width: size.height / 3.2,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  currentTheme.currentTheme.cardColor,
                                  currentTheme.currentTheme.cardColor,
                                  currentTheme.currentTheme.cardColor
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
                          child: SearchContent())),
                )
              : Expanded(
                  child: Center(
                    child: Container(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 20,
                            color: (currentTheme.customTheme)
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
          widget.action,
          SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context, _createRouteMessages());
              },
              icon: Stack(
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.commentDots,
                    color: currentTheme.currentTheme.primaryColor,
                    size: 30,
                  ),
                  (number > 0)
                      ? Positioned(
                          top: 0.0,
                          right: 4.0,
                          child: BounceInDown(
                            from: 10,
                            animate: (number > 0) ? true : false,
                            child: Bounce(
                              delay: Duration(seconds: 2),
                              from: 15,
                              controller: (controller) =>
                                  Provider.of<NotificationModel>(context)
                                      .bounceController = controller,
                              child: Container(
                                child: Text(
                                  '$number',
                                  style: TextStyle(
                                      color: (currentTheme.customTheme)
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: (currentTheme.customTheme)
                                        ? currentTheme.currentTheme.accentColor
                                        : Colors.black,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              )),
        ],
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-0.5, 0.0);
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

Route _createRouteMessages() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MessagesPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}

class CustomSliverAppBarHeader extends StatelessWidget {
  CustomSliverAppBarHeader({this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 30),
              width: size.height / 3,
              height: 40,
              decoration: BoxDecoration(
                color: currentTheme.scaffoldBackgroundColor.withOpacity(0.30),
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      spreadRadius: -5,
                      blurRadius: 10,
                      offset: Offset(0, 5))
                ],
              ),
              child: SearchContent()),
          Container(
              padding: EdgeInsets.all(0.0),
              child: Icon(
                Icons.more_vert,
                size: 25,
                color: currentTheme.accentColor,
              )),
        ],
      ),
    );
  }
}

class SearchContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final color = Colors.white.withOpacity(0.60);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icon( FontAwesomeIcons.chevronLeft, color: Colors.black54 ),

            Icon(Icons.search,
                color: (currentTheme.customTheme) ? color : Colors.black),
            SizedBox(width: 20),
            Container(
                // margin: EdgeInsets.only(top: 0, left: 0),
                child: Text('Buscar',
                    style: TextStyle(
                        color:
                            (currentTheme.customTheme) ? color : Colors.black,
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
