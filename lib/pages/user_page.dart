import 'package:chat/models/profiles.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class UserPage extends StatefulWidget {
  UserPage({this.profile});
  final Profiles profile;

  final authService = new AuthService();

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MyProfile(
          profile: widget.profile,
        ),
      ),
    );
  }
}
