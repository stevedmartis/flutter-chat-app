import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/visit_bloc.dart';

import 'package:chat/helpers/mostrar_alerta.dart';

import 'package:chat/models/visit.dart';
import 'package:chat/pages/cover_image_visit.dart';
import 'package:chat/pages/profile_page.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/visit_service.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/productProfile_card.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:provider/provider.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddUpdateVisitPage extends StatefulWidget {
  AddUpdateVisitPage({this.visit, this.isEdit = false, this.plant});

  final Visit visit;
  final bool isEdit;
  final String plant;

  @override
  AddUpdateVisitPageState createState() => AddUpdateVisitPageState();
}

class AddUpdateVisitPageState extends State<AddUpdateVisitPage> {
  Visit visit;

  final electroCtrl = TextEditingController();

  final descriptionCtrl = TextEditingController();

  final nameAbonoCtrl = TextEditingController();

  // final potCtrl = TextEditingController();

  var phCtrl = new MaskedTextController(mask: '0.0');

  var gramsCtrl = new TextEditingController();

  var degreesCtrl = new MaskedTextController(mask: '00.0');

  var mlCtrl = new MaskedTextController(mask: '0.0');

  var mlAbonoCtrl = new MaskedTextController(mask: '0.0');

  bool isAboutChange = false;

  bool isSwitchedCut = false;

  bool isCutChange = false;

  bool isDegreesChange = false;

  bool isElectoChange = false;

  bool isPhChange = false;

  bool isMlChange = false;

  bool isSwitchedClean = false;

  bool isCleanChange = false;

  bool isSwitchedTemp = false;

  bool isTempChange = false;

  bool isSwitchedWater = false;

  bool isWaterChange = false;

  bool isSwitchedAbono = false;
  bool isAbonoChange = false;

  bool loading = false;

  bool isMlAbonoChange = false;

  bool isGramsChange = false;

  bool isDefault;

  @override
  void initState() {
    final visitService = Provider.of<VisitService>(context, listen: false);

    //visitService.visit = widget.visit;
    visit = (widget.isEdit) ? visitService.visit : widget.visit;

    isSwitchedCut = widget.visit.cut;
    isSwitchedClean = widget.visit.clean;
    isSwitchedTemp = widget.visit.temperature;
    isSwitchedWater = widget.visit.water;
    isSwitchedAbono = widget.visit.abono;

    // nameCtrl.text = widget.visit.name;

    degreesCtrl.text = widget.visit.degrees;
    electroCtrl.text = widget.visit.electro;
    phCtrl.text = widget.visit.ph;
    descriptionCtrl.text = widget.visit.description;

    gramsCtrl.text = widget.visit.grams;

    nameAbonoCtrl.text = widget.visit.nameAbono;

    mlAbonoCtrl.text = widget.visit.mlAbono;

    visitBloc.imageUpdate.add(true);

    descriptionCtrl.addListener(() {
      setState(() {
        if (widget.visit.description != descriptionCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });

    degreesCtrl.addListener(() {
      setState(() {
        if (widget.visit.degrees != degreesCtrl.text)
          this.isDegreesChange = true;
        else
          this.isDegreesChange = false;
      });
    });

    electroCtrl.addListener(() {
      setState(() {
        if (widget.visit.electro != electroCtrl.text)
          this.isElectoChange = true;
        else
          this.isElectoChange = false;
      });
    });

    phCtrl.addListener(() {
      setState(() {
        if (widget.visit.ph != phCtrl.text)
          this.isPhChange = true;
        else
          this.isPhChange = false;
      });
    });

    mlCtrl.addListener(() {
      setState(() {
        if (widget.visit.ml != mlCtrl.text)
          this.isMlChange = true;
        else
          this.isMlChange = false;
      });
    });

    mlAbonoCtrl.addListener(() {
      setState(() {
        if (widget.visit.mlAbono != mlAbonoCtrl.text)
          this.isMlAbonoChange = true;
        else
          this.isMlAbonoChange = false;
      });
    });

    gramsCtrl.addListener(() {
      setState(() {
        if (widget.visit.grams != gramsCtrl.text)
          this.isGramsChange = true;
        else
          this.isGramsChange = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    degreesCtrl.dispose();
    electroCtrl.dispose();
    phCtrl.dispose();
    mlCtrl.dispose();
    descriptionCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final bloc = CustomProvider.visitBlocIn(context);

    final size = MediaQuery.of(context).size;

    final visitService = Provider.of<VisitService>(context, listen: false);
    final awsService = Provider.of<AwsService>(context, listen: false);

    final isControllerChange = isAboutChange ||
        isCutChange ||
        isDegreesChange ||
        isElectoChange ||
        isPhChange ||
        isMlChange ||
        isCleanChange ||
        isTempChange ||
        isWaterChange ||
        isAbonoChange ||
        isMlAbonoChange ||
        isGramsChange;

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor:
              (currentTheme.customTheme) ? Colors.black : Colors.white,
          actions: [_createButton(bloc, isControllerChange)],
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: currentTheme.currentTheme.accentColor,
            ),
            iconSize: 30,
            onPressed: () {
              visitService.visit = null;
              awsService.isUpload = false;
              //  Navigator.pushReplacement(context, createRouteProfile()),
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          title: (widget.isEdit)
              ? Text(
                  'Editar visita',
                  style: TextStyle(
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : Colors.black),
                )
              : Text(
                  'Nueva visita',
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
                  SliverFixedExtentList(
                    itemExtent: size.height / 3.7,
                    delegate: SliverChildListDelegate(
                      [
                        StreamBuilder<bool>(
                          stream: visitBloc.imageUpdate.stream,
                          builder: (context, AsyncSnapshot<bool> snapshot) {
                            if (snapshot.hasData) {
                              return (visitService.visit != null)
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                transitionDuration:
                                                    Duration(milliseconds: 200),
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    CoverImageVisitPage(
                                                        visit:
                                                            visitService.visit,
                                                        isEdit:
                                                            widget.isEdit)));
                                      },
                                      child: cachedNetworkImage(
                                        visitService.visit.getCoverImg(),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                transitionDuration:
                                                    Duration(milliseconds: 200),
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    CoverImageVisitPage(
                                                        visit: widget.visit,
                                                        isEdit:
                                                            widget.isEdit)));
                                      },
                                      child: cachedNetworkImage(
                                        widget.visit.getCoverImg(),
                                      ),
                                    );
                            } else if (snapshot.hasError) {
                              return _buildErrorWidget(snapshot.error);
                            } else {
                              return _buildLoadingWidget();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _createClean(bloc),
                            SizedBox(
                              height: 10,
                            ),
                            _createCut(bloc),
                            SizedBox(
                              height: 10,
                            ),
                            (isSwitchedCut) ? _createGrams(bloc) : Container(),
                            _createTemperature(bloc),
                            SizedBox(
                              height: 10,
                            ),
                            (isSwitchedTemp)
                                ? _createDegrees(bloc)
                                : Container(),
                            _createWater(bloc),
                            (isSwitchedWater) ? _createLt(bloc) : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            (isSwitchedWater) ? _createPh(bloc) : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            (isSwitchedWater)
                                ? _createElectro(bloc)
                                : Container(),
                            _createAbono(bloc),
                            SizedBox(
                              height: 10,
                            ),
                            (isSwitchedAbono)
                                ? _createNameAbono(bloc)
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            (isSwitchedAbono)
                                ? _createMlAbono(bloc)
                                : Container(),
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
      ),
    );
  }

  Widget _buildLoadingWidget() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
        height: 400.0,
        child: Center(
            child: CircularProgressIndicator(color: currentTheme.accentColor)));
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

  Widget _createDescription(VisitBloc bloc) {
    return StreamBuilder(
      stream: bloc.descriptionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
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
                labelText: 'Observación',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDescription,
          ),
        );
      },
    );
  }

  Widget _createNameAbono(VisitBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameAbonoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(100),
            ],
            controller: nameAbonoCtrl,
            //  keyboardType: TextInputType.emailAddress,

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
                labelText: 'Nombre/Marca',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeNameAbono,
          ),
        );
      },
    );
  }

  Widget _createCut(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: bloc.cutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Podar',
            style: TextStyle(
                color: (currentTheme.customTheme)
                    ? Colors.white54
                    : Colors.black54),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.currentTheme.accentColor,
            value: isSwitchedCut,
            onChanged: (value) {
              setState(() {
                isSwitchedCut = value;

                if (isSwitchedCut != widget.visit.cut) {
                  this.isCutChange = true;
                } else {
                  this.isCutChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createAbono(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
        child: ListTile(
      //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
      title: Text(
        'Fertilizar/Abonar',
        style: TextStyle(
            color:
                (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
      ),
      trailing: Switch.adaptive(
        activeColor: currentTheme.currentTheme.accentColor,
        value: isSwitchedAbono,
        onChanged: (value) {
          setState(() {
            isSwitchedAbono = value;

            if (isSwitchedAbono != widget.visit.abono) {
              this.isAbonoChange = true;
            } else {
              this.isAbonoChange = false;
            }
          });
        },
      ),
    ));
  }

  Widget _createClean(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: bloc.cutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Limpieza',
            style: TextStyle(
                color: (currentTheme.customTheme)
                    ? Colors.white54
                    : Colors.black54),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.currentTheme.accentColor,
            value: isSwitchedClean,
            onChanged: (value) {
              setState(() {
                isSwitchedClean = value;

                if (isSwitchedClean != widget.visit.clean) {
                  this.isCleanChange = true;
                } else {
                  this.isCleanChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createTemperature(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: bloc.cutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Temperatura',
            style: TextStyle(
                color: (currentTheme.customTheme)
                    ? Colors.white54
                    : Colors.black54),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.currentTheme.accentColor,
            value: isSwitchedTemp,
            onChanged: (value) {
              setState(() {
                isSwitchedTemp = value;

                if (isSwitchedCut != widget.visit.temperature) {
                  this.isTempChange = true;
                } else {
                  this.isTempChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createWater(VisitBloc bloc) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return StreamBuilder(
      stream: bloc.cutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: ListTile(
          //leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
          title: Text(
            'Regado',
            style: TextStyle(
                color: (currentTheme.customTheme)
                    ? Colors.white54
                    : Colors.black54),
          ),
          trailing: Switch.adaptive(
            activeColor: currentTheme.currentTheme.accentColor,
            value: isSwitchedWater,
            onChanged: (value) {
              setState(() {
                isSwitchedWater = value;

                if (isSwitchedWater != widget.visit.water) {
                  this.isWaterChange = true;
                } else {
                  this.isWaterChange = false;
                }
              });
            },
          ),
        ));
      },
    );
  }

  Widget _createElectro(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.electroStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(4),
            ],
            controller: electroCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
            //  keyboardType: TextInputType.emailAddress,
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
                labelText: 'Electro conductor',
                //counterText: snapshot.data,
                errorText: snapshot.error),

            onChanged: bloc.changeElectro,
          ),
        );
      },
    );
  }

  Widget _createDegrees(VisitBloc bloc) {
    return StreamBuilder(
      stream: bloc.degreesStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(3),
            ],
            controller: degreesCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
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
                labelText: 'Grados celsius',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDegrees,
          ),
        );
      },
    );
  }

  Widget _createPh(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.phStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(4),
            ],
            controller: phCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
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
                labelText: 'pH',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePh,
          ),
        );
      },
    );
  }

  Widget _createGrams(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.gramStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(4),
            ],
            controller: gramsCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
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
                labelText: 'Gramos cosechados',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeGram,
          ),
        );
      },
    );
  }

  Widget _createLt(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.mlStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(4),
            ],
            controller: mlCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
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
                labelText: 'Lt agua',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeMl,
          ),
        );
      },
    );
  }

  Widget _createMlAbono(VisitBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.mlAbonoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(4),
            ],
            controller: mlAbonoCtrl,
            keyboardType: TextInputType.number,

            maxLines: 1,
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
                labelText: 'ML',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeMlAbono,
          ),
        );
      },
    );
  }

  Widget _createButton(
    VisitBloc bloc,
    bool isControllerChange,
  ) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final isUpload = Provider.of<AwsService>(context).isUpload;

    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              (widget.isEdit) ? 'Guardar' : 'Crear',
              style: TextStyle(
                  color: (isControllerChange) || isUpload
                      ? currentTheme.accentColor
                      : Colors.grey,
                  fontSize: 18),
            ),
          ),
        ),
        onTap: isControllerChange && !loading || isUpload
            ? () => {
                  setState(() {
                    loading = true;
                  }),
                  FocusScope.of(context).unfocus(),
                  (widget.isEdit) ? _editVisit(bloc) : _createVisit(bloc),
                }
            : null);
  }

  _createVisit(VisitBloc bloc) async {
    final visitService = Provider.of<VisitService>(context, listen: false);

    // final Visit = widget.visit.id;
    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    final clean = isSwitchedClean;

    final temp = isSwitchedTemp;

    final cut = isSwitchedCut;

    final water = isSwitchedWater;

    final abono = isSwitchedAbono;

    final degrees =
        (degreesCtrl.text == "") ? widget.visit.degrees : bloc.degrees.trim();

    final electro =
        (electroCtrl.text == "") ? widget.visit.electro : bloc.electro.trim();

    final ph = (phCtrl.text == "") ? widget.visit.ph : bloc.ph.trim();

    final ml = (mlCtrl.text == "") ? widget.visit.ml : bloc.ml.trim();

    final mlAbono =
        (mlAbonoCtrl.text == "") ? widget.visit.mlAbono : bloc.mlAbono.trim();

    final nameAbono = (nameAbonoCtrl.text == "")
        ? widget.visit.nameAbono
        : bloc.nameAbono.trim();

    final description = (descriptionCtrl.text == "")
        ? widget.visit.description
        : bloc.description.trim();

    final grams =
        (gramsCtrl.text == "") ? widget.visit.grams : bloc.gram.trim();

    final newVisit = Visit(
      // name: name,
      coverImage: widget.visit.coverImage,
      plant: widget.plant,
      user: uid,

      clean: clean,
      cut: cut,
      temperature: temp,
      degrees: degrees,
      water: water,
      electro: electro,
      abono: abono,
      ph: ph,
      ml: ml,
      grams: grams,
      mlAbono: mlAbono,
      nameAbono: nameAbono,
      description: description,
    );

    final createVisitResp = await visitService.createVisit(newVisit);

    if (createVisitResp != null) {
      if (createVisitResp.ok) {
        loading = false;

        Navigator.pop(context);
        setState(() {
          visitBloc.getVisitsByUser(uid);
        });
      } else {
        mostrarAlerta(context, 'Error', createVisitResp.msg);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editVisit(VisitBloc bloc) async {
    final visitService = Provider.of<VisitService>(context, listen: false);

    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    // final name = (bloc.name == null) ? widget.visit.name : bloc.name.trim();

    final clean = isSwitchedClean;

    final temp = isSwitchedTemp;

    final cut = isSwitchedCut;

    final water = isSwitchedWater;
    final abono = isSwitchedAbono;

    final degrees =
        (bloc.degrees == null) ? widget.visit.degrees : bloc.degrees.trim();

    final electro =
        (bloc.electro == null) ? widget.visit.electro : bloc.electro.trim();

    final ph = (bloc.ph == null) ? widget.visit.ph : bloc.ph.trim();

    final ml = (bloc.ml == null) ? widget.visit.ml : bloc.ml.trim();

    final description = (descriptionCtrl.text == "")
        ? widget.visit.description
        : descriptionCtrl.text.trim();

    final mlAbono =
        (mlAbonoCtrl.text == "") ? widget.visit.mlAbono : bloc.mlAbono.trim();

    final nameAbono = (nameAbonoCtrl.text == "")
        ? widget.visit.nameAbono
        : bloc.nameAbono.trim();

    final grams =
        (gramsCtrl.text == "") ? widget.visit.grams : bloc.gram.trim();

    final newVisit = Visit(
      // name: name,
      coverImage: widget.visit.coverImage,

      id: widget.visit.id,
      clean: clean,
      cut: cut,
      temperature: temp,
      degrees: degrees,
      water: water,
      electro: electro,
      abono: abono,
      ph: ph,
      ml: ml,
      mlAbono: mlAbono,
      grams: grams,
      nameAbono: nameAbono,
      description: description,
    );

    final editRoomRes = await visitService.editVisit(newVisit);

    if (editRoomRes != null) {
      if (editRoomRes.ok) {
        // widget.rooms.removeWhere((element) => element.id == editRoomRes.room.id)
        // plantBloc.getPlant(widget.visit);
        setState(() {
          loading = false;

          visitBloc.getVisitsByUser(uid);
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
