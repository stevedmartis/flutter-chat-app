import 'package:chat/models/profile.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageUserChat extends StatefulWidget {
  const ImageUserChat({
    Key key,
    @required this.width,
    @required this.height,
    @required this.profile,
    @required this.fontsize,
  }) : super(key: key);

  final Profiles profile;

  final double fontsize;
  final double width;

  final double height;

  @override
  _ImageUserChatState createState() => _ImageUserChatState();
}

class _ImageUserChatState extends State<ImageUserChat> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100.0)),
      child: (widget.profile.imageAvatar != "")
          ? CircleAvatar(
              minRadius: 20,
              child: Container(
                width: widget.width,
                height: widget.height,
                child: FadeInImage(
                    image: NetworkImage(widget.profile.getAvatarImg()),
                    placeholder: AssetImage('assets/loading2.gif'),
                    fit: BoxFit.cover),
              ),
            )
          : CircleAvatar(
              child: Container(
                width: widget.width,
                height: widget.height,
                child: Center(
                  child: Text(
                    widget.profile.user.username.substring(0, 2).toUpperCase(),
                    style: TextStyle(fontSize: widget.fontsize),
                  ),
                ),
              ),
              backgroundColor: currentTheme.accentColor,
            ),
    );
  }
}

class ImageAvatarExpanded extends StatefulWidget {
  const ImageAvatarExpanded({
    Key key,
    @required this.width,
    @required this.height,
    @required this.profile,
    @required this.fontsize,
  }) : super(key: key);

  final Profiles profile;
  final double fontsize;
  final double width;

  final double height;

  @override
  _ImageAvatarExpandedState createState() => _ImageAvatarExpandedState();
}

class _ImageAvatarExpandedState extends State<ImageAvatarExpanded> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Card(
      color: Colors.black,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      clipBehavior: Clip.antiAlias,
      child: (widget.profile.imageAvatar != "")
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: NetworkImage(widget.profile.getAvatarImg()),
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                )
              ],
            )
          : Container(
              margin: EdgeInsets.only(bottom: 300),
              padding: EdgeInsets.all(50),
              width: double.maxFinite,
              height: double.maxFinite,
              child: CircleAvatar(
                child: Text(
                  widget.profile.user.username.substring(0, 2).toUpperCase(),
                  style: TextStyle(fontSize: widget.fontsize),
                ),
                backgroundColor: currentTheme.accentColor,
              ),
            ),
    );
  }
}
