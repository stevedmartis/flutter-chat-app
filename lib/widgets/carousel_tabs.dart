import 'package:chat/models/catalogo.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/usuario.dart';

import 'package:chat/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils//extension.dart';

class TabsScrollCustom extends StatefulWidget {
  const TabsScrollCustom({Key key, @required this.rooms, this.isAuthUser})
      : super(key: key);

  final List<Room> rooms;
  final bool isAuthUser;

  @override
  _TabsScrollCustomState createState() => _TabsScrollCustomState();
}

class _TabsScrollCustomState extends State<TabsScrollCustom> {
  int currentIndexTab = 0;

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final rooms = widget.rooms;

    return Container(
      decoration: BoxDecoration(
        color: currentTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black54,
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: Offset(0.5, 0.5))
        ],
      ),
      child: DefaultTabController(
          length: rooms.length,
          child: PreferredSize(
            preferredSize: Size.fromHeight(600.0),
            child: TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: currentTheme.accentColor,
              tabs: List<Widget>.generate(rooms.length, (int index) {
                final room = rooms[index];

                final name = room.name;
                final nameCapitalized = name.capitalize();
                return new Tab(
                  child: Text(
                    (nameCapitalized.length >= 15)
                        ? nameCapitalized.substring(0, 15) + '...'
                        : nameCapitalized,
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

class TabsScrollCatalogoCustom extends StatefulWidget {
  const TabsScrollCatalogoCustom(
      {Key key, @required this.catalogos, this.isAuthUser})
      : super(key: key);

  final List<Catalogo> catalogos;
  final bool isAuthUser;

  @override
  _TabsScrollCatalogosCustomState createState() =>
      _TabsScrollCatalogosCustomState();
}

class _TabsScrollCatalogosCustomState extends State<TabsScrollCatalogoCustom> {
  int currentIndexTab = 0;

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final catalogos = widget.catalogos;

    return Container(
      decoration: BoxDecoration(
        color: currentTheme.currentTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black54,
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: Offset(0.5, 0.5))
        ],
      ),
      child: DefaultTabController(
          length: catalogos.length,
          child: Scaffold(
            appBar: AppBar(
                backgroundColor:
                    currentTheme.currentTheme.scaffoldBackgroundColor,
                bottom: TabBar(
                    indicatorWeight: 3,
                    isScrollable: true,
                    labelColor: currentTheme.currentTheme.accentColor,
                    unselectedLabelColor: (currentTheme.customTheme)
                        ? Colors.white54.withOpacity(0.30)
                        : currentTheme.currentTheme.primaryColor,
                    indicatorColor: currentTheme.currentTheme.accentColor,
                    tabs: List<Widget>.generate(catalogos.length, (int index) {
                      final catalogo = catalogos[index];

                      final name = catalogo.name;
                      final nameCapitalized = name.capitalize();
                      return new Tab(
                        child: Text(
                          (nameCapitalized.length >= 15)
                              ? nameCapitalized.substring(0, 15) + '...'
                              : nameCapitalized,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                    onTap: (value) => {
                          setState(() {
                            currentIndexTab = value;
                          })
                        })),
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
                        child: Material(
                          type: MaterialType.transparency,
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Text(widget.user.username),
                          ),
                        )),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
