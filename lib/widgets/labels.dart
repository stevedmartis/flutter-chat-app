import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String rute;
  final String title;
  final String subTitulo;
  final Color colortText1;
    final Color colortText2;


  const Labels({
    Key key, 
    @required this.rute, 
    @required this.title, 
    @required this.subTitulo,
    this.colortText1 = Colors.white,
    this.colortText2 = Colors.lightBlue

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text( this.title , style: TextStyle( color: this.colortText1, fontSize: 15, fontWeight: FontWeight.w500 ) ),
          SizedBox( height: 10 ),
          GestureDetector(
            child: Text( this.subTitulo, style: TextStyle( color: colortText2, fontSize: 18, fontWeight: FontWeight.bold )  ),
            onTap: () {
              Navigator.pushReplacementNamed(context, this.rute );
            },
          )
        ],
      ),
    );
  }
}


