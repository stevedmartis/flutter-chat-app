import 'package:chat/bloc/light_bloc.dart';
import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/room_bloc.dart';

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/light.dart';

import 'package:chat/models/room.dart';
import 'package:chat/pages/new_product.dart';
import 'package:chat/pages/profile_page.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/light_service.dart';

import 'package:chat/theme/theme.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddUpdateLightPage extends StatefulWidget {
  AddUpdateLightPage({this.light, this.isEdit = false, this.room});

  final Light light;
  final bool isEdit;
  final Room room;

  @override
  AddUpdateLightPageState createState() => AddUpdateLightPageState();
}

class AddUpdateLightPageState extends State<AddUpdateLightPage> {
  final nameCtrl = TextEditingController();

  final descriptionCtrl = TextEditingController();

  final _wattsCtrl = TextEditingController();

  final _kelvinCtrl = TextEditingController();

  // final potCtrl = TextEditingController();

  bool isNameChange = false;
  bool isAboutChange = false;

  bool errorRequired = false;
  bool isControllerChangeEdit = false;
  bool loading = false;

  bool isThcChange = false;
  bool isWattsChange = false;
  bool isKelvinChange = false;

  List<DropdownMenuItem> categories = [
    DropdownMenuItem(
      child: Text('Macho'),
      value: "Macho",
    ),
    DropdownMenuItem(
      child: Text('Hembra'),
      value: "Hembra",
    ),
    DropdownMenuItem(
      child: Text('Automatica'),
      value: "Automatica",
    )
  ];

  bool isDefault;

  @override
  void initState() {
    errorRequired = (widget.isEdit) ? false : true;
    nameCtrl.text = widget.light.name;
    descriptionCtrl.text = widget.light.description;
    _wattsCtrl.text = widget.light.watts;
    _kelvinCtrl.text = widget.light.kelvin;

    // plantBloc.imageUpdate.add(true);
    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.light.name != nameCtrl.text)
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
      setState(() {
        if (widget.light.description != descriptionCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });

    _wattsCtrl.addListener(() {
      setState(() {
        if (widget.light.watts != _wattsCtrl.text)
          this.isWattsChange = true;
        else
          this.isWattsChange = false;

        if (_wattsCtrl.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });

    _kelvinCtrl.addListener(() {
      setState(() {
        if (widget.light.kelvin != _kelvinCtrl.text)
          this.isKelvinChange = true;
        else
          this.isKelvinChange = false;

        if (_wattsCtrl.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();

    descriptionCtrl.dispose();

    // plantBloc?.dispose();

    _wattsCtrl.dispose();
    _kelvinCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final bloc = CustomProvider.lightBlocIn(context);

//    final size = MediaQuery.of(context).size;

    final isControllerChange = isNameChange && isWattsChange;

    final isControllerChangeEdit =
        isNameChange || isWattsChange || isAboutChange;

    return Scaffold(
      backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            (currentTheme.customTheme) ? Colors.black : Colors.white,
        actions: [
          (widget.isEdit)
              ? _createButton(bloc, isControllerChangeEdit)
              : _createButton(bloc, isControllerChange),
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
                'Editar Luz',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
              )
            : Text(
                'Nueva Luz',
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
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _createName(bloc),
                          _createWatts(bloc),
                          _createKelvin(bloc),
                          _createDescription(bloc),
                          SizedBox(
                            height: 10,
                          ),

                          /*   _createDescription(bloc), */
                        ],
                      ),
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _createName(LightBloc bloc) {
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
                labelText: 'Tipo/Nombre *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createDescription(LightBloc bloc) {
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
                labelText: 'Descripción',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDescription,
          ),
        );
      },
    );
  }

  Widget _createWatts(LightBloc bloc) {
    return StreamBuilder(
      stream: bloc.wattsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: _wattsCtrl,
            onTap: () => {
              if (_wattsCtrl.text == "0") _wattsCtrl.text = "",
              setState(() {})
            },
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(5),
            ],
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
                labelText: 'Watts *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeWatts,
          ),
        );
      },
    );
  }

  Widget _createKelvin(LightBloc bloc) {
    return StreamBuilder(
      stream: bloc.kelvinStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: _kelvinCtrl,
            onTap: () => {
              if (_kelvinCtrl.text == "0") _kelvinCtrl.text = "",
              setState(() {})
            },
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(5),
            ],
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
                labelText: 'Kelvin *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeKelvin,
          ),
        );
      },
    );
  }

  Widget _createButton(
    LightBloc bloc,
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
                  'Next',
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
                      setState(() {
                        loading = true;
                      }),
                      FocusScope.of(context).unfocus(),
                      (widget.isEdit) ? _editLight(bloc) : _createLight(bloc),
                    }
                : null);
      },
    );
  }

  _createLight(LightBloc bloc) async {
    final lightService = Provider.of<LightService>(context, listen: false);

    final room = widget.room.id;
    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    final name = (bloc.name == null) ? widget.light.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.light.description
        : bloc.description.trim();

    final watts = (bloc.watts == null) ? widget.light.watts : bloc.watts.trim();

    final kelvin =
        (bloc.watts == null) ? widget.light.kelvin : bloc.kelvin.trim();

    final newAir = Light(
        name: name,
        description: description,
        watts: watts,
        kelvin: kelvin,
        room: room,
        user: uid);

    final createAirResp = await lightService.createLight(newAir);

    if (createAirResp != null) {
      if (createAirResp.ok) {
        loading = false;

        roomBloc.getMyRooms(uid);

        Navigator.pop(context);
        setState(() {});
      } else {
        mostrarAlerta(context, 'Error', createAirResp.msg);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editLight(LightBloc bloc) async {
    final lightService = Provider.of<LightService>(context, listen: false);

    // final uid = authService.profile.user.uid;

    final name = (bloc.name == null) ? widget.light.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.light.description
        : descriptionCtrl.text.trim();

    final watts = (bloc.watts == null) ? widget.light.watts : bloc.watts.trim();
    final kelvin =
        (bloc.watts == null) ? widget.light.kelvin : bloc.kelvin.trim();

    final editLight = Light(
        name: name,
        description: description,
        watts: watts,
        kelvin: kelvin,
        id: widget.light.id);

    if (widget.isEdit) {
      final editRoomRes = await lightService.editLight(editLight);

      if (editRoomRes != null) {
        if (editRoomRes.ok) {
          // widget.rooms.removeWhere((element) => element.id == editRoomRes.room.id)
          //  plantBloc.getPlant(widget.plant);
          setState(() {
            loading = false;
          });
          // room = editRoomRes.room;

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

Route createRouteAddImages(Room room) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewProductPage(
      room: room,
    ),
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
