import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:chat/bloc/room_bloc.dart';

import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/pages/add_room.dart';
import 'package:chat/pages/principalCustom_page.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/pages/room_detail.dart';

import 'package:chat/services/room_services.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/header_appbar_pages.dart';
import 'package:chat/widgets/room_card.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

class RoomsListPage extends StatefulWidget {
  @override
  _RoomsListPageState createState() => _RoomsListPageState();
}

class _RoomsListPageState extends State<RoomsListPage> {
  SocketService socketService;

  RoomBloc roomBlocInstance = RoomBloc();

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
    // final roomsModel = Provider.of<Room>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              makeHeaderCustom('Rooms'),
              makeListRooms(context)
            ]),
      ),
    );
  }

  SliverList makeListRooms(
    context,
  ) {
    return SliverList(
        delegate: SliverChildListDelegate([
      RoomList(),
    ]));
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final room = new Room();

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
                                    Navigator.of(context)
                                        .push(createRouteAddRoom(room, false)),
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

class RoomList extends StatefulWidget {
  const RoomList({
    Key key,
  }) : super(key: key);

  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  Profiles profile;
  final roomService = new RoomService();
  var _isVisible;

  Stream roomList;

  Future<List<Room>> getJobFuture;

  ScrollController _hideBottomNavController;

  @override
  void initState() {
    super.initState();

    _chargeRooms();

    bottomControll();
  }

  _chargeRooms() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    roomBloc.getMyRooms(profile.user.uid);
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = this.rooms.removeAt(oldindex);
      this.rooms.insert(newindex, items);
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

  List<Room> rooms = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      child: StreamBuilder<RoomsResponse>(
        stream: roomBloc.myRooms.stream,
        builder: (context, AsyncSnapshot<RoomsResponse> snapshot) {
          if (snapshot.hasData) {
            rooms = snapshot.data.rooms;

            if (rooms.length > 0) {
              return Container(child: _buildRoomWidget(rooms));
            } else {
              return _buildEmptyWidget();
            }
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
        height: 400.0, child: Center(child: Text('Sin Rooms, crea nuevo')));
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

  _deleteRoom(String id, int index) async {
    final res = await this.roomService.deleteRoom(id);
    if (res) {
      setState(() {
        rooms.removeAt(index);
        roomBloc.getMyRooms(profile.user.uid);
      });
    }
  }

  Widget _buildRoomWidget(List<Room> rooms) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      child: ReorderableListView(
          padding: EdgeInsets.only(top: 20),
          scrollController: _hideBottomNavController,
          children: List.generate(
            rooms.length,
            (index) {
              final item = rooms[index];
              return Container(
                decoration: BoxDecoration(
                    color: (currentTheme.customTheme)
                        ? currentTheme.currentTheme.cardColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(0.0)),
                key: Key(item.id),
                padding: EdgeInsets.only(bottom: 1.0),
                child: FadeInLeft(
                  delay: Duration(milliseconds: 300 * index),
                  child: Stack(
                    children: [
                      GestureDetector(
                        key: Key(item.id),
                        onTap: () => {
                          Navigator.of(context)
                              .push(createRouteRoomDetail(item, rooms)),
                        },
                        child: Dismissible(
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Eliminar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: const Text(
                                      "Desea eliminar el Room y todos sus registros?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text(
                                          "Eliminar",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancelar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) =>
                              {_deleteRoom(item.id, index)},
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
                                  /* Text(
                                    'Delete',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ) */
                                ],
                              )),
                          child: CustomListItemTwoRoom(
                            title: item.name,
                            subtitle: item.description,
                            wide: '${item.wide}',
                            long: '${item.long}',
                            tall: '${item.tall}',
                            timeOn: item.timeOn,
                            timeOff: item.timeOff,
                            publishDate: 'Dec 28',
                            readDuration: '5 mins',
                            totalPlants: item.totalPlants,
                            totalAirs: item.totalAirs,
                            totalLigths: item.totalLights,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                        child: Center(
                          child: Container(
                            height: 1.0,
                            color: currentTheme
                                .currentTheme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
          onReorder: (int oldIndex, int newIndex) => {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Room item = rooms.removeAt(oldIndex);
                  item.position = newIndex;
                  rooms.insert(newIndex, item);
                }),
                _updateRoom(rooms, newIndex, context, profile.user.uid)
              }),
    );
  }
}

_updateRoom(List<Room> room, int newIndex, context, String userId) async {
  final roomService = Provider.of<RoomService>(context, listen: false);

  final resp = await roomService.updatePositionRoom(room, newIndex, userId);

  if (resp) {
    roomBloc.getMyRooms(userId);
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

Route createRouteRoomDetail(Room room, List<Room> rooms) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        RoomDetailPage(room: room, rooms: rooms),
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

Route createRouteAddRoom(Room room, bool isEdit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddRoomPage(room: room, isEdit: isEdit),
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
