import 'package:chat/controllers/slide_controler.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/theme/theme.dart';

import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/button_gold.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userAuth = authService.user;

    changeStatusDark();

    return Scaffold(
      body: Center(
        child: SliverAppBarSnap(
          user: userAuth,
          isUserAuth: true,
          isUserEdit: true,
        ),
      ),
    );

    /* Scaffold(
        backgroundColor: Color(0xff0F0F0F),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.95,
          child: Stack(
            children: <Widget>[
              HeaderMultiCurvesText(
                  title: '', subtitle: 'Mi Perfil', color: Color(0xffD9B310)),
              Positioned(
                left: 140,
                top: 160,
                child: Container(
                  width: 150,
                  height: 150,
                  child: Hero(
                      tag: userAuth.uid,
                      child: ImageUserChat(
                          width: 150,
                          height: 150,
                          user: userAuth,
                          fontsize: 20)),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 350),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_Form(userAuth), StyledLogoCustom()],
                    ),
                  )),
            ],
          ),
        ));
   */
  }
}

class FormEditUserprofile extends StatefulWidget {
  final User user;
  FormEditUserprofile(this.user);

  @override
  _FormEditUserprofileState createState() => _FormEditUserprofileState();
}

class _FormEditUserprofileState extends State<FormEditUserprofile> {
  final usernameCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final profile = authService.profile;

    usernameCtrl.text = widget.user.username;
    emailCtrl.text = widget.user.email;
    nameCtrl.text = profile.name;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Color(0xffD9B310)),
            child: CustomInput(
              icon: Icons.alternate_email,
              placeholder: 'Username',
              keyboardType: TextInputType.text,
              textController: usernameCtrl,
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Color(0xffD9B310)),
            child: CustomInput(
              icon: Icons.perm_identity,
              placeholder: 'Name',
              keyboardType: TextInputType.text,
              textController: nameCtrl,
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Color(0xffD9B310)),
            child: CustomInput(
              icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl,
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Color(0xffD9B310)),
            child: CustomInput(
              icon: Icons.lock_outline,
              placeholder: 'Password',
              textController: passCtrl,
              isPassword: true,
            ),
          ),
          ButtonGold(
            color: currentTheme.accentColor,
            text: 'Guardar',
            onPressed: authService.authenticated
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    print(nameCtrl.text);
                    print(emailCtrl.text);
                    print(passCtrl.text);
                    final registroOk = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim());
                    if (registroOk != null) {
                      if (registroOk == true) {
                        socketService.connect();
                        Navigator.push(context, _createRute());
                      } else {
                        mostrarAlerta(
                            context, 'Registro incorrecto', registroOk);
                      }
                    } else {
                      mostrarAlerta(context, 'Error del servidor',
                          'lo sentimos, Intentelo mas tarde');
                    }
                  },
          ),
          SizedBox(
            height: 50,
          ),
          ButtonGold(
            textColor: currentTheme.secondaryHeaderColor,
            color: currentTheme.scaffoldBackgroundColor,
            text: 'Log out',
            onPressed: authService.authenticated
                ? null
                : () async {
                    final socketService =
                        Provider.of<SocketService>(context, listen: false);

                    socketService.disconnect();
                    Navigator.pushReplacementNamed(context, 'login');
                    AuthService.deleteToken();
                  },
          )
        ],
      ),
    );
  }
}

Route _createRute() {
  return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          UsersPage(),
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
