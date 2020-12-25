import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/models/shoes.dart';
import 'package:chat/services/room_services.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/routes/routes.dart';

import 'bloc/provider.dart';
import 'models/room.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => SocketService()),
      ChangeNotifierProvider(create: (_) => RoomService()),
      ChangeNotifierProvider(create: (_) => Room()),
      ChangeNotifierProvider(create: (_) => ChatService()),
      ChangeNotifierProvider(create: (_) => ThemeChanger(3)),
      ChangeNotifierProvider(create: (_) => ShoesModel()),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    changeStatusLight();
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return CustomProvider(
      child: MaterialApp(
        theme: currentTheme,
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
