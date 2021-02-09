import 'package:chat/models/air.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/extension.dart';

class CardAir extends StatefulWidget {
  final Air air;

  CardAir({this.air});
  @override
  _CardAirState createState() => _CardAirState();
}

class _CardAirState extends State<CardAir> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    print(widget.air);
    return Column(
      children: <Widget>[
        Container(
          color: currentTheme.scaffoldBackgroundColor,
          padding: EdgeInsets.only(top: 10, left: 0, right: 10, bottom: 5.0),
          width: size.height / 1.5,
          child: FittedBox(
            child: Card(
              shadowColor: Colors.black,
              color: currentTheme.scaffoldBackgroundColor,
              // color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Row(
                children: <Widget>[
                  Center(child: airItem()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget airItem() {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final watts = widget.air.watts;
    return Container(
        //width: 150,

        child: Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              
            
            ],
          ), */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.air.name.capitalize(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: currentTheme.accentColor),
              ),
            ),
            // CbdthcRow(thc: thc, cbd: cbd),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: size.width / 1.5,
              child: Text(
                (widget.air.description.length > 0)
                    ? widget.air.description.capitalize()
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

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: size.width / 1.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Watts: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  // FaIcon(FontAwesomeIcons.rulerHorizontal),

                  Text(
                    ' $watts',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
            width: 50,
            child: Center(
                child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.chevron_right,
                color: currentTheme.accentColor,
                size: 30,
              ),
            ))),
      ],
    ));
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
                "THC:",
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
              padding: EdgeInsets.all(2.5),
              child: Text(
                "CBD:",
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
          Padding(
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
          Padding(
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
          Padding(
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
          Padding(
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
