import 'package:chat/pages/onBoarding_page.dart';
import 'package:chat/pages/tabs.dart';
import 'package:chat/pages/user_page.dart';
import 'package:flutter/material.dart';

import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/pages/principal_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'onboard': (_) => OnBoardingScreen(),
  'usuarios': (_) => UsersPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
  'profile_user': (_) => UserPage(),
  'tabs': (_) => TabsCustom(),
};
