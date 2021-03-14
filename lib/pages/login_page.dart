import 'package:chat/bloc/login_bloc.dart';
import 'package:chat/bloc/provider.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/header_curve_signin.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';

import 'package:chat/helpers/mostrar_alerta.dart';

import 'dart:ui' as ui;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<ui.Image> image(String url) async =>
      await NetworkImageDecoder(image: NetworkImage(url)).uiImage;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final _size = MediaQuery.of(context).size;

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
              height: _size.height,
              child: Stack(
                children: <Widget>[
                  WavyHeader(),

                  Center(child: _Form()),

                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: _size.height / 1.45,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _signInGoogle(context);
                              },
                              child: roundedRectSignInSocialMediaButton(
                                  'Ingresar con Google',
                                  Colors.orange,
                                  FontAwesomeIcons.google,
                                  true,
                                  30),
                            ),
                            /*   roundedRectSignInSocialMediaButton(
                                'Log in with Facebook',
                                Color(0xff3C56A6),
                                FontAwesomeIcons.facebook,
                                false,
                                25), */
                            GestureDetector(
                              onTap: () async {
                                await _signIApple(context);
                              },
                              child: roundedRectSignInSocialMediaButton(
                                  'Ingresar con Apple',
                                  Colors.white,
                                  FontAwesomeIcons.apple,
                                  false,
                                  27),
                            ),
                          ])),

                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: _size.height / 1.1),
                      child: Labels(
                        rute: 'register',
                        title: "No tienes una cuenta?",
                        subTitulo: 'Registate aquí',
                        colortText1: Colors.grey,
                        colortText2: currentTheme.accentColor,
                      ),
                    ),
                  ),
                  /* Center(
                      child: Container(
                          margin: EdgeInsets.only(top: _size.height / 1.1),
                          child: StyledLogoCustom())), */
                  //Container(child: circleYellow())
                ],
              ),
            ),
          ),
        ));
  }

  _signIApple(BuildContext context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    final signInGoogleOk = await authService.appleSignIn();

    print(signInGoogleOk);
    if (signInGoogleOk) {
      socketService.connect();
      Navigator.push(context, _createRute());
    } else {
      // Mostara alerta
      mostrarAlerta(context, 'Login incorrecto', 'El correo ya existe');
    }

    //Navigator.pushReplacementNamed(context, '');
  }

  _signInGoogle(BuildContext context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final signInGoogleOk = await authService.signInWitchGoogle();

    print(signInGoogleOk);
    if (signInGoogleOk) {
      socketService.connect();
      Navigator.push(context, _createRute());
    } else {
      // Mostara alerta
      mostrarAlerta(context, 'Login incorrecto', 'El correo ya existe');
    }

    //Navigator.pushReplacementNamed(context, '');
  }
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

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  //final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = CustomProvider.of(context);

    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final _size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: _size.height / 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: _createEmail(bloc)),
          Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: _createPassword(bloc)),
          GestureDetector(
              onTap: () {
                _login(bloc, context);
              },
              child:
                  roundedRectButton("Ingresar", orangeGradients, false, false)),
          Container(
            child: Text(
              'o',
              style: TextStyle(color: Colors.grey),
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                // icon: Icon(Icons.alternate_email),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Email',
                counterText: snapshot.data,
                labelStyle: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54),
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            obscureText: true,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                // icon: Icon(Icons.lock_outline),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54),
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
        transitionDuration: Duration(milliseconds: 1500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);

          return FadeTransition(
              child: child,
              opacity:
                  Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation));
        });
  }

  /* Widget _crearBoton(LoginBloc bloc) {
    // formValidStream
    // snapshot.hasData
    //  true ? algo si true : algo si false

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final authService = Provider.of<AuthService>(context);
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return Container(
          padding: EdgeInsets.all(20),
          child: ButtonGold(
            color: currentTheme.accentColor,
            text: 'Log In',
            onPressed: authService.authenticated
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    _login(bloc, context);
                  },
          ),
        );
      },
    );
  }
 */
  _login(LoginBloc bloc, BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    print('================');
    print('Email: ${bloc.email}');
    print('Password: ${bloc.password}');
    print('================');

    final loginOk =
        await authService.login(bloc.email.trim(), bloc.password.trim());

    if (loginOk) {
      socketService.connect();
      Navigator.push(context, _createRute());
    } else {
      // Mostara alerta
      mostrarAlerta(
          context, 'Login incorrecto', 'Revise sus credenciales nuevamente');
    }

    //Navigator.pushReplacementNamed(context, '');
  }
}
