import 'package:chat/bloc/plant_bloc.dart';
import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/room_bloc.dart';

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/air.dart';

import 'package:chat/models/plant.dart';
import 'package:chat/models/room.dart';
import 'package:chat/pages/new_product.dart';
import 'package:chat/pages/profile_page.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/plant_services.dart';

import 'package:chat/theme/theme.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddUpdateAirPage extends StatefulWidget {
  AddUpdateAirPage({this.air, this.isEdit = false, this.room});

  final Air air;
  final bool isEdit;
  final Room room;

  @override
  AddUpdateAirPageState createState() => AddUpdateAirPageState();
}

class AddUpdateAirPageState extends State<AddUpdateAirPage> {
  Plant plant;
  final nameCtrl = TextEditingController();

  final descriptionCtrl = TextEditingController();

  final quantityCtrl = TextEditingController();

  final _durationFlorationCtrl = TextEditingController();

  // final potCtrl = TextEditingController();

  var tchCtrl = new MaskedTextController(mask: '00');
  var cbdCtrl = new MaskedTextController(mask: '00');

  var potCtrl = new TextEditingController();

  bool isNameChange = false;
  bool isAboutChange = false;
  bool isQuantityChange = false;

  bool isGerminatedChange = false;
  bool isFlorationChange = false;

  bool isThcChange = false;

  bool isCbdChange = false;
  bool isPotChange = false;
  bool errorRequired = false;

  bool loading = false;

  String dropdownValue = 'Sexo';

  String setDateG;

  DateTime selectedDateG = DateTime.now();

  TextEditingController _dateGController = TextEditingController();

  String setDateF;

  DateTime selectedDateF = DateTime.now();

  TextEditingController _dateFController = TextEditingController();

  String optionItemSelected;

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
    nameCtrl.text = widget.air.name;
    descriptionCtrl.text = widget.air.description;

    plantBloc.imageUpdate.add(true);
    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.air.name != nameCtrl.text)
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
        if (widget.air.description != descriptionCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();

    descriptionCtrl.dispose();

    quantityCtrl.dispose();

    // plantBloc?.dispose();

    tchCtrl.dispose();
    cbdCtrl.dispose();
    _dateGController.dispose();
    _dateFController.dispose();
    potCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final bloc = CustomProvider.plantBlocIn(context);

//    final size = MediaQuery.of(context).size;

    final isSexoChange =
        (widget.air.name != optionItemSelected && optionItemSelected != null)
            ? true
            : false;

    final isControllerChange = isNameChange &&
        isQuantityChange &&
        isGerminatedChange &&
        isFlorationChange;

    final isControllerChangeEdit = isNameChange ||
        isAboutChange ||
        isQuantityChange ||
        isSexoChange ||
        isGerminatedChange ||
        isFlorationChange ||
        isThcChange ||
        isCbdChange ||
        isPotChange;

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
        title: (widget.isEdit) ? Text('Edit plant') : Text('Crear aire'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _createName(bloc),
                          SizedBox(
                            height: 10,
                          ),
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

  Widget _buildLoadingWidget() {
    return Container(
        height: 400.0, child: Center(child: CircularProgressIndicator()));
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

  Widget _createName(PlantBloc bloc) {
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
                labelText: 'Name *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createDescription(PlantBloc bloc) {
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

  Widget _createQuantity(PlantBloc bloc) {
    return StreamBuilder(
      stream: bloc.quantityStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: quantityCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Quantity *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeQuantity,
          ),
        );
      },
    );
  }

  Widget _createDurationFlora(PlantBloc bloc) {
    return StreamBuilder(
      stream: bloc.floweringStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: _durationFlorationCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: 'Semanas',
                labelText: 'Duracion de floración *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeFlowering,
          ),
        );
      },
    );
  }

  Widget _createThc(PlantBloc bloc) {
    return StreamBuilder(
      stream: bloc.tchStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: tchCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                suffixIcon: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      '%',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54),
                    )),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'THC',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeThc,
          ),
        );
      },
    );
  }

  Widget _createCbd(PlantBloc bloc) {
    return StreamBuilder(
      stream: bloc.tchStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: cbdCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                suffixIcon: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      '%',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54),
                    )),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'CBD',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeCbd,
          ),
        );
      },
    );
  }

  Widget _createPot(PlantBloc bloc) {
    return StreamBuilder(
      stream: bloc.potStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            controller: potCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff20FFD7), width: 2.0),
                ),
                hintText: '',
                labelText: 'Lt pot',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePot,
          ),
        );
      },
    );
  }

  Widget _createButton(
    PlantBloc bloc,
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
                      (widget.isEdit) ? _editPlant(bloc) : _createPlant(bloc),
                    }
                : null);
      },
    );
  }

  _createPlant(PlantBloc bloc) async {
    final plantService = Provider.of<PlantService>(context, listen: false);

    final room = widget.room.id;
    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    final name = (bloc.name == null) ? widget.air.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.air.description
        : bloc.description.trim();

    final newPlant =
        Plant(name: name, description: description, room: room, user: uid);

    print(newPlant);

    final createPlantResp = await plantService.createPlant(newPlant);

    if (createPlantResp != null) {
      if (createPlantResp.ok) {
        // widget.plants.add(createPlantResp.plant);
        loading = false;

        // plantBloc.getPlant(widget.plant);
        //  plantBloc.getPlant(widget.plant);

        roomBloc.getRooms(uid);
        Navigator.pop(context);
        setState(() {});
      } else {
        mostrarAlerta(context, 'Error', createPlantResp.msg);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editPlant(PlantBloc bloc) async {
    final plantService = Provider.of<PlantService>(context, listen: false);

    // final uid = authService.profile.user.uid;

    final name = (bloc.name == null) ? widget.air.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.air.description
        : descriptionCtrl.text.trim();

    final editPlant =
        Plant(name: name, description: description, id: widget.air.id);

    print(editPlant);

    if (widget.isEdit) {
      final editRoomRes = await plantService.editPlant(editPlant);

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
