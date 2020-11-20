import 'package:flutter/material.dart';

class ButtonGold extends StatelessWidget {

  final String text;
  final Function onPressed;

  const ButtonGold({
    Key key, 
    @required this.text, 
    @required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        elevation: 2,
        highlightElevation: 5,
        color: Color(0xffD9B310),
        shape: StadiumBorder(),
        onPressed: this.onPressed,
        child: Container(
          width: double.infinity,
          height: 55,
          child: Center(
            child: Text( this.text , style: TextStyle( color: Colors.black, fontSize: 17 )),
          ),
        ),
    );
  }

}