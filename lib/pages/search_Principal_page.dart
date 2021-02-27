import 'dart:ui';

import 'package:chat/models/profiles.dart';
import 'package:chat/models/profiles_response.dart';
import 'package:chat/pages/profile_edit.dart';
import 'package:chat/providers/users_provider.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataSearch extends SearchDelegate {
  String selection = '';
  final usersProvider = new UsersProvider();
  final Profiles userAuth;

  DataSearch({this.userAuth});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final ThemeData theme =
        (currentTheme.customTheme) ? ThemeData.dark() : ThemeData.light();
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              color: (currentTheme.customTheme)
                  ? Colors.white54
                  : Colors.black54)),
      primaryColor: (currentTheme.customTheme) ? Colors.black : Colors.white,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
    );
  }

  @override
  String get searchFieldLabel => 'Buscar club o tratamiento';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.grey),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        color: Colors.grey,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Text(
              selection,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    if (query.isEmpty && query.length < 3) {
      return Scaffold(
          backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
          body: Container());
    }

    return Scaffold(
      backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
      body: FutureBuilder(
        future: usersProvider.getSearchPrincipalByQuery(query),
        builder:
            (BuildContext context, AsyncSnapshot<ProfilesResponse> snapshot) {
          if (snapshot.hasData) {
            final profiles = snapshot.data.profiles;

            return ListView(
              children: profiles.map((profile) {
                return Hero(
                  tag: profile.user.uid,
                  child: ListTile(
                    leading: ImageUserChat(
                        width: 100,
                        height: 100,
                        profile: profile,
                        fontsize: 20),
                    title: Text(
                      profile.name,
                      style: TextStyle(
                          color: (currentTheme.customTheme)
                              ? Colors.white
                              : Colors.black),
                    ),
                    subtitle: Text(
                      '@' + profile.user.username,
                      style: TextStyle(
                          color: (currentTheme.customTheme)
                              ? Colors.white54
                              : Colors.black54),
                    ),
                    onTap: () {
                      close(context, null);
                      //profile.user.uid = '';
                      //Navigator.pushNamed(context, 'detail', arguments: profile);

                      if (profile.user.uid != this.userAuth.user.uid) {
                        final chatService =
                            Provider.of<ChatService>(context, listen: false);
                        chatService.userFor = profile;
                        Navigator.push(context, createRouteProfile(profile));
                      } else {
                        Navigator.push(context, createRoute());
                      }
                    },
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Route createRouteProfile(Profiles profile) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MyProfile(profile: profile),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  }
}
