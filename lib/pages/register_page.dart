import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/register_bloc.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/header_curve_signin.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/helpers/mostrar_alerta.dart';

import 'package:chat/widgets/labels.dart';
import 'dart:ui' as ui;

class RegisterPage extends StatelessWidget {
  Future<ui.Image> image(String url) async =>
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
              height: _size.height,
              child: Stack(
                children: <Widget>[
                  WavyHeader(),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: _size.height / 8.5,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _signInGoogle(context);
                              },
                              child: roundedRectSignInSocialMediaButton(
                                  'Sign with Google',
                                  Colors.orange,
                                  FontAwesomeIcons.google,
                                  true,
                                  30),
                            ),
                            /*   roundedRectSignInSocialMediaButton(
                                'Sign with Facebook',
                                Color(0xff3C56A6),
                                FontAwesomeIcons.facebook,
                                false,
                                25), */
                            GestureDetector(
                              onTap: () async {
                                await _signIApple(context);
                              },
                              child: roundedRectSignInSocialMediaButton(
                                  'Sign In with Apple',
                                  Colors.white,
                                  FontAwesomeIcons.apple,
                                  false,
                                  27),
                            ),
                          ])),

                  Center(child: _Form()),

                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: _size.height / 1.1),
                      child: Labels(
                        rute: 'login',
                        title: '¿Ya tienes una cuenta?',
                        subTitulo: 'Ingresa ahora!',
                        colortText1: Colors.white70,
                        colortText2: currentTheme.accentColor,
                      ),
                    ),
                  ),
                  /*   Center(
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

    // final authService = Provider.of<AuthService>(context);
    // final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final _size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: _size.height / 3.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: _createEmail(bloc, context)),
          Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: _createUsername(bloc, context)),
          Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: _createPassword(bloc, context)),
          _createButton(bloc),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );

    /* Container(
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
          _createButton(bloc),

          ButtonGold(
              color: currentTheme.accentColor,
              text: 'Sign in with Google!',
              onPressed: authService.authenticated
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      _signInGoogle(context);
                    }),

          //  _createButtonSignInGoole(bloc)
        ],
      ),
    );
   */
  }

  final List<Color> orangeGradients = [
    Color(0xff34EC9C),
    Color(0xffF9A400),
    Color(0xff34EC9C),
  ];
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: currentTheme.scaffoldBackgroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

Widget roundedRectButtonIcon(
    String title, List<Color> gradient, IconData icon) {
  return Builder(builder: (BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Stack(
        alignment: Alignment(0.0, 0.1),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: currentTheme.accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 22),
              child: FaIcon(
                icon,
                color: currentTheme.accentColor,
                size: 18,
              )),
        ],
      ),
    );
  });
}

Widget roundedRectSignInSocialMediaButton(
    String title, Color color, IconData icon, bool isGoogle, double sizeIcon) {
  return Builder(builder: (BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        alignment: Alignment.center,
        width: size.width / 1.7,
        height: size.width / 7.0,
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.black26),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                child: (isGoogle)
                    ? Image.asset('assets/google_logo_icon.png')
                    : Container(
                        child: FaIcon(
                          icon,
                          color: color,
                          size: sizeIcon,
                        ),
                      )),
            Container(
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 13, bottom: 20),
      ),
    );
  });
}

Widget _createButton(RegisterBloc bloc) {
  // formValidStream
  // snapshot.hasData
  //  true ? algo si true : algo si false

  return StreamBuilder(
    stream: bloc.formValidStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      final authService = Provider.of<AuthService>(context);

      return Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: GestureDetector(
            child:
                roundedRectButton("Let's get Started", orangeGradients, false),
            onTap: authService.authenticated
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

Widget circleYellow() {
  return Transform.translate(
    offset: Offset(0.0, 210.0),
    child: Material(
      color: Colors.yellow,
      child: Padding(padding: EdgeInsets.all(140)),
      shape: CircleBorder(side: BorderSide(color: Colors.white, width: 15.0)),
    ),
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
              // icon: Icon(Icons.alternate_email),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: currentTheme.accentColor, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Phone number or email',
              errorText: snapshot.error),
          onChanged: bloc.changeEmail,
        ),
      );
    },
  );
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
        context, 'Error del servidor', 'Ingrese un correo electrónico valido');
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
              // icon: Icon(Icons.perm_identity),
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
              // icon: Icon(Icons.lock_outline),
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
