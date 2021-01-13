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
          accentColor: Color(0xff20FFD7),
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
          accentColor: Color(0xff20FFD7),
          primaryColor: Color(0xffD9B310),
          scaffoldBackgroundColor: Color(0xff1C3041),
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
        accentColor: Color(0xff16202B),
        primaryColorLight: Colors.white,
      );
    }
    notifyListeners();
  }

  set customTheme(bool value) {
    _customTheme = value;
    _darkTheme = false;

    if (value) {
      _currentTheme = ThemeData.dark().copyWith(
        accentColor: Color(0xff20FFD7), // Sea green Crayon
        primaryColor: Color(0xffD9B310),
        primaryColorLight: Colors.white,
        scaffoldBackgroundColor: Color(0xff1C3041), // gummetal
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
      );
    } else {
      _currentTheme = ThemeData.light();
    }

    notifyListeners();
  }
}
