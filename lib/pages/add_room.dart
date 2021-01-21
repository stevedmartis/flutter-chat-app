import 'dart:async';

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
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:date_format/date_format.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddRoomPage extends StatefulWidget {
  AddRoomPage({this.room, this.rooms, this.isEdit});

  final Room room;
  final bool isEdit;

  final List<Room> rooms;

  @override
  AddRoomPagePageState createState() => AddRoomPagePageState();
}

class AddRoomPagePageState extends State<AddRoomPage> {
  Future<ui.Image> image(String url) async =>
      await NetworkImageDecoder(image: NetworkImage(url)).uiImage;

  final nameCtrl = TextEditingController();

  final descriptionCtrl = TextEditingController();

  var tallCtrl = new MaskedTextController(mask: '0.00');
  var wideCtrl = new MaskedTextController(mask: '0.00');

  var longCtrl = new MaskedTextController(mask: '0.00');

  bool isNameChange = false;
  bool isAboutChange = false;
  bool isWideChange = false;
  bool isLongChange = false;
  bool isTallChange = false;

  bool isTimeOnChange = false;
  bool isTimeOffChange = false;

  bool isSwitchedCo2 = false;
  bool isSwitchedCo2Control = false;

  bool isCo2Change = false;
  bool isCo2ControlChange = false;

  String dropdownValue = 'Ventilación';

  String _hourOn, _minuteOn, _timeOn;

  String _hourOff, _minuteOff, _timeOff;

  TimeOfDay selectedTimeOn = TimeOfDay(hour: 00, minute: 00);

  TimeOfDay selectedTimeOff = TimeOfDay(hour: 00, minute: 00);

  // TextEditingController _dateController = TextEditingController();
  TextEditingController _timeOnController = TextEditingController();
  TextEditingController _timeOffController = TextEditingController();

  Future<Null> _selectTimeOn(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTimeOn,
    );
    if (picked != null)
      setState(() {
        selectedTimeOn = picked;
        _hourOn = selectedTimeOn.hour.toString();
        _minuteOn = selectedTimeOn.minute.toString();
        _timeOn = _hourOn + ' : ' + _minuteOn;
        _timeOnController.text = _timeOn;
        _timeOnController.text = formatDate(
            DateTime(2021, 15, 1, selectedTimeOn.hour, selectedTimeOn.minute),
            [hh, ':', _minuteOn, " ", am]).toString();
      });
  }

  Future<Null> _selectTimeOff(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final TimeOfDay pickedOff = await showTimePicker(
      context: context,
      initialTime: selectedTimeOff,
    );
    if (pickedOff != null)
      setState(() {
        selectedTimeOff = pickedOff;
        _hourOff = selectedTimeOff.hour.toString();
        _minuteOff = selectedTimeOff.minute.toString();
        _timeOff = _hourOff + ' : ' + _minuteOff;
        _timeOffController.text = _timeOff;

        _timeOffController.text = formatDate(
            DateTime(2021, 1, 18, selectedTimeOff.hour, selectedTimeOff.minute),
            [hh, ':', _minuteOff, " ", am]).toString();
      });
  }

  @override
  void initState() {
    nameCtrl.text = widget.room.name;
    descriptionCtrl.text = widget.room.description;
    wideCtrl.text = widget.room.wide.toString();
    longCtrl.text = widget.room.long.toString();
    tallCtrl.text = widget.room.tall.toString();

    _timeOnController.text = widget.room.timeOn;
    _timeOffController.text = widget.room.timeOff;

    isSwitchedCo2 = widget.room.co2;

    isSwitchedCo2 = widget.room.co2Control;

    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;
      });
    });
    descriptionCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.description != descriptionCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });
    wideCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.wide.toString() != wideCtrl.text)
          this.isWideChange = true;
        else
          this.isWideChange = false;
      });
    });
    longCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.long.toString() != longCtrl.text)
          this.isLongChange = true;
        else
          this.isLongChange = false;
      });
    });
    tallCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.tall.toString() != tallCtrl.text)
          this.isTallChange = true;
        else
          this.isTallChange = false;
      });
    });

    _timeOnController.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.timeOn.toString() != _timeOnController.text)
          this.isTimeOnChange = true;
        else
          this.isTimeOnChange = false;
      });
    });

    _timeOffController.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.timeOn.toString() != _timeOffController.text)
          this.isTimeOffChange = true;
        else
          this.isTimeOffChange = false;
      });
    });

    _timeOffController.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.timeOn.toString() != _timeOffController.text)
          this.isTimeOffChange = true;
        else
          this.isTimeOffChange = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    wideCtrl.dispose();
    longCtrl.dispose();
    tallCtrl.dispose();
    descriptionCtrl.dispose();
    _timeOnController.dispose();
    _timeOffController.dispose();
    roomBloc.disposeRooms();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final bloc = CustomProvider.roomBlocIn(context);
    //final size = MediaQuery.of(context).size;

    final timeOn = _timeOnController.text == "" ? false : true;
    final timeOff = _timeOffController.text == "" ? false : true;

    final isControllerChange = isNameChange && isAboutChange ||
        isWideChange && isLongChange && isTallChange && timeOn && timeOff;

    final isControllerChangeEdit = isNameChange ||
        isAboutChange ||
        isWideChange ||
        isLongChange ||
        isTallChange ||
        isTimeOnChange ||
        isTimeOffChange ||
        isCo2Change ||
        isCo2ControlChange;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          (widget.isEdit)
              ? _createButton(bloc, isControllerChangeEdit)
              : _createButton(bloc, isControllerChange),
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
        title: (widget.isEdit) ? Text('Edit room') : Text('New room'),
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
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Column(
                        children: <Widget>[
                          _createName(bloc),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(child: _createWide(bloc)),
                              Expanded(child: _createLong(bloc)),
                              Expanded(child: _createTall(bloc)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      width: 50, child: _createCo2(bloc))),
                              Expanded(child: _createCo2Control(bloc)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectTimeOn(context),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _timeOnController,
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
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectTimeOff(context),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _timeOffController,
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _createDescription(bloc),
                          SizedBox(
                            height: 10,
                          ),
                          /*   _createVentilation(bloc),
                          SizedBox(
                            height: 10,
                          ), */
                          // _createLastName(bloc),

                          /*     _createTypeLight(bloc),
                          SizedBox(
                            height: 10,
                          ), */

                          /*  _createWhats(bloc),
                          SizedBox(
                            height: 10,
                          ), */
                          /*   _createKelvin(bloc), */

// inside Widget build

                          /*   _createDescription(bloc), */
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
            controller: nameCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(30),
            ],
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
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
            inputFormatters: [
              new LengthLimitingTextInputFormatter(100),
            ],
            controller: descriptionCtrl,
            //  keyboardType: TextInputType.emailAddress,

            maxLines: 2,
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

/* 
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
                fontSize: 17,
                color: (dropdownValue == 'Ventilación')
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
            items: <String>[
              'Ventilación',
              'Ventilador',
              'Extracción',
              'Intractor',
              'Aire acondicionado'
            ].map<DropdownMenuItem<String>>((String value) {
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
 */
  Widget _createWide(RoomBloc bloc) {
    //final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.wideStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            onTap: () =>
                {if (wideCtrl.text == "0") wideCtrl.text = "", setState(() {})},
            controller: wideCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Wide',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeWide,
          ),
        );
      },
    );
  }

/*   Widget _createWhats(RoomBloc bloc) {
    //final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.wattsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Watts total',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeWatts,
          ),
        );
      },
    );
  }
 */
  Widget _createLong(RoomBloc bloc) {
    //final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.longStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            onTap: () =>
                {if (longCtrl.text == "0") longCtrl.text = "", setState(() {})},
            controller: longCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Long',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeLong,
          ),
        );
      },
    );
  }

  Widget _createTall(RoomBloc bloc) {
    //final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.tallStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            onTap: () =>
                {if (tallCtrl.text == "0") tallCtrl.text = "", setState(() {})},
            controller: tallCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Tall',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeTall,
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

                if (!isSwitchedCo2) {
                  isSwitchedCo2Control = false;
                }

                if (isSwitchedCo2 != widget.room.co2) {
                  this.isCo2Change = true;
                } else {
                  this.isCo2Change = false;
                }
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
          title: Text('Timer',
              style: TextStyle(
                color: (isSwitchedCo2)
                    ? Colors.white.withOpacity(0.60)
                    : Colors.white.withOpacity(0.30),
              )),
          trailing: Switch.adaptive(
            activeColor: currentTheme.accentColor,
            value: isSwitchedCo2Control,
            inactiveTrackColor: Colors.white.withOpacity(0.30),
            inactiveThumbColor: Colors.white.withOpacity(0.30),
            onChanged: (value) {
              setState(() {
                if (isSwitchedCo2) {
                  isSwitchedCo2Control = !isSwitchedCo2Control;
                }

                if (isSwitchedCo2Control != widget.room.co2Control) {
                  this.isCo2ControlChange = true;
                } else {
                  this.isCo2ControlChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

/*   Widget _createTypeLight(RoomBloc bloc) {
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
 */
  Widget _createButton(
    RoomBloc bloc,
    bool isControllerChange,
  ) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

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
                      fontSize: 18),
                ),
              ),
            ),
            onTap: isControllerChange && !isInvalid
                ? () => {
                      FocusScope.of(context).unfocus(),
                      (widget.isEdit) ? _editRoom(bloc) : _createRoom(bloc),
                    }
                : null);
      },
    );
  }

  _createRoom(RoomBloc bloc) async {
    final roomService = Provider.of<RoomService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final profile = authService.profile;

    final name = (bloc.name == null) ? widget.room.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.room.description
        : bloc.description.trim();

    final wide = (bloc.wide == null) ? widget.room.wide : bloc.wide.trim();
    final long = (bloc.long == null) ? widget.room.long : bloc.long.trim();
    final tall = (bloc.tall == null) ? widget.room.tall : bloc.tall.trim();

    final co2 = isSwitchedCo2;
    final co2Control = isSwitchedCo2Control;

    final timeOn = _timeOnController.text;
    final timeOff = _timeOffController.text;

    final newRoom = new Room(
        name: name,
        description: description,
        wide: wide,
        long: long,
        tall: tall,
        co2: co2,
        co2Control: co2Control,
        timeOn: timeOn,
        timeOff: timeOff,
        user: profile.user.uid);

    print(newRoom);

    final createRoomRes = await roomService.createRoom(newRoom);

    if (createRoomRes != null) {
      if (createRoomRes.ok) {
        socketService.connect();

        widget.rooms.add(createRoomRes.room);
        setState(() {});

        roomBloc.getRooms(profile.user.uid);
        Navigator.pop(context);
      } else {
        mostrarAlerta(context, 'Error', createRoomRes.msg);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editRoom(RoomBloc bloc) async {
    final roomService = Provider.of<RoomService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final profile = authService.profile;
    final name = (bloc.name == null) ? widget.room.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.room.description
        : descriptionCtrl.text.trim();

    final wide = (bloc.wide == null) ? widget.room.wide : bloc.wide.trim();
    final long = (bloc.long == null) ? widget.room.long : bloc.long.trim();
    final tall = (bloc.tall == null) ? widget.room.tall : bloc.tall.trim();

    final co2 = isSwitchedCo2;
    final co2Control = isSwitchedCo2Control;

    final timeOn = _timeOnController.text;
    final timeOff = _timeOffController.text;

    final newRoom = new Room(
        name: name,
        description: description,
        wide: wide,
        long: long,
        tall: tall,
        co2: co2,
        co2Control: co2Control,
        timeOn: timeOn,
        timeOff: timeOff,
        id: widget.room.id);

    print(newRoom);

    if (widget.isEdit) {
      final editRoomRes = await roomService.editRoom(newRoom);

      if (editRoomRes != null) {
        if (editRoomRes.ok) {
          // widget.rooms.removeWhere((element) => element.id == editRoomRes.room.id)
          setState(() {});
          // room = editRoomRes.room;
          roomBloc.getRoom(editRoomRes.room);
          roomBloc.getRooms(profile.user.uid);
          Navigator.pop(context);
        } else {
          mostrarAlerta(context, 'Error', editRoomRes.msg);
        }
      } else {
        mostrarAlerta(
            context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
      }
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
