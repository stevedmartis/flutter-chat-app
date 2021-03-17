import 'package:animate_do/animate_do.dart';
import 'package:chat/bloc/catalogo_bloc.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/models/catalogo.dart';
import 'package:chat/models/catalogos_response.dart';

import 'package:chat/models/profiles.dart';
import 'package:chat/pages/catalogo_detail.dart';
import 'package:chat/pages/principalCustom_page.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/services/catalogo_service.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/header_appbar_pages.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

import 'add_update_catalogo.dart';

class CatalogosListPage extends StatefulWidget {
  @override
  _CatalogosListPagePageState createState() => _CatalogosListPagePageState();
}

class _CatalogosListPagePageState extends State<CatalogosListPage> {
  SocketService socketService;

  RoomBloc roomBlocInstance = RoomBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // roomBloc.disposeRooms();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    // final roomsModel = Provider.of<Room>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              makeHeaderCustom('Catalogos'),
              makeListCatalogos(context)
            ]),
      ),
    );
  }

  SliverList makeListCatalogos(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      CatalogsList(),
    ]));
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final catalogo = new Catalogo();

    return SliverPersistentHeader(
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: Container(
                    color: Colors.black,
                    child: CustomAppBarHeaderPages(
                      title: title,
                      isAdd: true,
                      action:
                          //   Container()
                          IconButton(
                              icon: Icon(
                                Icons.add,
                                color: currentTheme.accentColor,
                              ),
                              iconSize: 30,
                              onPressed: () => {
                                    Navigator.of(context).push(
                                        createRouteAddCatalogo(
                                            catalogo, false)),
                                  }),
                    )))));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }
}

class CatalogsList extends StatefulWidget {
  const CatalogsList({
    Key key,
  }) : super(key: key);

  @override
  _CatalogsListState createState() => _CatalogsListState();
}

class _CatalogsListState extends State<CatalogsList> {
  Profiles profile;
  final catalogoService = new CatalogoService();
  var _isVisible;

  ScrollController _hideBottomNavController;

  @override
  void initState() {
    super.initState();

    _chargeCatalogs();

    bottomControll();
  }

  _chargeCatalogs() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    catalogoBloc.getMyCatalogos(profile.user.uid);
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = this.catalogos.removeAt(oldindex);
      this.catalogos.insert(newindex, items);
    });
  }

  bottomControll() {
    _isVisible = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(
      () {
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
            });
        }
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
            });
        }
      },
    );
  }

  List<Catalogo> catalogos = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      child: StreamBuilder<CatalogosResponse>(
        stream: catalogoBloc.myCatalogos.stream,
        builder: (context, AsyncSnapshot<CatalogosResponse> snapshot) {
          if (snapshot.hasData) {
            catalogos = snapshot.data.catalogos;

            return (catalogos.length > 0)
                ? Container(child: _buildCatalogoWidget(catalogos))
                : _buildEmptyWidget(); // image is ready

          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
        height: 400.0, child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildEmptyWidget() {
    return Container(
        height: 400.0, child: Center(child: Text('Sin Catalogos, crea nuevo')));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  _deleteCatalogo(String id, int index) async {
    final res = await this.catalogoService.deleteCatalogo(id);
    if (res) {
      setState(() {
        catalogos.removeAt(index);
        catalogoBloc.getMyCatalogos(profile.user.uid);
      });
    }
  }

  Widget _buildCatalogoWidget(List<Catalogo> catalogos) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      child: ReorderableListView(
          padding: EdgeInsets.only(top: 20),
          scrollController: _hideBottomNavController,
          children: List.generate(
            catalogos.length,
            (index) {
              final item = catalogos[index];

              final privacity = (item.privacity == '1')
                  ? 'Todos'
                  : (item.privacity == '2')
                      ? 'Suscriptores'
                      : (item.privacity == '3')
                          ? 'Nadie'
                          : '';
              return Container(
                decoration: BoxDecoration(
                    color: (currentTheme.customTheme)
                        ? currentTheme.currentTheme.cardColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(0.0)),
                key: Key(item.id),
                padding: EdgeInsets.only(bottom: 1.0),
                child: Stack(
                  children: [
                    FadeInLeft(
                      delay: Duration(milliseconds: 200 * index),
                      child: GestureDetector(
                        key: Key(item.id),
                        onTap: () => {
                          Navigator.of(context)
                              .push(createRouteCatalogoDetail(item, catalogos)),
                        },
                        child: Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) =>
                                {_deleteCatalogo(item.id, index)},
                            background: Container(
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                  ],
                                )),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: SizedBox(
                                height: size.height / 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 10.0, 2.0, 0.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  item.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: (currentTheme
                                                            .customTheme)
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.users,
                                                      size: 20,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      privacity,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                        color: (currentTheme
                                                                .customTheme)
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ])),
                                    ),
                                    SizedBox(
                                        width: 50,
                                        child: Center(
                                            child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.format_list_bulleted,
                                            color: currentTheme
                                                .currentTheme.accentColor,
                                            size: 30,
                                          ),
                                        ))),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 1.0,
                      child: Center(
                        child: Container(
                          height: 1.0,
                          color:
                              currentTheme.currentTheme.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
          onReorder: (int oldIndex, int newIndex) => {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Catalogo catalogo = catalogos.removeAt(oldIndex);
                  catalogo.position = newIndex;
                  catalogos.insert(newIndex, catalogo);
                }),
                _updateCatalogo(catalogos, newIndex, context, profile.user.uid)
              }),
    );
  }
}

_updateCatalogo(
    List<Catalogo> catalogos, int newIndex, context, String userId) async {
  final catalogoService = Provider.of<CatalogoService>(context, listen: false);

  final resp =
      await catalogoService.updatePositionCatalogo(catalogos, newIndex, userId);

  if (resp) {
    catalogoBloc.getMyCatalogos(userId);
  }
}

Route createRouteProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}

Route createRouteCatalogoDetail(Catalogo catalogo, List<Catalogo> catalogos) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        CatalogoDetailPage(catalogo: catalogo, catalogos: catalogos),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}

Route createRouteAddCatalogo(Catalogo catalogo, bool isEdit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddUpdateCatalogoPage(catalogo: catalogo, isEdit: isEdit),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}
