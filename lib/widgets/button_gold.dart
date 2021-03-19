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
  final bool isSub;

  const ButtonSubEditProfile(
      {Key key,
      @required this.text,
      @required this.onPressed,
      @required this.color,
      this.isSecond = false,
      this.isSub = false,
      this.textColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: (isSub) ? Colors.black54 : this.color,
          onPrimary: Colors.white,
          elevation: (isSecond) ? 1 : 5,
          side: BorderSide(
              color: (isSecond) ? this.color : this.textColor, width: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: this.color, width: 1.5))),
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
