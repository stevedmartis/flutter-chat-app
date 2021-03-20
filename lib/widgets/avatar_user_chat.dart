import 'package:chat/models/profiles.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/productProfile_card.dart';
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
    final currentTheme = Provider.of<ThemeChanger>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
        child: (widget.profile.imageAvatar != "")
            ? CircleAvatar(
                backgroundColor:
                    (currentTheme.customTheme) ? Colors.black : Colors.white,
                foregroundColor:
                    (currentTheme.customTheme) ? Colors.black : Colors.white,
                child: Container(
                  color: Colors.white,
                  width: widget.width,
                  height: widget.height,
                  child: cachedNetworkImage(widget.profile.getAvatarImg()),
                ),
              )
            : CircleAvatar(
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  child: Center(
                    child: Text(
                      widget.profile.user.username
                          .substring(0, 2)
                          .toUpperCase(),
                      style: TextStyle(fontSize: widget.fontsize),
                    ),
                  ),
                ),
                backgroundColor: currentTheme.currentTheme.accentColor,
              ),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return (widget.profile.imageAvatar != "")
        ? Container(
            color: Colors.white,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                clipBehavior: Clip.antiAlias,
                child: InteractiveViewer(
                    panEnabled: false, // Set it to false to prevent panning.
                    boundaryMargin: EdgeInsets.all(80),
                    minScale: 0.5,
                    maxScale: 10,
                    child: cachedNetworkImage(widget.profile.getAvatarImg()))),
          )
        : Container(
            margin: EdgeInsets.only(bottom: 300),
            //padding: EdgeInsets.all(0),
            width: double.maxFinite,
            height: double.maxFinite,
            child: CircleAvatar(
              child: Text(
                widget.profile.user.username.substring(0, 2).toUpperCase(),
                style: TextStyle(fontSize: widget.fontsize),
              ),
              backgroundColor: currentTheme.accentColor,
            ),
          );
  }
}
