import 'package:chat/models/profiles.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/sliver_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_card.dart';
import 'profile_model.dart';

import 'dart:ui' as ui;

class ProfilePage extends StatefulWidget {
  ProfilePage(
      {this.isUserAuth,
      this.isUserEdit = false,
      @required this.profile,
      this.image});
  final bool isUserAuth;
  final bool isUserEdit;
  final Profiles profile;

  final ui.Image image;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _profileCardHeight = 260.0;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Scaffold(
      floatingActionButton: (!widget.isUserEdit)
          ? Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: CircleAvatar(
                    child: (IconButton(
                      icon: Icon(
                        (!widget.isUserAuth) ? Icons.favorite : Icons.edit,
                        color: currentTheme.accentColor,
                        size: 25,
                      ),
                      onPressed: () {
                        if (!widget.isUserAuth)
                          return true;
                        else
                          Navigator.of(context).push(createRouteEditProfile());

                        //globalKey.currentState.openEndDrawer();
                      },
                    )),
                    backgroundColor: Colors.black),
              ))
          : Container(),
      body: SizedBox.expand(
        child: Container(
          height: _profileCardHeight,
          child: ProfileCard(
              image: widget.image,
              isUserAuth: widget.isUserAuth,
              isUserEdit: widget.isUserEdit,
              profile: widget.profile,
              data: profileData,
              profileColor: currentTheme.scaffoldBackgroundColor),
        ),
      ),
    );
  }
}
