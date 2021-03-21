import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/register_bloc.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/clip_oval.dart';
import 'package:chat/widgets/header_curve_signin.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/helpers/mostrar_alerta.dart';

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
                    margin: EdgeInsets.only(top: _size.height / 6),
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
                                fontSize: _size.height / 30),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(child: _Form()),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: _size.height / 1.5,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildCircleGoogle(context),
                            _buildCircleApple(context),
                          ])),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: _size.height / 1.1),
                      child: Labels(
                        rute: 'login',
                        title: '¿Ya tienes una cuenta?',
                        subTitulo: 'Inicia sesión aquí!',
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
}

Container _buildCircleGoogle(context) {
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
          // button color
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

Container _buildCircleApple(context) {
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
                  color:
                      (currentTheme.customTheme) ? Colors.white : Colors.black,
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
              child: _createUsername(bloc, context)),
          Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: _createPassword(bloc)),
          _createButton(bloc),
          Container(
            padding: EdgeInsets.only(top: _size.height / 40),
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

  final List<Color> orangeGradients = [
    Color(0xff34EC9C),
    Color(0xffF9A400),
    Color(0xff34EC9C),
  ];
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible, bool isBlack) {
  return Builder(builder: (BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: 0),
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
                    color: (isBlack) ? Colors.black : Colors.white,
                    fontSize: _size.height / 40,
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
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        alignment: Alignment.center,
        width: size.width / 1.7,
        height: size.width / 7.0,
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: (currentTheme.customTheme)
                ? currentTheme.currentTheme.cardColor
                : Colors.white54),
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
                          color: (currentTheme.customTheme)
                              ? Colors.white
                              : Colors.black,
                          size: sizeIcon,
                        ),
                      )),
            Container(
              child: Text(title,
                  style: TextStyle(
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : Colors.black,
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
  return StreamBuilder(
    stream: bloc.formValidStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      final authService = Provider.of<AuthService>(context);

      return Container(
        padding: EdgeInsets.only(left: 30, right: 30, top: 20),
        child: GestureDetector(
            child: roundedRectButton("Comenzar!", orangeGradients, false, true),
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

Widget _createEmail(RegisterBloc bloc) {
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

Widget _createPassword(RegisterBloc bloc) {
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

Widget _createUsername(RegisterBloc bloc, context) {
  final currentTheme = Provider.of<ThemeChanger>(context);

  return StreamBuilder(
    stream: bloc.usernameSteam,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          style: TextStyle(
            color: (currentTheme.customTheme) ? Colors.white : Colors.black,
          ),
          //  keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: currentTheme.currentTheme.accentColor, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),

              // icon: Icon(Icons.perm_identity),
              //  fillColor: currentTheme.accentColor,

              hintText: '',
              labelText: 'Nombre de usuario *',
              labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54),
              // counterText: snapshot.data,
              errorText: snapshot.error),
          onChanged: bloc.changeUsername,
        ),
      );
    },
  );
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
}

_register(RegisterBloc bloc, BuildContext context) async {
  final authService = Provider.of<AuthService>(context, listen: false);
  final socketService = Provider.of<SocketService>(context, listen: false);

  final registroOk = await authService.register(
      bloc.username.trim(), bloc.email.trim(), bloc.password.trim());

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
