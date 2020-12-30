import 'package:chat/models/profiles.dart';
import 'package:chat/pages/avatar_image.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';

import './extensions.dart';
import 'profile_model.dart';
import 'profile_card_painter.dart';

import 'dart:ui' as ui;

class ProfileCard extends StatelessWidget {
  ProfileCard(
      {@required this.data,
      @required this.profileColor,
      this.isUserAuth = false,
      this.isUserEdit = false,
      @required this.profile,
      @required this.image});

  final ProfileModel data;
  final Color profileColor;
  static const double avatarRadius = 48;
  static const double titleBottomMargin = (avatarRadius * 2) + 18;

  final bool isUserAuth;
  final bool isUserEdit;
  final Profiles profile;

  final ui.Image image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          child: Container(
            child: CustomPaint(
              size: Size.infinite,
              painter: ProfileCardPainter(
                image: image,
                color: profileColor,
                avatarRadius: avatarRadius,
              ),
            ),
          ),
        ),
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
          margin: EdgeInsets.only(left: 22),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: profileColor.darker(),
              child: GestureDetector(
                onTap: () => {
                  if (!isUserAuth)
                    Navigator.of(context).push(createRouteChat())
                  else
                    Navigator.of(context).push(PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 200),
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AvatarImagePage(
                              profile: this.profile,
                            ))),

                  // make changes here

                  //Navigator.of(context).push(createRouteAvatarProfile(this.user));
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 100,
                  height: 100,
                  child: Hero(
                    tag: profile.user.uid,
                    child: Material(
                      type: MaterialType.transparency,
                      child: ImageUserChat(
                        width: 100,
                        // showBorderAvatar: _showBorderAvatar,
                        height: 100,
                        profile: profile,
                        fontsize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
