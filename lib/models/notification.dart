import 'package:flutter/material.dart';

class NotificationModel extends ChangeNotifier {
  int _number = 0;
  AnimationController _bounceController;

  int get number => this._number;

  set number(int value) {
    this._number = value;
    notifyListeners();
  }

  AnimationController get bounceController => this._bounceController;

  set bounceController(AnimationController controller) {
    this._bounceController = controller;
  }

  int _numberNotifiBell = 0;
  AnimationController _bounceControllerNotifiBeel;

  int get numberNotifiBell => this._numberNotifiBell;

  set numberNotifiBell(int value) {
    this._number = value;
    notifyListeners();
  }

  AnimationController get bounceControllerBell =>
      this._bounceControllerNotifiBeel;

  set bounceControllerBell(AnimationController controller) {
    this._bounceControllerNotifiBeel = controller;
  }
}
