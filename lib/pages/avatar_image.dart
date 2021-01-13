import 'package:chat/models/profiles.dart';
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

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
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

    return Scaffold(
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
          if (widget.isUserAuth)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  // margin: EdgeInsets.only(top: 100),
                  padding: EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () => {_selectImage()},
                    child: Container(
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          alignment: Alignment.center,
                          color: currentTheme.accentColor,
                          child: Text("Cambiar",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  //margin: EdgeInsets.only(top: 100),
                  padding: EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () => {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        color: currentTheme.scaffoldBackgroundColor,
                        child: Text("Quitar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  _selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
