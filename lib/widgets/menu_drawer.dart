import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrincipalMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final accentColor = appTheme.currentTheme.accentColor;

    final size = MediaQuery.of(context).size;

    final socketService = Provider.of<SocketService>(context);
    final authService = Provider.of<AuthService>(context);
    final currentTheme = Provider.of<ThemeChanger>(context);
    final profile = authService.profile;

    return SafeArea(
      child: Container(
        width: size.width / 1.5,
        child: Drawer(
          child: Container(
            color: currentTheme.currentTheme.scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    profile.user.username,
                    style: TextStyle(
                      fontSize: 20,
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
/*               Expanded(
                    child: _OptionsList(),
                  ), */
                /*  ListTile(
                  leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
                  title: Text(
                    'Dark mode',
                    style: TextStyle(
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  trailing: Switch.adaptive(
                    value: appTheme.customTheme,
                    onChanged: (value) {
                      appTheme.customTheme = value;
                    },
                  ),
                ), */
                /*  SafeArea(
                  bottom: true,
                  top: false,
                  left: false,
                  right: false,
                  child: ListTile(
                    leading: Icon(Icons.add_to_home_screen, color: accentColor),
                    title: Text('Custom theme'),
                    trailing: Switch.adaptive(
                      value: appTheme.customTheme,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        appTheme.customTheme = value;
                      },
                    ),
                  ),
                ), */
                GestureDetector(
                  onTap: () {
                    socketService.disconnect();

                    Navigator.pushNamedAndRemoveUntil(
                        context, "login", (Route<dynamic> route) => false);
                    AuthService.deleteToken();
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: accentColor),
                    title: Text(
                      'Sign off',
                      style: TextStyle(
                        color: (currentTheme.customTheme)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
