import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/models/notification.dart';
import 'package:chat/models/shoes.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/services/air_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/catalogo_service.dart';
import 'package:chat/services/light_service.dart';
import 'package:chat/services/plant_services.dart';
import 'package:chat/services/product_services.dart';
import 'package:chat/services/room_services.dart';
import 'package:chat/services/subscription_service.dart';
import 'package:chat/services/visit_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/routes/routes.dart';

import 'bloc/provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => SocketService()),
      ChangeNotifierProvider(create: (_) => RoomService()),
      ChangeNotifierProvider(create: (_) => ChatService()),
      ChangeNotifierProvider(create: (_) => ThemeChanger(3)),
      ChangeNotifierProvider(create: (_) => ShoesModel()),
      ChangeNotifierProvider(create: (_) => MenuModel()),
      ChangeNotifierProvider(create: (_) => AwsService()),
      ChangeNotifierProvider(create: (_) => PlantService()),
      ChangeNotifierProvider(create: (_) => AirService()),
      ChangeNotifierProvider(create: (_) => LightService()),
      ChangeNotifierProvider(create: (_) => VisitService()),
      ChangeNotifierProvider(create: (_) => SubscriptionService()),
      ChangeNotifierProvider(create: (_) => NotificationModel()),
      ChangeNotifierProvider(create: (_) => CatalogoService()),
      ChangeNotifierProvider(create: (_) => ProductService()),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final currentTheme = Provider.of<ThemeChanger>(context);

    (currentTheme.customTheme) ? changeStatusLight() : changeStatusDark();

    return CustomProvider(
      child: MaterialApp(
        theme: currentTheme.currentTheme,
        debugShowCheckedModeBanner: false,
        title: 'Leafety',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
