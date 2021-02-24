import 'package:chat/bloc/catalogo_bloc.dart';
import 'package:chat/bloc/provider.dart';

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/catalogo.dart';

import 'package:chat/models/room.dart';
import 'package:chat/pages/new_product.dart';
import 'package:chat/pages/profile_page.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/catalogo_service.dart';

import 'package:chat/theme/theme.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddUpdateCatalogoPage extends StatefulWidget {
  AddUpdateCatalogoPage({this.catalogo, this.isEdit = false});

  final Catalogo catalogo;
  final bool isEdit;

  @override
  _AddUpdateCatalogoPageState createState() => _AddUpdateCatalogoPageState();
}

class _AddUpdateCatalogoPageState extends State<AddUpdateCatalogoPage> {
  final nameCtrl = TextEditingController();

  final descriptionCtrl = TextEditingController();

  // final potCtrl = TextEditingController();

  bool isNameChange = false;
  bool isAboutChange = false;

  bool errorRequired = false;
  bool isControllerChangeEdit = false;
  bool loading = false;

  String optionItemSelected = "1";

  List<DropdownMenuItem> categories = [
    DropdownMenuItem(
      child: Text('Todos'),
      value: "1",
    ),
    DropdownMenuItem(
      child: Text('Mis suscriptores'),
      value: "2",
    ),
    DropdownMenuItem(
      child: Text('Nadie'),
      value: "3",
    )
  ];

  bool isDefault;

  @override
  void initState() {
    errorRequired = (widget.isEdit) ? false : true;
    nameCtrl.text = widget.catalogo.name;
    descriptionCtrl.text = widget.catalogo.description;

    //  plantBloc.imageUpdate.add(true);
    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.catalogo.name != nameCtrl.text)
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
        if (widget.catalogo.description != descriptionCtrl.text)
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final bloc = CustomProvider.catalogoBlocIn(context);

//    final size = MediaQuery.of(context).size;

    final isControllerChange = isNameChange;

    final isControllerChangeEdit = isNameChange || isAboutChange;

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
        title: (widget.isEdit) ? Text('Edit catalogo') : Text('Crear catalogo'),
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
                          _createDescription(bloc),
                          _createPrivacity(bloc)

                          /*   _createDescription(bloc), */
                        ],
                      ),
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _createName(CatalogoBloc bloc) {
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

  Widget _createDescription(CatalogoBloc bloc) {
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

  Widget _createPrivacity(CatalogoBloc bloc) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: bloc.privacityStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(

            //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
            height: 50,
            width: size.width,
            child: DropdownButtonFormField(
              hint: Text('Mostrar con: '),
              value: optionItemSelected,
              items: categories,
              onChanged: (optionItem) {
                setState(() {
                  optionItemSelected = optionItem;
                });
              },
            ));
        /* SelectDropList(
              optionItemSelected,
              dropListModel,
              (optionItem) {
                setState(() {
                  optionItemSelected = optionItem;
                  sexoModel.sexo = optionItemSelected;
                });
              },
            )); */
      },
    );
  }

  Widget _createButton(
    CatalogoBloc bloc,
    bool isControllerChange,
  ) {
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
                  setState(() {
                    loading = true;
                  }),
                  FocusScope.of(context).unfocus(),
                  (widget.isEdit) ? _editCatalogo(bloc) : _createCatalogo(bloc),
                }
            : null);
  }

  _createCatalogo(CatalogoBloc bloc) async {
    final catalogoService =
        Provider.of<CatalogoService>(context, listen: false);

    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    final name = (bloc.name == null) ? widget.catalogo.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.catalogo.description
        : bloc.description.trim();

    final privacity = optionItemSelected;

    final newCatalogo = Catalogo(
        name: name, description: description, privacity: privacity, user: uid);

    final createCatalogoResp =
        await catalogoService.createCatalogo(newCatalogo);

    if (createCatalogoResp != null) {
      if (createCatalogoResp.ok) {
        loading = false;

        catalogoBloc.getMyCatalogos(uid);

        Navigator.pop(context);
        setState(() {});
      } else {
        mostrarAlerta(context, 'Error', createCatalogoResp.msg);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editCatalogo(CatalogoBloc bloc) async {
    final catalogoService =
        Provider.of<CatalogoService>(context, listen: false);

    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    final name = (bloc.name == null) ? widget.catalogo.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.catalogo.description
        : descriptionCtrl.text.trim();

    final privacity = optionItemSelected;

    final editCatalogo = Catalogo(
        name: name,
        description: description,
        privacity: privacity,
        id: widget.catalogo.id);

    if (widget.isEdit) {
      final editCatalogoRes = await catalogoService.editCatalogo(editCatalogo);

      if (editCatalogoRes != null) {
        if (editCatalogoRes.ok) {
          // widget.rooms.removeWhere((element) => element.id == editRoomRes.room.id)
          //  plantBloc.getPlant(widget.plant);
          setState(() {
            loading = false;
          });
          catalogoBloc.getMyCatalogos(uid);

          Navigator.pop(context);
        } else {
          mostrarAlerta(context, 'Error', editCatalogoRes.msg);
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
