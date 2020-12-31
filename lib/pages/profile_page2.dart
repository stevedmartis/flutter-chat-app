import 'package:chat/models/profiles.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/button_gold.dart';
import 'package:chat/widgets/sliver_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_card.dart';

import 'dart:ui' as ui;

class ProfilePage extends StatefulWidget {
  ProfilePage(
      {this.isUserAuth,
      this.isUserEdit = false,
      @required this.profile,
      this.isEmpty = false,
      this.image});
  final bool isUserAuth;
  final bool isUserEdit;
  final Profiles profile;
  final bool isEmpty;

  final ui.Image image;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final size = MediaQuery.of(context).size;
    final _profileCardHeight = size.height / 3;
    return Scaffold(
      floatingActionButton:
          /* (!widget.isUserEdit)
          ? Container(
           //   margin: EdgeInsets.only(top: 250),
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
          : */
          Container(),
      body: Stack(
        children: [
          Container(
            height: _profileCardHeight,
            child: ProfileCard(
                image: widget.image,
                isEmpty: widget.isEmpty,
                isUserAuth: widget.isUserAuth,
                isUserEdit: widget.isUserEdit,
                profile: widget.profile,
                profileColor: currentTheme.scaffoldBackgroundColor),
          ),
          Container(
            padding: EdgeInsets.all(50),
            margin: EdgeInsets.only(top: size.height / 5),
            child: ButtonGold(
                color: currentTheme.accentColor,
                text: 'Start now!',
                onPressed: () => {
                      // Navigator.push()
                    }),
          ),
        ],
      ),
    );
  }
}
