import 'package:chat/models/profiles.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_card.dart';

import 'dart:ui' as ui;

class ProfilePage extends StatefulWidget {
  ProfilePage(
      {this.isUserAuth,
      this.isUserEdit = false,
      @required this.profile,
      this.loading = false,
      this.isEmpty = false,
      this.image});
  final bool isUserAuth;
  final bool isUserEdit;
  final Profiles profile;
  final bool isEmpty;
  final loading;

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
    return SizedBox.expand(
      child: Container(
        color: currentTheme.scaffoldBackgroundColor,
        height: _profileCardHeight,
        child: ProfileCard(
            loading: widget.loading,
            image: widget.image,
            isEmpty: widget.isEmpty,
            isUserAuth: widget.isUserAuth,
            isUserEdit: widget.isUserEdit,
            profile: widget.profile,
            profileColor: currentTheme.scaffoldBackgroundColor),
      ),
    );
  }
}
