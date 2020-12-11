import 'package:chat/models/usuario.dart';
import 'package:chat/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils//extension.dart';

class TabsScrollCustom extends StatefulWidget {
  const TabsScrollCustom({
    Key key,
    @required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  _TabsScrollCustomState createState() => _TabsScrollCustomState();
}

class _TabsScrollCustomState extends State<TabsScrollCustom> {
  int currentIndexTab = 0;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      color: Colors.black,
      child: DefaultTabController(
          length: widget.users.length,
          child: PreferredSize(
            preferredSize: Size.fromHeight(600.0),
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: currentTheme.accentColor,
              tabs: List<Widget>.generate(widget.users.length, (int index) {
                final user = widget.users[index];

                final username = user.username;
                final usernameCapitalized = username.capitalize();

                return new Tab(
                  child: Text(
                    (usernameCapitalized.length >= 15)
                        ? usernameCapitalized.substring(0, 15) + '...'
                        : usernameCapitalized,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          )),
    );
  }
}

class Preview extends StatefulWidget {
  const Preview({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    child: Hero(
                        tag: widget.user.uid,
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Text(widget.user.username),
                        )),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
