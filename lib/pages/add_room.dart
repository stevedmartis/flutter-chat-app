import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/room.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/room_services.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:date_format/date_format.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddRoomPage extends StatefulWidget {
  AddRoomPage(this.room);

  final Room room;
  @override
  AddRoomPagePageState createState() => AddRoomPagePageState();
}

class AddRoomPagePageState extends State<AddRoomPage> {
  Future<ui.Image> image(String url) async =>
      await NetworkImageDecoder(image: NetworkImage(url)).uiImage;

  final nameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();

  bool isNameChange = false;
  bool isAboutChange = false;

  bool isSwitchedCo2 = false;
  bool isSwitchedCo2Complete = false;

  String dropdownValue = 'None';

  //double _height;
  // double _width;

  // String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  // TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', mm, " ", am]).toString();
      });
  }

  @override
  void initState() {
    nameCtrl.text = widget.room.name;
    aboutCtrl.text = widget.room.description;

    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;
      });
    });
    aboutCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.description != aboutCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });

      _timeController.text = formatDate(
          DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
          [hh, ':', nn, " ", am]).toString();
    });

    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    aboutCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final bloc = CustomProvider.roomBlocIn(context);
    //final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          _createButton(bloc, this.isAboutChange, this.isNameChange),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.accentColor,
          ),
          iconSize: 30,
          onPressed: () =>
              //  Navigator.pushReplacement(context, createRouteProfile()),
              Navigator.pop(context),
          color: Colors.white,
        ),
        title: Text('New Room'),
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          //  _snapAppbar();
          // if (_scrollController.offset >= 250) {}
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              // controller: _scrollController,
              slivers: <Widget>[
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                      child: Column(
                        children: <Widget>[
                          _createName(bloc),
                          SizedBox(
                            height: 10,
                          ),

                          _createDescription(bloc),
                          SizedBox(
                            height: 10,
                          ),
                          _createVentilation(bloc),
                          SizedBox(
                            height: 10,
                          ),
                          // _createLastName(bloc),
                          _createCo2(bloc),
                          SizedBox(
                            height: 10,
                          ),

                          if (isSwitchedCo2) _createCo2Control(bloc),
                          SizedBox(
                            height: 10,
                          ),

                          _createWhats(bloc),
                          SizedBox(
                            height: 10,
                          ),
                          _createKelvin(bloc),

                          SizedBox(
                            height: 10,
                          ),
                          _createTypeLight(bloc),
                          SizedBox(
                            height: 10,
                          ),

// inside Widget build
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _timeController,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: 'Time on',
                                  prefixIcon: Icon(
                                    Icons.wb_incandescent,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _timeController,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  hintText: 'Time off',
                                  prefixIcon: Icon(
                                    Icons.bedtime,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ]),
        ),
      ),
    );
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
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
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
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

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
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
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

  Widget _createVentilation(RoomBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.ventilationStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          height: 60,
          width: size.width,
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: Container(child: Icon(Icons.expand_more)),
            iconSize: 24,
            elevation: 50,
            style: TextStyle(
                color: (dropdownValue == 'None')
                    ? Colors.white.withOpacity(0.65)
                    : currentTheme.accentColor),
            underline: Container(
              height: 1.5,
              color: Colors.white.withOpacity(0.30),
            ),
            onChanged: (String newValue) {
              FocusScope.of(context).unfocus();
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['None', 'Ventilador', 'Extracción', 'Intractor']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _createKelvin(RoomBloc bloc) {
    // final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.kelvinStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Kelvin',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeKelvin,
          ),
        );
      },
    );
  }

  Widget _createWhats(RoomBloc bloc) {
    //final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.wattsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Watts',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeWatts,
          ),
        );
      },
    );
  }

  Widget _createCo2(RoomBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.co2Stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Co2',
            style: TextStyle(color: Colors.white.withOpacity(0.60)),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.accentColor,
            value: isSwitchedCo2,
            onChanged: (value) {
              setState(() {
                isSwitchedCo2 = value;
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createCo2Control(RoomBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.co2CompleteStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text('Co2 Controlado',
              style: TextStyle(color: Colors.white.withOpacity(0.60))),
          trailing: Switch.adaptive(
            activeColor: currentTheme.accentColor,
            value: isSwitchedCo2Complete,
            onChanged: (value) {
              setState(() {
                isSwitchedCo2Complete = value;
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createTypeLight(RoomBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.typeLightStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Type Light',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeTypeLight,
          ),
        );
      },
    );
  }

  Widget _createButton(
    RoomBloc bloc,
    bool isAboutChange,
    bool isNameChange,
  ) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // final authService = Provider.of<AuthService>(context);
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        final isControllerChange = isNameChange || isAboutChange;

        final isInvalid = snapshot.hasError;

        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                      color: isControllerChange && !isInvalid
                          ? currentTheme.accentColor
                          : Colors.white.withOpacity(0.30),
                      fontSize: 15),
                ),
              ),
            ),
            onTap: isControllerChange && !isInvalid
                ? () =>
                    {FocusScope.of(context).unfocus(), _editRoom(bloc, context)}
                : null);
      },
    );
  }

  _editRoom(RoomBloc bloc, BuildContext context) async {
    final roomService = Provider.of<RoomService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthService>(context);
    final profile = authService.profile;
    final name = (bloc.name == null) ? widget.room.name : bloc.name.trim();
    final description = (bloc.description == null)
        ? widget.room.description
        : bloc.description.trim();

    final room = new Room(
      name: name,
      description: description,
    );
    final editRoomRes = await roomService.createRoom(room, profile.user.uid);

    if (editRoomRes != null) {
      if (editRoomRes == true) {
        socketService.connect();

        Navigator.push(context, createRoute());
      } else {
        mostrarAlerta(context, 'Error', editRoomRes);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }
}

Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-0.5, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
