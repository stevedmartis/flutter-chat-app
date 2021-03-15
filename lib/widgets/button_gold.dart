import 'package:flutter/material.dart';

class ButtonAccent extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final Color textColor;

  const ButtonAccent(
      {Key key,
      @required this.text,
      @required this.onPressed,
      @required this.color,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          gradient: LinearGradient(
              colors: gradients,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Center(
          child:
              Text(this.text, style: TextStyle(color: textColor, fontSize: 17)),
        ),
      ),
    );
  }
}

class ButtonLogout extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final Color textColor;

  const ButtonLogout(
      {Key key,
      @required this.text,
      @required this.onPressed,
      @required this.color,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child:
              Text(this.text, style: TextStyle(color: textColor, fontSize: 17)),
        ),
      ),
    );
  }
}

const List<Color> gradients = [
  Color(0xff34EC9C),
  Color(0xff20FFD7),
  Color(0xff34EC9C),
];

class ButtonSubEditProfile extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final Color textColor;
  final bool isSecond;

  const ButtonSubEditProfile(
      {Key key,
      @required this.text,
      @required this.onPressed,
      @required this.color,
      this.isSecond = false,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: this.color.withOpacity(0.10),
          onPrimary: this.color,
          elevation: 5,
          side: BorderSide(
              color: (isSecond) ? this.color.withOpacity(0.10) : this.textColor,
              width: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: this.textColor, width: 1.5))),
      /*  shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: this.textColor, width: 1.5)),
      elevation: 2,
      highlightElevation: 5,
      color: this.color, */

      // shape: StadiumBorder(),
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 40,
        child: Center(
          child: Text(this.text,
              style: TextStyle(
                  color: textColor, fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
