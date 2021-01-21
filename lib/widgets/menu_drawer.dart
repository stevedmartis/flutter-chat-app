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

    final socketService = Provider.of<SocketService>(context);
    final authService = Provider.of<AuthService>(context);
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final profile = authService.profile;

    return Drawer(
      child: Container(
        color: currentTheme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                profile.user.username,
                style: TextStyle(fontSize: 20),
              ),
            ),
/*               Expanded(
                child: _OptionsList(),
              ), */
            /*  ListTile(
              leading: FaIcon(FontAwesomeIcons.moon, color: accentColor),
              title: Text('Dark mode'),
              trailing: Switch.adaptive(
                value: appTheme.darkTheme,
                onChanged: (value) {
                  appTheme.darkTheme = value;
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
                Navigator.pushReplacementNamed(context, 'login');
                AuthService.deleteToken();
              },
              child: ListTile(
                leading: Icon(Icons.exit_to_app, color: accentColor),
                title: Text('Sign off'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
