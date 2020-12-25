import 'package:chat/bloc/profile_bloc.dart';
import 'package:chat/bloc/provider.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/myprofile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/widgets/button_gold.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final profile = authService.profile;

    changeStatusDark();

    return Scaffold(
      body: Center(
        child: MyProfile(
          profile: profile,
          isUserAuth: true,
          isUserEdit: true,
        ),
      ),
    );
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
  final lastName = TextEditingController();
  bool isUsernameChange = false;
  bool isNameChange = false;
  bool isEmailChange = false;
  bool isPassChange = false;

  @override
  void initState() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final profile = authService.profile;

    usernameCtrl.text = profile.user.username;
    nameCtrl.text = profile.name;
    emailCtrl.text = profile.user.email;
    lastName.text = profile.lastName;

    usernameCtrl.addListener(() {
      //print('${usernameCtrl.text}');

      setState(() {
        if (usernameCtrl.text != profile.user.username)
          this.isUsernameChange = true;
        else
          this.isUsernameChange = false;
      });
    });
    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (profile.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;
      });
    });
    emailCtrl.addListener(() {
      //print('${emailCtrl.text}');
      setState(() {
        if (profile.user.email != emailCtrl.text)
          this.isEmailChange = true;
        else
          this.isEmailChange = false;
      });
    });
    passCtrl.addListener(() {
      // print('${passCtrl.text}');
      setState(() {
        if (passCtrl.text.length >= 6)
          this.isPassChange = true;
        else
          this.isPassChange = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    lastName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final authService = Provider.of<AuthService>(context);

    final bloc = CustomProvider.profileBlocIn(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(
        children: <Widget>[
          _createUsername(bloc, usernameCtrl),
          SizedBox(
            height: 10,
          ),
          _createEmail(bloc, emailCtrl),
          SizedBox(
            height: 10,
          ),
          _createName(bloc, nameCtrl),
          SizedBox(
            height: 10,
          ),
          // _createLastName(bloc),

          _createPassword(bloc, passCtrl),
          SizedBox(
            height: 30,
          ),
          _createButton(bloc, this.isUsernameChange, this.isEmailChange,
              this.isNameChange, this.isPassChange),

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

Widget _createButton(ProfileBloc bloc, bool isUsernameChange,
    bool isEmailChange, bool isNameChange, bool isPassChange) {
  // formValidStream
  // snapshot.hasData
  //  true ? algo si true : algo si false

  return StreamBuilder(
    stream: bloc.formValidStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      final authService = Provider.of<AuthService>(context);
      final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
      return ButtonGold(
          color: currentTheme.accentColor,
          text: 'Save',
          onPressed: authService.authenticated
              ? null
              : isUsernameChange ||
                      isEmailChange ||
                      isNameChange ||
                      isPassChange
                  ? () => {
                        FocusScope.of(context).unfocus(),
                        _editProfile(bloc, context)
                      }
                  : null);
    },
  );
}

Widget _createEmail(ProfileBloc bloc, TextEditingController emailCtl) {
  return StreamBuilder(
    stream: bloc.emailStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: emailCtl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              icon: Icon(Icons.alternate_email),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
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

Widget _createUsername(ProfileBloc bloc, TextEditingController usernameCtrl) {
  return StreamBuilder(
    stream: bloc.usernameSteam,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: usernameCtrl,
          //  keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              icon: Icon(Icons.perm_identity),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
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

Widget _createName(ProfileBloc bloc, TextEditingController nameCtrl) {
  return StreamBuilder(
    stream: bloc.nameStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: nameCtrl,
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

/* Widget _createLastName(ProfileBloc bloc, TextEditingController lastNameCtrl) {
  return StreamBuilder(
    stream: bloc.lastNameStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: lastNameCtrl,
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
Widget _createPassword(ProfileBloc bloc, TextEditingController passCtrl) {
  return StreamBuilder(
    stream: bloc.passwordStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock_outline),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
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

_editProfile(ProfileBloc bloc, BuildContext context) async {
  final authService = Provider.of<AuthService>(context, listen: false);
  final socketService = Provider.of<SocketService>(context, listen: false);

  final profile = authService.profile;

  print('================');
  print('name: ${bloc.name}');
  print('Password: ${bloc.password}');
  print('email: ${bloc.email}');
  print('username: ${bloc.username}');
  print('================');

  final username =
      (bloc.username == null) ? profile.user.username : bloc.username.trim();

  final name = (bloc.name == null) ? profile.name : bloc.name.trim();

  final email = (bloc.email == null) ? profile.user.email : bloc.email.trim();

  final password = (bloc.password == null) ? '' : bloc.password.trim();

  final editProfileOk = await authService.editProfile(
      profile.user.uid, username, name, email, password);

  if (editProfileOk != null) {
    if (editProfileOk == true) {
      socketService.connect();

      Navigator.push(context, _createRoute());
    } else {
      mostrarAlerta(context, 'Error', editProfileOk);
    }
  } else {
    mostrarAlerta(
        context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
  }
  //Navigator.pushReplacementNamed(context, '');
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-0.5, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
