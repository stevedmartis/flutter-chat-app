import 'dart:io';

import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/room_bloc.dart';

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';

import 'package:chat/services/room_services.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    this._chargeUsers();
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

  _chargeUsers() async {
    // this.rooms = await roomService.getRoomsUser();

    getJobFuture = roomService.getRoomsUser();
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
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
                          setState(() {
                            addNewRoom();
                          })
                        }),
              )
            ],
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: currentTheme.accentColor,
              ),
              iconSize: 30,
              onPressed: () => Navigator.pop(context),
              color: Colors.white,
            )),
        body: FutureBuilder(
            future: getJobFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text('Loading');
              } else {
                rooms = snapshot.data;

                if (rooms.length < 1) {
                  return Center(
                    child: Text('No Messages, Create New one'),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ReorderableListView(
                      children: List.generate(
                        rooms.length,
                        (index) {
                          final item = rooms[index];
                          return Card(
                            color: Colors.black,
                            key: ValueKey(item),
                            child: ListTile(
                              trailing: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: Icon(
                                  Icons.add,
                                  color: currentTheme.accentColor,
                                ),
                              ),
                              selectedTileColor: currentTheme.accentColor,
                              focusColor: currentTheme.accentColor,
                              hoverColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white, width: 0.5),
                                  borderRadius: BorderRadius.circular(0.5)),
                              visualDensity: VisualDensity.comfortable,
                              title: Text(item.name),
                              subtitle: Text(
                                '10 productos',
                                style: TextStyle(
                                    color: currentTheme.secondaryHeaderColor),
                              ),
                              leading: Icon(
                                Icons.drag_handle,
                                color: currentTheme.accentColor,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = snapshot.data.removeAt(oldIndex);
                          snapshot.data.insert(newIndex, item);
                        });
                      }),
                );
              }
            }),
        floatingActionButton: (FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                var j = Room(name: 'sfddsfsdf', description: 'sdfsdf');
                rooms.add(j);
              });
            })));
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleAddRoom(BuildContext context) async {
    final roomService = Provider.of<RoomService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final bloc = CustomProvider.roomBlocIn(context);

    print('================');
    print('name: ${bloc.name}');
    print('desc: ${bloc.description}');
    print('================');

    final room = new Room(
        name: bloc.name,
        description: bloc.description,
        id: authService.profile.user.uid);
    rooms.add(room);
    final addRoomOk = await roomService.createRoom(room);

    if (addRoomOk != null) {
      if (addRoomOk == true) {
        //socketService.connect();
        //Navigator.push(context, _createRute());

        Navigator.pop(context);
      } else {
        mostrarAlerta(context, 'Registro incorrecto', addRoomOk);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  Widget _bandTile(Room band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
      background: Container(
          padding: EdgeInsets.only(left: 8.0),
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Delete Band', style: TextStyle(color: Colors.white)),
          )),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('', style: TextStyle(fontSize: 20)),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewRoom() {
    final textController = new TextEditingController();

    final bloc = CustomProvider.roomBlocIn(context);
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;

    if (Platform.isAndroid) {
      // Android
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                title: Text('New Room:'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // _createName(bloc),
                    SizedBox(
                      height: 10,
                    ),
                    //_createName(bloc),
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                      child: Text('Done'),
                      elevation: 5,
                      textColor: Colors.blue,
                      onPressed: () => setState(() {
                            _handleAddRoom(context);
                          }))
                ],
              ));
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('New Room:'),
              content: Material(
                  color: Color(0xff131313),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(20),
                          child: _createName(bloc)),
                    ],
                  )),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white.withOpacity(0.60)),
                    ),
                    onPressed: () => Navigator.pop(context)),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('Done'),
                    onPressed: () => setState(() {
                          _handleAddRoom(context);
                        })),
              ],
            ));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }
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
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Name',
              counterText: snapshot.data,
              errorText: snapshot.error),
          onChanged: bloc.changeName,
        ),
      );
    },
  );
}
