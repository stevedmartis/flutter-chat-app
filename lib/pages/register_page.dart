import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/register_bloc.dart';
import 'package:chat/controllers/slide_controler.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/headercurves_logo_text.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/helpers/mostrar_alerta.dart';

import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/button_gold.dart';
import 'dart:ui' as ui;

class RegisterPage extends StatelessWidget {
  Future<ui.Image> _image(String url) async =>
      await NetworkImageDecoder(image: NetworkImage(url)).uiImage;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    changeStatusDark();
    return Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: _size.height + 100,
              child: Stack(
                children: <Widget>[
                  FutureBuilder<ui.Image>(
                    initialData: null,
                    future:
                        _image("https://wallpapercave.com/wp/wp2869931.jpg"),
                    builder: (BuildContext context,
                            AsyncSnapshot<ui.Image> snapshot) =>
                        !snapshot.hasData
                            ? HeaderMultiCurvesImageEmptyText(
                                isEmpty: true,
                                color: Colors.white,
                                image: snapshot.data,
                              )
                            : HeaderMultiCurvesImageEmptyText(
                                color: Colors.white,
                                image: snapshot.data,
                                title: 'Sign Up!',
                                subtitle: 'Hello!',
                              ),
                  ),

                  /*   HeaderMultiCurvesText(
                      title: 'Sign Up!',
                      subtitle: 'Hello,',
                      color: currentTheme.accentColor), */
                  Center(
                      child: Container(
                          margin: EdgeInsets.only(top: _size.height / 3),
                          child: _Form())),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: _size.height / 1.1),
                      child: Labels(
                        rute: 'login',
                        title: '¿Ya tienes una cuenta?',
                        subTitulo: 'Ingresa ahora!',
                        colortText1: Colors.white70,
                        colortText2: Color(0xffD9B310),
                      ),
                    ),
                  ),
                  Center(
                      child: Container(
                          margin: EdgeInsets.only(top: _size.height),
                          child: StyledLogoCustom()))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final bloc = CustomProvider.registerBlocIn(context);

    return Container(
      margin: EdgeInsets.only(top: 20),
      // padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          _createUsername(bloc, context),
          SizedBox(
            height: 10,
          ),
          _createEmail(bloc, context),
          SizedBox(
            height: 10,
          ),
          /*     _createName(bloc),
          SizedBox(
            height: 10,
          ), */
          // _createLastName(bloc),

          _createPassword(bloc, context),
          SizedBox(
            height: 30,
          ),
          _createButton(bloc)
        ],
      ),
    );
  }
}

Widget _createButton(RegisterBloc bloc) {
  // formValidStream
  // snapshot.hasData
  //  true ? algo si true : algo si false

  return StreamBuilder(
    stream: bloc.formValidStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      final authService = Provider.of<AuthService>(context);
      final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ButtonGold(
            color: currentTheme.accentColor,
            text: 'Create my account!',
            onPressed: authService.authenticated
                ? null
                : snapshot.hasData
                    ? () => {
                          FocusScope.of(context).unfocus(),
                          _register(bloc, context)
                        }
                    : null),
      );
    },
  );
}

Widget _createEmail(RegisterBloc bloc, context) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return StreamBuilder(
    stream: bloc.emailStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              icon: Icon(Icons.alternate_email),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: currentTheme.accentColor, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Email',
              errorText: snapshot.error),
          onChanged: bloc.changeEmail,
        ),
      );
    },
  );
}

_register(RegisterBloc bloc, BuildContext context) async {
  final authService = Provider.of<AuthService>(context, listen: false);
  final socketService = Provider.of<SocketService>(context, listen: false);

  final registroOk = await authService.register(
      bloc.username.trim(), bloc.email.trim(), bloc.password.trim());

  print('================');
  print('name: ${bloc.name}');
  print('Password: ${bloc.password}');
  print('email: ${bloc.email}');
  print('username: ${bloc.username}');
  print('================');

  if (registroOk != null) {
    if (registroOk == true) {
      socketService.connect();
      Navigator.push(context, _createRute());
    } else {
      mostrarAlerta(context, 'Registro incorrecto', registroOk);
    }
  } else {
    mostrarAlerta(
        context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
  }
  //Navigator.pushReplacementNamed(context, '');
}

Widget _createUsername(RegisterBloc bloc, context) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return StreamBuilder(
    stream: bloc.usernameSteam,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          //  keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              icon: Icon(Icons.perm_identity),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: currentTheme.accentColor, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Username',
              // counterText: snapshot.data,
              errorText: snapshot.error),
          onChanged: bloc.changeUsername,
        ),
      );
    },
  );
}

/* Widget _createName(RegisterBloc bloc) {
  return StreamBuilder(
    stream: bloc.nameStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          //  keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              icon: Icon(Icons.perm_identity),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Name',
              //counterText: snapshot.data,
              errorText: snapshot.error),
          onChanged: bloc.changeName,
        ),
      );
    },
  );
}
 */
/* Widget _createLastName(RegisterBloc bloc) {
  return StreamBuilder(
    stream: bloc.lastNameStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          //  keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              icon: Icon(Icons.perm_identity),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Last Name',
              counterText: snapshot.data,
              errorText: snapshot.error),
          onChanged: bloc.changeLastName,
        ),
      );
    },
  );
}
 */
Widget _createPassword(RegisterBloc bloc, context) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return StreamBuilder(
    stream: bloc.passwordStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_outline),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: currentTheme.accentColor, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Password',
              counterText: snapshot.data,
              errorText: snapshot.error),
          onChanged: bloc.changePassword,
        ),
      );
    },
  );
}

Route _createRute() {
  return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          PrincipalPage(),
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: Curves.easeInOut);

        return FadeTransition(
            child: child,
            opacity:
                Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation));
      });
}
