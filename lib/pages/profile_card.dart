import 'package:chat/models/profiles.dart';
import 'package:chat/pages/avatar_image.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/button_gold.dart';
import 'package:chat/widgets/sliver_header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'dart:ui' as ui;

class ProfileCard extends StatefulWidget {
  ProfileCard(
      {@required this.profileColor,
      this.isUserAuth = false,
      this.isUserEdit = false,
      @required this.profile,
      @required this.image,
      this.loading = false,
      this.isEmpty = false});

  final Color profileColor;
  static const double avatarRadius = 48;
  static const double titleBottomMargin = (avatarRadius * 2) + 18;

  final bool isUserAuth;
  final bool isUserEdit;
  final Profiles profile;
  final bool isEmpty;
  final loading;
  final ui.Image image;

  final picker = ImagePicker();

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Stack(
      children: [
        Hero(
            tag: widget.profile.imageHeader,
            child: FadeInImage(
              image: NetworkImage(widget.profile.getHeaderImg()),
              placeholder: AssetImage('assets/loading2.gif'),
              fit: BoxFit.cover,
              height: size.height,
              width: double.infinity,
              alignment: Alignment.center,
            )),
        /* Container(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment(0.0, -0.5),
                  begin: Alignment(0.0, 0.1),
                  colors: <Color>[
                    currentTheme.scaffoldBackgroundColor,
                    currentTheme.scaffoldBackgroundColor.withOpacity(0.0),
                    currentTheme.scaffoldBackgroundColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ), */

        /* Container(
                // color: currentTheme.scaffoldBackgroundColor,
                child: AnimatedOpacity(
                  opacity: widget.loading ? 0.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: ProfileCardEmptyPainter(
                      isUserEdit: widget.isUserEdit,
                      color: widget.profileColor,
                      avatarRadius: ProfileCard.avatarRadius,
                    ),
                  ),
                ),
              ), */

        /* Positioned(
          left: 0,
          right: 0,
          bottom: titleBottomMargin,
          child: Column(
            children: <Widget>[
              Text(
                data.name,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Colors.grey.shade100),
              ),
              Text(
                data.title,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.grey.shade300),
              ),
            ],
          ),
        ),
         */

        Container(
          margin: EdgeInsets.only(left: (widget.isUserEdit) ? 0 : 22),
          child: Align(
            alignment: (widget.isUserEdit)
                ? Alignment.bottomCenter
                : Alignment.bottomLeft,
            child: CircleAvatar(
              radius: 55,
              backgroundColor:
                  currentTheme.scaffoldBackgroundColor.withOpacity(0.60),
              child: CircleAvatar(
                radius: ProfileCard.avatarRadius,
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                child: GestureDetector(
                  onTap: () => {
                    if (!widget.isUserAuth)
                      Navigator.of(context).push(createRouteChat())
                    else
                      Navigator.of(context).push(PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 200),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AvatarImagePage(
                                    profile: this.widget.profile,
                                  ))),

                    // make changes here

                    //Navigator.of(context).push(createRouteAvatarProfile(this.user));
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Hero(
                      tag: widget.profile.user.uid,
                      child: Material(
                        type: MaterialType.transparency,
                        child: ImageUserChat(
                          width: 100,
                          // showBorderAvatar: _showBorderAvatar,
                          height: 100,
                          profile: widget.profile,
                          fontsize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        (!widget.isUserEdit)
            ? Container(
                //top: size.height / 3.5,
                padding: EdgeInsets.only(top: 35.0),
                margin: EdgeInsets.only(
                    top: size.height / 4.5,
                    left: size.width / 1.8,
                    right: size.width / 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ButtonSubEditProfile(
                      color: currentTheme.scaffoldBackgroundColor
                          .withOpacity(0.60),
                      textColor: (widget.isUserAuth)
                          ? Colors.white.withOpacity(0.50)
                          : currentTheme.accentColor,
                      text: widget.isUserAuth ? 'Editar perfil' : 'Subscribe',
                      onPressed: () {
                        if (widget.isUserAuth)
                          Navigator.of(context).push(createRouteEditProfile());
                      }),
                ),
              )
            : Container(),
      ],
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
    transitionDuration: Duration(milliseconds: 400),
  );
}
