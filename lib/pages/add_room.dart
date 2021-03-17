import 'dart:async';

import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/room.dart';
import 'package:chat/pages/profile_page.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/room_services.dart';
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
  bool loading = false;
  bool errorRequired = false;

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
    errorRequired = (widget.isEdit) ? false : true;
    nameCtrl.text = widget.room.name;
    descriptionCtrl.text = widget.room.description;
    wideCtrl.text = widget.room.wide.toString();
    longCtrl.text = widget.room.long.toString();
    tallCtrl.text = widget.room.tall.toString();

    _timeOnController.text = widget.room.timeOn;
    _timeOffController.text = widget.room.timeOff;

    isSwitchedCo2 = widget.room.co2;

    isSwitchedCo2Control = widget.room.co2Control;

    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;

        if (nameCtrl.text == "")
          errorRequired = true;
        else
          errorRequired = false;
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

        if (wideCtrl.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });
    longCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.long.toString() != longCtrl.text)
          this.isLongChange = true;
        else
          this.isLongChange = false;

        if (longCtrl.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });
    tallCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.tall.toString() != tallCtrl.text)
          this.isTallChange = true;
        else
          this.isTallChange = false;
        if (tallCtrl.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });

    _timeOnController.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.timeOn.toString() != _timeOnController.text)
          this.isTimeOnChange = true;
        else
          this.isTimeOnChange = false;

        if (_timeOnController.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });

    _timeOffController.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.room.timeOn.toString() != _timeOffController.text)
          this.isTimeOffChange = true;
        else
          this.isTimeOffChange = false;

        if (_timeOffController.text == "")
          errorRequired = true;
        else
          errorRequired = false;
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
    // roomBloc.disposeRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

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
      backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            (currentTheme.customTheme) ? Colors.black : Colors.white,
        actions: [
          if (!loading)
            (widget.isEdit)
                ? _createButton(bloc, isControllerChangeEdit)
                : _createButton(bloc, isControllerChange)
          else
            _buildLoadingWidget()
        ],
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.currentTheme.accentColor,
          ),
          iconSize: 30,
          onPressed: () =>
              //  Navigator.pushReplacement(context, createRouteProfile()),
              Navigator.pop(context),
          color: Colors.white,
        ),
        title: (widget.isEdit)
            ? Text(
                'Edit room',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
              )
            : Text(
                'Crear room',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
              ),
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
                                      style: TextStyle(
                                        color: (currentTheme.customTheme)
                                            ? Colors.white54
                                            : Colors.black54,
                                      ),
                                      controller: _timeOnController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (currentTheme.customTheme)
                                                ? Colors.white54
                                                : Colors.black54,
                                          ),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        labelStyle: TextStyle(
                                          color: (currentTheme.customTheme)
                                              ? Colors.white54
                                              : Colors.black54,
                                        ),
                                        // icon: Icon(Icons.perm_identity),
                                        //  fillColor: currentTheme.accentColor,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: currentTheme
                                                  .currentTheme.accentColor,
                                              width: 2.0),
                                        ),
                                        labelText: 'Hora apagada *',

                                        prefixIcon: Icon(Icons.wb_incandescent,
                                            color: (currentTheme.customTheme)
                                                ? Colors.white54
                                                : Colors.black54),

                                        //labelText: 'Ancho *',

                                        //counterText: snapshot.data,
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
                                      style: TextStyle(
                                        color: (currentTheme.customTheme)
                                            ? Colors.white54
                                            : Colors.black54,
                                      ),
                                      controller: _timeOffController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: (currentTheme.customTheme)
                                                ? Colors.white54
                                                : Colors.black54,
                                          ),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        labelStyle: TextStyle(
                                          color: (currentTheme.customTheme)
                                              ? Colors.white54
                                              : Colors.black54,
                                        ),
                                        // icon: Icon(Icons.perm_identity),
                                        //  fillColor: currentTheme.accentColor,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: currentTheme
                                                  .currentTheme.accentColor,
                                              width: 2.0),
                                        ),
                                        labelText: 'Hora encendida *',

                                        prefixIcon: Icon(Icons.bedtime,
                                            color: (currentTheme.customTheme)
                                                ? Colors.white54
                                                : Colors.black54),

                                        //labelText: 'Ancho *',

                                        //counterText: snapshot.data,
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
                        ],
                      ),
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
        padding: EdgeInsets.all(10),
        height: 200.0,
        color: currentTheme.currentTheme.accentColor,
        child: Center(child: CircularProgressIndicator()));
  }

  Widget _createName(RoomBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: nameCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(30),
            ],
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Nombre *',
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
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(100),
            ],
            controller: descriptionCtrl,
            //  keyboardType: TextInputType.emailAddress,

            maxLines: 2,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Descripción *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDescription,
          ),
        );
      },
    );
  }

  Widget _createWide(RoomBloc bloc) {
    //final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.wideStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            onTap: () =>
                {if (wideCtrl.text == "0") wideCtrl.text = "", setState(() {})},
            controller: wideCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Ancho *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeWide,
          ),
        );
      },
    );
  }

  Widget _createLong(RoomBloc bloc) {
    //final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.longStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            onTap: () =>
                {if (longCtrl.text == "0") longCtrl.text = "", setState(() {})},
            controller: longCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Largo *',
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
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            onTap: () =>
                {if (tallCtrl.text == "0") tallCtrl.text = "", setState(() {})},
            controller: tallCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Alto *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeTall,
          ),
        );
      },
    );
  }

  Widget _createCo2(RoomBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: bloc.co2Stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'CO2',
            style: TextStyle(
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54,
            ),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.currentTheme.accentColor,
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
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: bloc.co2CompleteStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text('Timer',
              style: (currentTheme.customTheme)
                  ? TextStyle(
                      color: (isSwitchedCo2)
                          ? Colors.white54
                          : Colors.white54.withOpacity(0.20),
                    )
                  : TextStyle(
                      color: (isSwitchedCo2)
                          ? Colors.black54
                          : Colors.black54.withOpacity(0.20),
                    )),
          trailing: Switch.adaptive(
            activeColor: currentTheme.currentTheme.accentColor,
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

  Widget _createButton(
    RoomBloc bloc,
    bool isControllerChange,
  ) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                      color: (isControllerChange && !errorRequired)
                          ? currentTheme.accentColor
                          : Colors.white.withOpacity(0.30),
                      fontSize: 18),
                ),
              ),
            ),
            onTap: isControllerChange && !errorRequired && !loading
                ? () => {
                      FocusScope.of(context).unfocus(),
                      (widget.isEdit) ? _editRoom(bloc) : _createRoom(bloc),
                    }
                : null);
      },
    );
  }

  _createRoom(RoomBloc bloc) async {
    loading = true;

    final roomService = Provider.of<RoomService>(context, listen: false);
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

    final createRoomRes = await roomService.createRoom(newRoom);

    if (createRoomRes != null) {
      if (createRoomRes.ok) {
        // widget.rooms.add(createRoomRes.room);
        roomBloc.getMyRooms(profile.user.uid);
        roomService.room = createRoomRes.room;
        //roomBloc.getRoom(widget.room);
        loading = false;
        setState(() {});

        Navigator.pop(context);
      } else {
        setState(() {
          loading = false;
        });
        mostrarAlerta(context, 'Error', createRoomRes.msg);
      }
    } else {
      setState(() {
        loading = false;
      });
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editRoom(RoomBloc bloc) async {
    loading = true;

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

    if (widget.isEdit) {
      final editRoomRes = await roomService.editRoom(newRoom);

      if (editRoomRes != null) {
        if (editRoomRes.ok) {
          // room = editRoomRes.room;

          loading = false;

          roomService.room = editRoomRes.room;
          roomBloc.getMyRooms(profile.user.uid);

          setState(() {});
          Navigator.pop(context);
        } else {
          setState(() {
            loading = false;
          });
          mostrarAlerta(context, 'Error', editRoomRes.msg);
        }
      } else {
        setState(() {
          loading = false;
        });
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
