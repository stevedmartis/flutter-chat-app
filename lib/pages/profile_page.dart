import 'package:chat/models/profiles.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class SliverAppBarProfilepPage extends StatefulWidget {
  @override
  SliverAppBarProfilepPageState createState() =>
      SliverAppBarProfilepPageState();
}

class SliverAppBarProfilepPageState extends State<SliverAppBarProfilepPage> {
  Profiles profile;

  @override
  void initState() {
    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MyProfile(
          profile: profile,
          isUserAuth: true,
        ),
      ),
    );
  }
}
