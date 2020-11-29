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
                    placeholder: AssetImage('assets/tag-logo.png'),
                    fit: BoxFit.cover),
              ),
            )
          : CircleAvatar(
              child: Text(
                widget.user.name.substring(0, 2).toUpperCase(),
                style: TextStyle(fontSize: widget.fontsize),
              ),
              backgroundColor: currentTheme.accentColor,
            ),
    );
  }
}
