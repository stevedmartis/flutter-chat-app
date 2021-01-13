import 'dart:ui';

import 'package:chat/models/profiles.dart';
import 'package:chat/models/profiles_response.dart';
import 'package:chat/pages/profile_edit.dart';
import 'package:chat/providers/users_provider.dart';
import 'package:chat/services/chat_service.dart';
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
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.black,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  String get searchFieldLabel => 'Search for store or product';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(
          selection,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
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
                      width: 100, height: 100, profile: profile, fontsize: 20),
                  title: Text(profile.name),
                  subtitle: Text(profile.user.username),
                  onTap: () {
                    close(context, null);
                    //profile.user.uid = '';
                    //Navigator.pushNamed(context, 'detail', arguments: profile);

                    if (profile.user.uid != this.userAuth.user.uid) {
                      final chatService =
                          Provider.of<ChatService>(context, listen: false);
                      chatService.userFor = profile;
                      Navigator.push(context, createRouteProfile(profile));
                      ;
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
