import 'package:chat/models/plant.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/plant_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/extension.dart';

class CardPlant extends StatefulWidget {
  final Plant plant;
  final bool isPrincipal;

  CardPlant({this.plant, this.isPrincipal = false});
  @override
  _CardPlantState createState() => _CardPlantState();
}

class _CardPlantState extends State<CardPlant> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      color: (currentTheme.customTheme) ? Color(0xff151518) : Colors.white,
      child: FittedBox(
        child: Row(
          children: <Widget>[
            Center(child: plantItem()),
            Container(
              width: size.width,
              height: (!widget.isPrincipal) ? size.height / 1.40 : size.height,
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
          ],
        ),
      ),
    );
  }

  Widget plantItem() {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);
    final thc = (widget.plant.thc.isEmpty) ? '0' : widget.plant.thc;
    final cbd = (widget.plant.cbd.isEmpty) ? '0' : widget.plant.cbd;

    return Container(
      padding: EdgeInsets.only(left: 30),
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
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              widget.plant.name.capitalize(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: (widget.isPrincipal) ? 55 : 40,
                  color: currentTheme.currentTheme.accentColor),
            ),
          ),
          SizedBox(height: 10.0),
          CbdthcRow(
            thc: thc,
            cbd: cbd,
            fontSize: 30,
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: size.width,
            child: Text(
              (widget.plant.description.length > 0)
                  ? widget.plant.description.capitalize()
                  : "Sin descripción",
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: (widget.isPrincipal) ? 50 : 30,
                  color: Colors.grey),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                      child: FaIcon(
                    FontAwesomeIcons.seedling,
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.grey,
                    size: 40,
                  )),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    widget.plant.germinated,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: (widget.isPrincipal) ? 40 : 30,
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
