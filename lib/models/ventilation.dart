import 'package:flutter/cupertino.dart';

class Ventilation with ChangeNotifier {
  String _ventilation;

  String get ventilation => this._ventilation;

  set ventilation(String value) {
    this._ventilation = value;
    notifyListeners();
  }
}
