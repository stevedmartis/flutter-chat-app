import 'package:chat/bloc/air_bloc.dart';
import 'package:chat/bloc/catalogo_bloc.dart';
import 'package:chat/bloc/light_bloc.dart';
import 'package:chat/bloc/login_bloc.dart';
import 'package:chat/bloc/plant_bloc.dart';
import 'package:chat/bloc/product_bloc.dart';
import 'package:chat/bloc/profile_bloc.dart';
import 'package:chat/bloc/register_bloc.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/bloc/subscribe_bloc.dart';
import 'package:chat/bloc/visit_bloc.dart';
import 'package:flutter/material.dart';

class CustomProvider extends InheritedWidget {
  final loginBloc = new LoginBloc();

  final registerBloc = new RegisterBloc();

  final profileBloc = new ProfileBloc();

  final roomBloc = new RoomBloc();

  final productBloc = ProductBloc();

  final plantBloc = PlantBloc();

  final airBloc = AirBloc();

  final lightBloc = LightBloc();

  final visitBloc = VisitBloc();

  final catalogoBloc = CatalogoBloc();

  final subscribeBloc = SubscribeBloc();

  static CustomProvider _instancia;

  factory CustomProvider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new CustomProvider._internal(key: key, child: child);
    }

    return _instancia;
  }

  CustomProvider._internal({Key key, Widget child})
      : super(key: key, child: child);

  // Provider({ Key key, Widget child })
  //   : super(key: key, child: child );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .loginBloc;
  }

  static RegisterBloc registerBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .registerBloc;
  }

  static ProfileBloc profileBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .profileBloc;
  }

  static RoomBloc roomBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .roomBloc;
  }

  static PlantBloc plantBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .plantBloc;
  }

  static AirBloc airBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .airBloc;
  }

  static LightBloc lightBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .lightBloc;
  }

  static VisitBloc visitBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .visitBloc;
  }

  static SubscribeBloc subscribeBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .subscribeBloc;
  }

  static ProductBloc productBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .productBloc;
  }

  static CatalogoBloc catalogoBlocIn(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomProvider>())
        .catalogoBloc;
  }
}
