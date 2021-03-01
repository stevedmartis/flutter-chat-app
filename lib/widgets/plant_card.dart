import 'package:chat/models/plant.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/extension.dart';

class CardPlantPrincipal extends StatefulWidget {
  final Plant plant;

  CardPlantPrincipal({this.plant});
  @override
  _CardPlantPrincipalState createState() => _CardPlantPrincipalState();
}

class _CardPlantPrincipalState extends State<CardPlantPrincipal> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);
    return Container(
      color: (currentTheme.customTheme) ? Color(0xff151518) : Colors.white,
      child: Row(
        children: [
          plantItem(),
          Container(
            width: size.width / 2.8,
            height: size.height,
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(15.0)),
                child: Material(
                  type: MaterialType.transparency,
                  child: (widget.plant.coverImage != "")
                      ? FadeInImage(
                          image: NetworkImage(widget.plant.getCoverImg()),
                          placeholder: AssetImage('assets/loading2.gif'),
                          fit: BoxFit.cover)
                      : FadeInImage(
                          image: AssetImage('assets/images/empty_image.png'),
                          placeholder: AssetImage('assets/loading2.gif'),
                          fit: BoxFit.cover),
                )),
          ),
          /* Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: FaIcon(
                        FontAwesomeIcons.broom,
                        color: (clean)
                            ? currentTheme.accentColor
                            : Colors.white38.withOpacity(0.20),
                      ),
                    ),
                    Container(
                      child: FaIcon(
                        FontAwesomeIcons.cut,
                        color: (cut)
                            ? currentTheme.accentColor
                            : Colors.white38.withOpacity(0.20),
                      ),
                    ),
                    Container(
                      child: FaIcon(
                        FontAwesomeIcons.thermometerEmpty,
                        color: (temp)
                            ? currentTheme.accentColor
                            : Colors.white38.withOpacity(0.20),
                      ),
                    ),
                    Container(
                      child: FaIcon(
                        FontAwesomeIcons.handHoldingWater,
                        color: (water)
                            ? currentTheme.accentColor
                            : Colors.white38.withOpacity(0.20),
                      ),
                    ),
                  ],
                )),
          ), */
        ],
      ),
    );
  }

  Widget plantItem() {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);
    final thc = (widget.plant.thc.isEmpty) ? '0' : widget.plant.thc;
    final cbd = (widget.plant.cbd.isEmpty) ? '0' : widget.plant.cbd;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              
            
            ],
          ), */
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: Text(
              widget.plant.name.capitalize(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: currentTheme.currentTheme.accentColor),
            ),
          ),
          CbdthcRow(
            thc: thc,
            cbd: cbd,
            fontSize: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            width: size.width / 3.5,
            child: Text(
              (widget.plant.description.length > 0)
                  ? widget.plant.description.capitalize()
                  : "Sin descripción",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0.0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
                    child: FaIcon(
                      FontAwesomeIcons.seedling,
                      color: Colors.white54,
                      size: 15,
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    widget.plant.germinated,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: (currentTheme.customTheme)
                            ? Colors.white54
                            : Colors.grey),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget juiceitem() {
    final size = MediaQuery.of(context).size;
    return Container(
      //width: 150,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: size.width / 1.5,
            child: Text(
              (widget.plant.description.length > 0)
                  ? widget.plant.description.capitalize()
                  : "No description",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Germinación: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white54),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'sss',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CbdthcRow extends StatelessWidget {
  const CbdthcRow(
      {Key key, @required this.thc, @required this.cbd, this.fontSize = 10})
      : super(key: key);

  final String thc;
  final String cbd;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: <Widget>[
          /* Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(0.5),
              child: Text(
                "THC:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white54),
              ),
            ),
          ), */
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Color(0xffF12937E),
                //color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$thc %",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                //color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$cbd %",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),

          /* Container(
            width: 35,
            decoration: BoxDecoration(
              color: Colors.yellow[400],
              //color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              "New",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5),
            ),
          ), */
        ],
      ),
    );
  }
}

class SexLtRow extends StatelessWidget {
  const SexLtRow(
      {Key key, @required this.pot, @required this.sex, this.fontSize = 10})
      : super(key: key);

  final String pot;
  final String sex;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(2.5),
              child: Text(
                "Sexo:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "$sex",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(2.5),
              child: Text(
                "Lt:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "$pot",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),

          /* Container(
            width: 35,
            decoration: BoxDecoration(
              color: Colors.yellow[400],
              //color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              "New",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5),
            ),
          ), */
        ],
      ),
    );
  }
}

class DateGDurationF extends StatelessWidget {
  const DateGDurationF(
      {Key key,
      @required this.germina,
      @required this.flora,
      this.fontSize = 10})
      : super(key: key);

  final String germina;
  final String flora;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.all(2.5),
                child: Text(
                  "Germinación :",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: Colors.white54),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "$germina",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.all(2.5),
                child: Text(
                  "Duración floración :",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: Colors.white54),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "$flora",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),

          /* Container(
            width: 35,
            decoration: BoxDecoration(
              color: Colors.yellow[400],
              //color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              "New",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5),
            ),
          ), */
        ],
      ),
    );
  }
}

/*  Card(
            shadowColor: Colors.black,
            color: currentTheme.scaffoldBackgroundColor,
            // color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Hero(
              tag: widget.visit.id,
              child: Container(
                width: size.width,
                height: size.height / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Material(
                    type: MaterialType.transparency,
                    child: (widget.visit.coverImage != "")
                        ? FadeInImage(
                            image: NetworkImage(widget.visit.getCoverImg()),
                            placeholder: AssetImage('assets/loading2.gif'),
                            fit: BoxFit.cover)
                        : FadeInImage(
                            image: AssetImage('assets/images/empty_image.png'),
                            placeholder: AssetImage('assets/loading2.gif'),
                            fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ) */
