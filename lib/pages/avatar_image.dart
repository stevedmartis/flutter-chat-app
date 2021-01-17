import 'package:chat/models/profiles.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AvatarImagePage extends StatefulWidget {
  AvatarImagePage({this.profile, this.isUserAuth = true});
  final Profiles profile;
  final bool isUserAuth;

  @override
  _AvatarImagePageState createState() => _AvatarImagePageState();
}

class _AvatarImagePageState extends State<AvatarImagePage> {
  File image;
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.accentColor,
          ),
          iconSize: 40,
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              color: currentTheme.accentColor,
            ),
            iconSize: 40,
            onPressed: () => _selectImage(),
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // bottomNavigationBar: (widget.isUserAuth)

          Hero(
            tag: widget.profile.user.uid,
            child: Material(
              type: MaterialType.transparency,
              child: ImageAvatarExpanded(
                width: 100,
                height: 100,
                profile: widget.profile,
                fontsize: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selectImage() async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      print(fileType);
      /* awsService.uploadAvatar(
            widget.profile.user.uid, fileType[0], fileType[1], image); */
      final resp = await awsService.uploadImageAvatar(
          widget.profile.user.uid, fileType[0], fileType[1], image);

      print(resp);

      authService.profile.imageAvatar = resp;

      Navigator.pop(context);
      setState(() {});
    } else {
      print('No image selected.');
    }
  }
}
