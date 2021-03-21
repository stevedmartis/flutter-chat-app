import 'package:chat/bloc/login_bloc.dart';
import 'package:chat/bloc/provider.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/clip_oval.dart';
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
                  Container(
                    margin: EdgeInsets.only(top: _size.height / 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: _size.width / 5.0,
                          height: _size.height / 5.0,
                          child: Image.asset('assets/icons/leafety.png'),
                          alignment: Alignment.topCenter,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                            'leafety',
                            style: TextStyle(
                                letterSpacing: -1.0,
                                fontWeight: FontWeight.w600,
                                color: currentTheme.accentColor,
                                fontSize: _size.height / 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(child: _Form()),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: _size.height / 1.6,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildCircleGoogle(),
                            _buildCircleApple(),
                          ])),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: _size.height / 1.1),
                      child: Labels(
                        rute: 'register',
                        title: "¿No tienes una cuenta?",
                        subTitulo: 'Registate aquí',
                        colortText1: Colors.grey,
                        colortText2: currentTheme.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Container _buildCircleGoogle() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.only(right: 20, top: 0),
      child: ClipOvalShadow(
        shadow: Shadow(
          color: currentTheme.currentTheme.accentColor,
          offset: Offset(1.0, 1.0),
          blurRadius: 2,
        ),
        clipper: CustomClipperOval(),
        child: ClipOval(
          child: Material(
            color: currentTheme.currentTheme.cardColor, // button color
            child: InkWell(
              onTap: () {
                _signInGoogle(context);
              },
              splashColor: Colors.white, // inkwell color
              child: CircleAvatar(
                backgroundColor:
                    currentTheme.currentTheme.scaffoldBackgroundColor,
                child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/google-icon.png')),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildCircleApple() {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.only(right: 20, top: 0),
      child: ClipOvalShadow(
        shadow: Shadow(
          color: currentTheme.currentTheme.accentColor,
          offset: Offset(1.0, 1.0),
          blurRadius: 2,
        ),
        clipper: CustomClipperOval(),
        child: ClipOval(
          child: Material(
            color: Colors.black, // button color
            child: InkWell(
              // splashColor: Colors.red, // inkwell color
              child: CircleAvatar(
                backgroundColor:
                    currentTheme.currentTheme.scaffoldBackgroundColor,
                child: Container(
                  child: FaIcon(
                    FontAwesomeIcons.apple,
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                    size: 30,
                  ),
                ),
              ),
              onTap: () async {
                await _signIApple(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  _signIApple(BuildContext context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    final signInGoogleOk = await authService.appleSignIn();

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
      margin: EdgeInsets.only(top: _size.height / 10),
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
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: GestureDetector(
                onTap: () {
                  _login(bloc, context);
                },
                child: roundedRectButton(
                    "Ingresar", orangeGradients, false, true)),
          ),
          Container(
            padding: EdgeInsets.only(top: _size.height / 30),
            child: Text(
              'o accede con:',
              style: TextStyle(color: Colors.grey, fontSize: _size.height / 40),
            ),
            alignment: Alignment.center,
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
                labelText: 'Email *',
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
                labelText: 'Contraseña *',
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

  _login(LoginBloc bloc, BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

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
