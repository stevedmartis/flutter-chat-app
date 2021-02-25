import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool _darkTheme = false;
  bool _customTheme = false;

  ThemeData _currentTheme;

  bool get darkTheme => this._darkTheme;

  bool get customTheme => this._customTheme;

  ThemeData get currentTheme => this._currentTheme;

  ThemeChanger(int theme) {
    switch (theme) {
      case 1:
        _darkTheme = false;
        _customTheme = false;
        _currentTheme = ThemeData.light().copyWith(
          accentColor: Color(0xff34EC9C),
          scaffoldBackgroundColor: Color(0xffEDE9EC),
          primaryColor: Color(0xffCBC3C5),
        );

        break;
      case 2:
        _darkTheme = true;
        _customTheme = false;
        _currentTheme = ThemeData.dark().copyWith(
          accentColor: Colors.black,
        );
        break;
      case 3:
        _darkTheme = false;
        _customTheme = true;
        _currentTheme = ThemeData.dark().copyWith(
          accentColor: Color(0xff34EC9C),
          primaryColor: Color(0xffA39FA2),
          scaffoldBackgroundColor: Color(0xff1C181D),
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
        );
        break;
      default:
        _darkTheme = false;
        _customTheme = false;
        _currentTheme = ThemeData.light();
    }
  }

  set darkTheme(bool value) {
    _customTheme = false;
    _darkTheme = value;

    if (value) {
      _currentTheme = ThemeData.dark().copyWith(
        accentColor: Colors.black,
        primaryColorLight: Colors.white,
      );
    } else {
      _currentTheme = ThemeData.light().copyWith(
          accentColor: Colors.black, primaryColorLight: Color(0xffEDE9EC));
    }
    notifyListeners();
  }

  set customTheme(bool value) {
    _customTheme = value;
    _darkTheme = false;

    if (value) {
      _currentTheme = ThemeData.dark().copyWith(
        accentColor: Color(0xff34EC9C), // Sea green Crayon
        primaryColor: Color(0xffA39FA2).withOpacity(0.50),

        primaryColorLight: Colors.white,
        scaffoldBackgroundColor: Color(0xff1C181D), // gummetal
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
      );
    } else {
      _currentTheme = ThemeData.light().copyWith(
        accentColor: Color(0xff34EC9C),
        scaffoldBackgroundColor: Color(0xffEDE9EC),
        primaryColor: Color(0xffCBC3C5),
      );
    }

    notifyListeners();
  }
}
