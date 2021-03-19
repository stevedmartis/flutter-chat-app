import 'package:chat/bloc/catalogo_bloc.dart';
import 'package:chat/bloc/provider.dart';

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/catalogo.dart';

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

  bool isDefault;

  FocusNode _focusNode;
  bool optionSelectChange = false;

  @override
  void initState() {
    errorRequired = (widget.isEdit) ? false : true;
    nameCtrl.text = widget.catalogo.name;
    descriptionCtrl.text = widget.catalogo.description;
    optionItemSelected = widget.catalogo.privacity;

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
    final currentTheme = Provider.of<ThemeChanger>(context);

    final bloc = CustomProvider.catalogoBlocIn(context);

//    final size = MediaQuery.of(context).size;

    final isControllerChange = isNameChange;

    final isControllerChangeEdit =
        isNameChange || isAboutChange || optionSelectChange;

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
                'Edit catalogo',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black),
              )
            : Text(
                'Crear catalogo',
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
                          _createDescription(bloc),
                          _createPrivacity(bloc)
                        ],
                      ),
                    )),
              ]),
        ),
      ),
    );
  }

  Widget _createName(CatalogoBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            focusNode: _focusNode,
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
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: bloc.descriptionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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

  Widget _createPrivacity(CatalogoBloc bloc) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);

    List<DropdownMenuItem> categories = [
      DropdownMenuItem(
        child: Text(
          'Todos',
          style: TextStyle(
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
        value: "1",
      ),
      DropdownMenuItem(
        child: Text(
          'Mis suscriptores',
          style: TextStyle(
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
        value: "2",
      ),
      DropdownMenuItem(
        child: Text(
          'Nadie',
          style: TextStyle(
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
        value: "3",
      )
    ];

    return StreamBuilder(
      stream: bloc.privacityStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(

            //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
            height: 50,
            width: size.width,
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: (currentTheme.customTheme)
                              ? Colors.white54
                              : Colors.black54))),
              dropdownColor:
                  (currentTheme.customTheme) ? Colors.black : Colors.white,
              hint: Text(
                'Mostrar con: ',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54),
              ),
              value: optionItemSelected,
              items: categories,
              onChanged: (optionItem) {
                setState(() {
                  optionItemSelected = optionItem;
                  optionSelectChange = true;
                });
              },
            ));
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
              (widget.isEdit) ? 'Guardar' : 'Crear',
              style: TextStyle(
                  color: (isControllerChange && !errorRequired)
                      ? currentTheme.accentColor
                      : Colors.grey,
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

    final editCatalogoRes = await catalogoService.editCatalogo(editCatalogo);

    if (editCatalogoRes != null) {
      if (editCatalogoRes.ok) {
        // widget.rooms.removeWhere((element) => element.id == editRoomRes.room.id)
        //  plantBloc.getPlant(widget.plant);
        setState(() {
          loading = false;
        });
        catalogoBloc.getMyCatalogos(uid);

        catalogoBloc.getCatalogo(widget.catalogo);

        Navigator.pop(context);
      } else {
        mostrarAlerta(context, 'Error', editCatalogoRes.msg);
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
