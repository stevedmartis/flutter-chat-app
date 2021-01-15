import 'dart:async';

import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/room_bloc.dart';

import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';
import 'package:chat/pages/add_room.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/pages/room_detail.dart';

import 'package:chat/services/room_services.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/button_gold.dart';
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
  final roomService = new RoomService();
  List<Room> rooms = [];
  Future<List<Room>> getJobFuture;
  Profiles profile;
  ScrollController _hideBottomNavController;

  var _isVisible;

  @override
  void initState() {
    super.initState();

    this._chargeRooms();
    this.bottomControll();
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

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = this.rooms.removeAt(oldindex);
      this.rooms.insert(newindex, items);
    });
  }

  _chargeRooms() async {
    // this.rooms = await roomService.getRoomsUser();

    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    getJobFuture = roomService.getRoomsUser(profile.user.uid);
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    // final roomsModel = Provider.of<Room>(context);
    final room = new Room();
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigation(isVisible: _isVisible),
        appBar: AppBar(
            title: Text(
              'My rooms',
              style: TextStyle(),
            ),
            backgroundColor: Colors.black,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: currentTheme.accentColor,
                    ),
                    iconSize: 30,
                    onPressed: () => {
                          Navigator.of(context).push(createRouteAddRoom(room)),
                        }),
              )
            ],
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: currentTheme.accentColor,
              ),
              iconSize: 30,
              onPressed: () => {
                setState(() {
                  Provider.of<MenuModel>(context, listen: false).currentPage =
                      0;
                }),
                Navigator.pop(context),
              },
              color: Colors.white,
            )),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: FutureBuilder(
              future: getJobFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                      height: 400.0,
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  rooms = snapshot.data;

                  if (rooms.length < 1) {
                    return Center(
                      child: Text('No rooms, create a new'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ReorderableListView(
                        scrollController: _hideBottomNavController,
                        children: List.generate(
                          rooms.length,
                          (index) {
                            final item = rooms[index];
                            return GestureDetector(
                              key: ValueKey(item),
                              onTap: () => Navigator.of(context)
                                  .push(createRouteRoomDetail(item)),
                              child: Card(
                                key: ValueKey(item),
                                color: Colors.black,
                                child: Dismissible(
                                  key: Key(item.id),
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (_) =>
                                      {_deleteRoom(item.id, index)},
                                  background: Container(
                                      padding: EdgeInsets.only(left: 8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      )),
                                  child: ListTile(
                                    selectedTileColor: currentTheme.accentColor,
                                    focusColor: currentTheme.accentColor,
                                    hoverColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white, width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    visualDensity: VisualDensity.comfortable,
                                    title: Text(item.name),
                                    subtitle: Text(
                                      '10 productos',
                                      style: TextStyle(
                                          color: currentTheme
                                              .secondaryHeaderColor),
                                    ),
                                    leading: Icon(
                                      Icons.drag_indicator,
                                      color: currentTheme.accentColor,
                                    ),
                                  ),
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
                                final Room item =
                                    snapshot.data.removeAt(oldIndex);
                                item.position = newIndex;
                                snapshot.data.insert(newIndex, item);

                                print(snapshot.data);
                              }),
                              _updateRoom(snapshot.data, newIndex, context,
                                  profile.user.uid)
                            }),
                  );
                }
              }),
        ),
        /*  floatingActionButton: (FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  var j = Room(name: 'sfddsfsdf', description: 'sdfsdf');
                  rooms.add(j);
                });
              }) */
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _deleteRoom(String id, int index) async {
    setState(() {
      rooms.removeAt(index);
    });

    final res = await this.roomService.deleteRoom(id);

    if (res) {
      roomBloc.getRooms(profile.user.uid);
    }
  }

  addNewRoom() {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;

    final bloc = CustomProvider.roomBlocIn(context);

    final size = MediaQuery.of(context).size;

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: currentTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: 20, left: size.width / 3.5, right: size.width / 3.5),
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Color(0xffEBECF0).withOpacity(0.30),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "New Room",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                _createName(bloc),
                SizedBox(
                  height: 30,
                ),
                _createDescription(bloc),
                SizedBox(
                  height: 40,
                ),
                ButtonAccent(
                  color: currentTheme.accentColor,
                  text: 'Done',
                  onPressed: () => {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _createName(RoomBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.yellow, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Name',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createDescription(RoomBloc bloc) {
    return StreamBuilder(
      stream: bloc.descriptionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.yellow, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Description',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDescription,
          ),
        );
      },
    );
  }
}

_updateRoom(List<Room> room, int newIndex, context, String userId) async {
  final roomService = Provider.of<RoomService>(context, listen: false);

  final resp = await roomService.updatePositionRoom(room, newIndex, userId);

  if (resp) {
    roomBloc.getRooms(userId);
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

Route createRouteRoomDetail(Room room) {
  print(room);
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        RoomDetailPage(room: room),
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

Route createRouteAddRoom(Room room) {
  print(room);
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddRoomPage(room),
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
