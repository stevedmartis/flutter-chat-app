import 'package:chat/pages/my_profile.dart';
import 'package:chat/pages/onBoarding_page.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/pages/tabs.dart';
import 'package:chat/pages/user_page.dart';
import 'package:flutter/material.dart';

import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'loading': (_) => LoadingPage(),
  'onboard': (_) => OnBoardingScreen(),
  'register': (_) => RegisterPage(),
  'login': (_) => LoginPage(),
  'principal': (_) => PrincipalPage(),
  'profile': (_) => SliverAppBarProfilepPage(),
  'profile_auth': (_) => UserPage(),
  'profile_edit': (_) => MyProfilePage(),
  'rooms': (_) => RoomsListPage(),
  'chat': (_) => ChatPage(),
  'tabs': (_) => TabsCustom(),
};

final pageRouter = <_Route>[
  _Route(FontAwesomeIcons.home, 'principal', PrincipalPage()),
  _Route(FontAwesomeIcons.home, 'rooms', RoomsListPage()),
  _Route(FontAwesomeIcons.user, 'profile', SliverAppBarProfilepPage()),
  _Route(FontAwesomeIcons.user, 'profile_auth', UserPage()),
  _Route(FontAwesomeIcons.truckLoading, 'loading', LoadingPage()),
  _Route(FontAwesomeIcons.democrat, 'onboard', OnBoardingScreen()),
  _Route(FontAwesomeIcons.sign, 'register', RegisterPage()),
  _Route(FontAwesomeIcons.signInAlt, 'login', LoginPage()),
  _Route(FontAwesomeIcons.signInAlt, 'profile_edit', MyProfilePage()),
  _Route(FontAwesomeIcons.signInAlt, 'chat', ChatPage()),
  _Route(FontAwesomeIcons.signInAlt, 'tabs', TabsCustom()),
];

class _Route {
  final IconData icon;
  final String title;
  final Widget page;

  _Route(this.icon, this.title, this.page);
}
