import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ventilation with ChangeNotifier {
  String _ventilation;

  String get ventilation => this._ventilation;

  set ventilation(String value) {
    this._ventilation = value;
    notifyListeners();
  }
}

class SexoModel with ChangeNotifier {
  DropdownMenuItem _sexo = DropdownMenuItem(
    value: '0',
    child: Text('Sexo'),
  );

  DropdownMenuItem get sexo => this._sexo;

  set sexo(DropdownMenuItem value) {
    this._sexo = value;
    //notifyListeners();
  }
}
