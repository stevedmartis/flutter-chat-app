import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomInput extends StatefulWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput(
      {Key key,
      @required this.icon,
      @required this.placeholder,
      @required this.textController,
      this.keyboardType = TextInputType.text,
      this.isPassword = false})
      : super(key: key);

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {

    FocusNode _focusNode;

@override
void dispose() {
  super.dispose();
  _focusNode.dispose();
}

@override
void initState() {
  super.initState();
  _focusNode = new FocusNode();
  _focusNode.addListener(_onOnFocusNodeEvent);
}

_onOnFocusNodeEvent() {
  setState(() {
    // Re-renders
  });
}

  @override
  Widget build(BuildContext context) {

        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
       Color(0xff202020),
            Color(0xff1D1D1D),
          Color(0xff161616),
        ]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.30),
                offset: Offset(0, 5),
                blurRadius: 5)
          ]),
      child: TextField(
        style: TextStyle(color: Colors.white),
focusNode: this._focusNode,
        controller: this.widget.textController,
        autocorrect: false,
        keyboardType: this.widget.keyboardType,
        obscureText: this.widget.isPassword,
        decoration: InputDecoration(
            
            prefixIcon: Icon(this.widget.icon,
            color: this._focusNode.hasFocus
                ? currentTheme.accentColor
                : Colors.white.withOpacity(0.30)),
            
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: this.widget.placeholder,
            hintStyle: TextStyle(color:Colors.white.withOpacity(0.30) )),
      ),
    );
  }
}
