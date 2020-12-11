import 'package:chat/models/usuario.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageUserChat extends StatefulWidget {
  const ImageUserChat({
    Key key,
    @required this.width,
    @required this.height,
    @required this.user,
    @required this.fontsize,
  }) : super(key: key);

  final User user;
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
      child: (widget.user.image != "")
          ? CircleAvatar(
              minRadius: 20,
              child: Container(
                width: widget.width,
                height: widget.height,
                child: FadeInImage(
                    image: NetworkImage(widget.user.getPosterImg()),
                    placeholder: AssetImage('assets/loading2.gif'),
                    fit: BoxFit.cover),
              ),
            )
          : CircleAvatar(
              child: Text(
                widget.user.username.substring(0, 2).toUpperCase(),
                style: TextStyle(fontSize: widget.fontsize),
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
    @required this.user,
    @required this.fontsize,
  }) : super(key: key);

  final User user;
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
      child: (widget.user.image != "")
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: NetworkImage(widget.user.getPosterImg()),
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                )
              ],
            )
          : CircleAvatar(
              child: Text(
                widget.user.username.substring(0, 2).toUpperCase(),
                style: TextStyle(fontSize: widget.fontsize),
              ),
              backgroundColor: currentTheme.accentColor,
            ),
    );
  }
}
