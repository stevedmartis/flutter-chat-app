import 'package:chat/models/profile.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AvatarImagePage extends StatefulWidget {
  AvatarImagePage(this.profile);
  final Profiles profile;

  @override
  _AvatarImagePageState createState() => _AvatarImagePageState();
}

class _AvatarImagePageState extends State<AvatarImagePage> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.accentColor,
          ),
          iconSize: 50,
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Container(
          height: 70,
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () => {_selectImage()},
                  child: Container(
                    alignment: Alignment.center,
                    color: currentTheme.accentColor,
                    child: Text("Cambiar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: currentTheme.scaffoldBackgroundColor,
                  child: Text("Quitar",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
            ],
          )),
      backgroundColor: Colors.black,
      body: Hero(
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
    );
  }

  _selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
