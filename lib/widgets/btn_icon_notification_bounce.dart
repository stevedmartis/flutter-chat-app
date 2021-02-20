import 'package:chat/models/notification.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ButtomFloating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);

    return FloatingActionButton(
      backgroundColor: appTheme.currentTheme.accentColor,
      onPressed: () {
        final notifiModel =
            Provider.of<NotificationModel>(context, listen: false);
        int number = notifiModel.number;
        number++;
        notifiModel.number = number;

        if (number >= 2) {
          final controller = notifiModel.bounceController;
          controller.forward(from: 0.0);
        }
      },
      child: FaIcon(
        FontAwesomeIcons.plus,
        color: (appTheme.darkTheme)
            ? Colors.black
            : appTheme.currentTheme.primaryColorLight,
      ),
    );
  }
}
