import 'package:chat/bloc/profile_bloc.dart';
import 'package:chat/bloc/provider.dart';
import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/pages/avatar_image.dart';
import 'package:chat/pages/header_image.dart';
import 'package:chat/pages/profile_card.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/services/auth_service.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  Profiles profile;

  final usernameCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final lastName = TextEditingController();

  bool isUsernameChange = false;
  bool isNameChange = false;
  bool isAboutChange = false;
  bool isEmailChange = false;
  bool isPassChange = false;
  bool errorRequired = false;

  @override
  void initState() {
    final authService = Provider.of<AuthService>(context, listen: false);
    profile = authService.profile;

    usernameCtrl.text = profile.user.username;
    nameCtrl.text = profile.name;
    aboutCtrl.text = profile.about;

    emailCtrl.text = profile.user.email;
    lastName.text = profile.lastName;

    profileBloc.imageUpdate.add(true);

    usernameCtrl.addListener(() {
      setState(() {
        if (usernameCtrl.text != profile.user.username)
          this.isUsernameChange = true;
        else
          this.isUsernameChange = false;

        if (usernameCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });
    nameCtrl.addListener(() {
      setState(() {
        if (profile.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;
        if (nameCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });
    aboutCtrl.addListener(() {
      setState(() {
        if (profile.about != aboutCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });
    emailCtrl.addListener(() {
      setState(() {
        if (profile.user.email != emailCtrl.text)
          this.isEmailChange = true;
        else
          this.isEmailChange = false;

        if (emailCtrl.text == "")
          this.errorRequired = true;
        else
          this.errorRequired = false;
      });
    });
    passCtrl.addListener(() {
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
    aboutCtrl.dispose();

    profileBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    // final awsService = Provider.of<AwsService>(context);

    final bloc = CustomProvider.profileBlocIn(context);
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            (currentTheme.customTheme) ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor:
              (currentTheme.customTheme) ? Colors.black : Colors.white,
          actions: [
            _createButton(bloc, this.isUsernameChange, this.isAboutChange,
                this.isEmailChange, this.isNameChange, this.isPassChange),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: currentTheme.currentTheme.accentColor,
            ),
            iconSize: 30,
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          ),
          title: Text(
            'Edit profile',
            style: TextStyle(
                color:
                    (currentTheme.customTheme) ? Colors.white : Colors.black),
          ),
        ),
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            //  _snapAppbar();
            // if (_scrollController.offset >= 250) {}
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: <Widget>[
                  SliverFixedExtentList(
                    itemExtent: size.height / 3.7,
                    delegate: SliverChildListDelegate(
                      [
                        StreamBuilder<bool>(
                          stream: profileBloc.imageUpdate.stream,
                          builder: (context, AsyncSnapshot<bool> snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 200),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          HeaderImagePage(
                                            profile: this.profile,
                                          )));
                                },
                                child: Hero(
                                  tag: profile.imageHeader,
                                  child: Image(
                                    image: NetworkImage(
                                      profile.getHeaderImg(),
                                    ),
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return _buildErrorWidget(snapshot.error);
                            } else {
                              return _buildLoadingWidget();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SliverFixedExtentList(
                      itemExtent: 20,
                      delegate: SliverChildListDelegate([Container()])),
                  SliverFixedExtentList(
                      itemExtent: 100,
                      delegate: SliverChildListDelegate([
                        Container(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: currentTheme
                                  .currentTheme.scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: ProfileCard.avatarRadius,
                                backgroundColor: currentTheme
                                    .currentTheme.scaffoldBackgroundColor,
                                child: GestureDetector(
                                  onTap: () => {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 200),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            AvatarImagePage(
                                              profile: this.profile,
                                            ))),

                                    // make changes here

                                    //Navigator.of(context).push(createRouteAvatarProfile(this.user));
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: Hero(
                                      tag: profile.user.uid,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: ImageUserChat(
                                          width: 100,
                                          // showBorderAvatar: _showBorderAvatar,
                                          height: 100,
                                          profile: profile,
                                          fontsize: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                        child: Column(
                          children: <Widget>[
                            _createName(bloc, nameCtrl),
                            SizedBox(
                              height: 10,
                            ),
                            _createUsername(bloc, usernameCtrl),
                            SizedBox(
                              height: 10,
                            ),

                            _createAbout(bloc, aboutCtrl),
                            SizedBox(
                              height: 10,
                            ),
                            // _createLastName(bloc),
                            _createEmail(bloc, emailCtrl),
                            SizedBox(
                              height: 10,
                            ),
                            _createPassword(bloc, passCtrl),
                            SizedBox(
                              height: 30,
                            ),

                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      )),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
        height: 400.0, child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _createButton(
      ProfileBloc bloc,
      bool isUsernameChange,
      bool isAboutChange,
      bool isEmailChange,
      bool isNameChange,
      bool isPassChange) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // final authService = Provider.of<AuthService>(context);
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        final isControllerChange = isUsernameChange ||
            isEmailChange ||
            isNameChange ||
            isPassChange ||
            isAboutChange;

        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                      color: (isControllerChange && !errorRequired)
                          ? currentTheme.accentColor
                          : Colors.grey.withOpacity(0.60),
                      fontSize: 18),
                ),
              ),
            ),
            onTap: (isControllerChange && !errorRequired)
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
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: emailCtl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Email *',
                //counterText: snapshot.data,
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
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: usernameCtrl,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Nombre de usuario *',
                //counterText: snapshot.data,
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
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: nameCtrl,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Nombre',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createAbout(ProfileBloc bloc, TextEditingController aboutCtrl) {
    return StreamBuilder(
      stream: bloc.aboutStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
              style: TextStyle(
                color: (currentTheme.customTheme) ? Colors.white : Colors.black,
              ),
              inputFormatters: [
                new LengthLimitingTextInputFormatter(148),
              ],
              controller: aboutCtrl,
              //  keyboardType: TextInputType.emailAddress,

              maxLines: 3,
              // any number you need (It works as the rows for the textarea)
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: (currentTheme.customTheme)
                          ? Colors.white54
                          : Colors.black54,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelStyle: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                  // icon: Icon(Icons.perm_identity),
                  //  fillColor: currentTheme.accentColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: currentTheme.currentTheme.accentColor,
                        width: 2.0),
                  ),
                  hintText: '',
                  labelText: 'Sobre mi *',
                  //counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: bloc.changeAbout),
        );
      },
    );
  }

  Widget _createPassword(ProfileBloc bloc, TextEditingController passCtrl) {
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
            controller: passCtrl,
            obscureText: true,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _editProfile(ProfileBloc bloc, BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final profile = authService.profile;

    final username =
        (bloc.username == null) ? profile.user.username : bloc.username.trim();

    final name = (bloc.name == null) ? profile.name : bloc.name.trim();

    final email = (bloc.email == null) ? profile.user.email : bloc.email.trim();

    final password = (bloc.password == null) ? '' : bloc.password.trim();

    final about = (bloc.about == null) ? '' : bloc.about.trim();

    final editProfileOk = await authService.editProfile(
        profile.user.uid, username, about, name, email, password);

    if (editProfileOk != null) {
      if (editProfileOk == true) {
        Navigator.pop(context);
      } else {
        mostrarAlerta(context, 'Error', editProfileOk);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }
}

Route createRoute() {
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
