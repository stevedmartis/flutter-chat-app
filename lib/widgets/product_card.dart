import 'package:chat/models/products.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/extension.dart';

class CardProduct extends StatefulWidget {
  final Product product;

  CardProduct({this.product});
  @override
  _CardProductState createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Column(
      children: <Widget>[
        Container(
          color: (currentTheme.customTheme)
              ? currentTheme.currentTheme.cardColor
              : Colors.white,
          // padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5.0),
          width: size.height / 1.5,
          child: FittedBox(
            child: Row(
              children: <Widget>[
                productItem(),
                Container(
                  width: 100,
                  height: 165,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(10.0)),
                      child: Material(
                        type: MaterialType.transparency,
                        child: (widget.product.coverImage != "")
                            ? FadeInImage(
                                image:
                                    NetworkImage(widget.product.getCoverImg()),
                                placeholder: AssetImage('assets/loading2.gif'),
                                fit: BoxFit.cover)
                            : FadeInImage(
                                image:
                                    AssetImage('assets/images/empty_image.png'),
                                placeholder: AssetImage('assets/loading2.gif'),
                                fit: BoxFit.cover),
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget productItem() {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);
    final thc = (widget.product.thc.isEmpty) ? '0' : widget.product.thc;
    final cbd = (widget.product.cbd.isEmpty) ? '0' : widget.product.cbd;
    final rating = widget.product.ratingInit;

    final profile = widget.product.profile;

    /*   final suscriptionEnabled =
        profile.subscribeApproved && profile.subscribeActive; */

    var ratingDouble = double.parse('$rating');

    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  widget.product.name.capitalize(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: currentTheme.currentTheme.accentColor),
                ),
              ),
              CbdthcRow(
                thc: '$thc',
                cbd: '$cbd',
                fontSize: 7.0,
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                width: size.width / 3.5,
                child: Text(
                  (widget.product.description.length > 0)
                      ? widget.product.description.capitalize()
                      : "Sin descripción",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                      color: Colors.grey),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 0, top: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (ratingDouble >= 1)
                        ? Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.grey,
                          ),
                    (ratingDouble >= 2)
                        ? Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.grey,
                          ),
                    (ratingDouble >= 3)
                        ? Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.grey,
                          ),
                    (ratingDouble >= 4)
                        ? Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.grey,
                          ),
                    (ratingDouble == 5)
                        ? Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 15,
                            color: Colors.grey,
                          ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: ImageUserChat(
                          width: 40,
                          height: 40,
                          profile: profile,
                          fontsize: 20),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              profile.name,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: (currentTheme.customTheme)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              '@' + profile.user.username,
                              style:
                                  TextStyle(fontSize: 9.0, color: Colors.grey),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget eliteitem() {
    return Container(
      //width: 150,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "Alinea Chicago",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Classical French cooking",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 9.5,
                color: Colors.grey),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.deepOrange[300],
                  //color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Spicy",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.red,
                  //color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Hot",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 9.5,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.yellow[400],
                  //color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "New",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Ratings",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 7,
                    color: Colors.grey),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.star,
                size: 10,
                color: Colors.orangeAccent,
              ),
              Icon(
                Icons.star,
                size: 10,
                color: Colors.orangeAccent,
              ),
              Icon(
                Icons.star,
                size: 10,
                color: Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CbdthcRow extends StatelessWidget {
  const CbdthcRow(
      {Key key, @required this.thc, @required this.cbd, this.fontSize = 15})
      : super(key: key);

  final String thc;
  final String cbd;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Color(0xffF12937E),
              //color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "THC: $thc %",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              //color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "CBD: $cbd %",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: Colors.white),
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
