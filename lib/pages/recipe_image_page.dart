import 'package:chat/models/profiles.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/recipe_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecipeImagePage extends StatefulWidget {
  RecipeImagePage({this.profile, this.isUserAuth = true});
  final Profiles profile;
  final bool isUserAuth;

  @override
  _RecipeImagePageState createState() => _RecipeImagePageState();
}

class _RecipeImagePageState extends State<RecipeImagePage> {
  File imageHeader;
  final picker = ImagePicker();
  // AwsService authService;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final nameSub = (widget.profile.name == "")
        ? widget.profile.user.username
        : widget.profile.name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(nameSub),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.accentColor,
          ),
          iconSize: 40,
          onPressed: () => {
            setState(() {
              Navigator.pop(context);
            }),
          },

          //  Navigator.pushReplacementNamed(context, '/profile-edit'),
          color: Colors.white,
        ),
        actions: [
          /*  IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              color: currentTheme.accentColor,
            ),
            iconSize: 40,
            onPressed: () async => _selectImage(),
            color: Colors.white,
          ), */
        ],
      ),
      backgroundColor: Colors.black,
      body: Hero(
        tag: widget.profile.imageHeader,
        child: Material(
          type: MaterialType.transparency,
          child: RecipeImageExpanded(
            width: 100,
            height: 100,
            profile: widget.profile,
          ),
        ),
      ),
    );
  }
}
