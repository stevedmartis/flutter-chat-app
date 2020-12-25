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
