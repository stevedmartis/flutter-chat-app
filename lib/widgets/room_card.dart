import 'package:chat/theme/theme.dart';

/// This is the stateless widget that the main application instantiates.
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomListItemTwoRoom extends StatelessWidget {
  CustomListItemTwoRoom({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.wide,
    this.long,
    this.tall,
    this.publishDate,
    this.readDuration,
    this.timeOn,
    this.timeOff,
    this.totalPlants,
    this.totalAirs,
    this.totalLigths,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String wide;
  final String long;
  final String tall;

  final String publishDate;
  final String readDuration;
  final String timeOn;
  final String timeOff;
  final int totalPlants;
  final int totalAirs;

  final int totalLigths;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: size.height / 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: _ArticleDescription(
                    title: title,
                    subtitle: subtitle,
                    wide: wide,
                    long: long,
                    tall: tall,
                    timeOn: timeOn,
                    timeOff: timeOff,
                    publishDate: publishDate,
                    readDuration: readDuration,
                    totalPlants: totalPlants,
                    totalAirs: totalAirs,
                    totalLights: totalLigths,
                  ),
                ),
              ),
              SizedBox(
                  width: size.height / 10,
                  child: Center(
                      child: Container(
                    child: Icon(
                      Icons.format_list_bulleted,
                      color: currentTheme.accentColor,
                      size: size.height / 25,
                    ),
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription(
      {Key key,
      this.title,
      this.subtitle,
      this.wide,
      this.long,
      this.tall,
      this.pideublishDate,
      this.publishDate,
      this.readDuration,
      this.timeOn,
      this.timeOff,
      this.totalPlants,
      this.totalAirs,
      this.totalLights})
      : super(key: key);

  final String title;
  final String subtitle;
  final String wide;
  final String long;
  final String tall;
  final String pideublishDate;
  final String publishDate;

  final String timeOn;
  final String timeOff;

  final String readDuration;
  final int totalPlants;

  final int totalAirs;

  final int totalLights;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height / 40,
                  color: currentTheme.currentTheme.accentColor),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '$subtitle',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height / 50,
                color: (currentTheme.customTheme) ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.local_florist,
                  size: size.height / 40,
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '$totalPlants',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height / 40,
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FaIcon(
                  FontAwesomeIcons.wind,
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                  size: size.height / 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '$totalAirs',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height / 40,
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FaIcon(
                  FontAwesomeIcons.lightbulb,
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                  size: size.height / 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '$totalLights',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height / 40,
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RowMeassureRoom(ismin: true, wide: wide, long: long, tall: tall),
            SizedBox(
              height: 10,
            ),
            RowTimeOnOffRoom(timeOn: timeOn, timeOff: timeOff),
          ],
        ),
      ],
    );
  }
}

class RowTimeOnOffRoom extends StatelessWidget {
  const RowTimeOnOffRoom(
      {Key key,
      @required this.timeOn,
      @required this.timeOff,
      this.center = false,
      this.size = 15.0})
      : super(key: key);

  final String timeOn;
  final String timeOff;
  final double size;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment:
          (center) ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.wb_incandescent,
            color:
                (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        SizedBox(
          width: 5.0,
        ),

        Text(
          ' $timeOn',
          style: TextStyle(
              fontSize: size.height / 40,
              color: (currentTheme.customTheme) ? Colors.white : Colors.black),
        ),
        SizedBox(
          width: 40.0,
        ),
        // FaIcon(FontAwesomeIcons.rulerHorizontal),
        Icon(Icons.bedtime,
            color:
                (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        SizedBox(
          width: 5.0,
        ),
        Text(
          ' $timeOff',
          style: TextStyle(
              fontSize: size.height / 40,
              color: (currentTheme.customTheme) ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}

class RowMeassureRoom extends StatelessWidget {
  const RowMeassureRoom({
    Key key,
    @required this.wide,
    @required this.long,
    @required this.tall,
    this.center = false,
    this.ismin = false,
    this.fontSize = 15.0,
  }) : super(key: key);

  final String wide;
  final String long;
  final String tall;
  final double fontSize;
  final bool center;
  final bool ismin;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment:
          (center) ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FaIcon(FontAwesomeIcons.rulerHorizontal,
            color:
                (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        SizedBox(
          width: 10,
        ),
        Text(
          ' $wide',
          style: TextStyle(
              fontSize: size.height / 40,
              color: (currentTheme.customTheme) ? Colors.white : Colors.black),
        ),

        Text(
          (ismin) ? ' An' : ' Ancho',
          style: TextStyle(
              fontSize: size.height / 40,
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
        SizedBox(
          width: 5.0,
        ),
        // FaIcon(FontAwesomeIcons.rulerHorizontal),
        Text(
          ' $long',
          style: TextStyle(
              fontSize: size.height / 40,
              color: (currentTheme.customTheme) ? Colors.white : Colors.black),
        ),
        Text(
          (ismin) ? ' La' : ' Largo',
          style: TextStyle(
              fontSize: size.height / 40,
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
        SizedBox(
          width: 5.0,
        ),
        // FaIcon(FontAwesomeIcons.rulerHorizontal),
        Text(
          ' $tall',
          style: TextStyle(
              fontSize: size.height / 40,
              color: (currentTheme.customTheme) ? Colors.white : Colors.black),
        ),
        Text(
          (ismin) ? ' Al' : ' Alto',
          style: TextStyle(
              fontSize: size.height / 40,
              color:
                  (currentTheme.customTheme) ? Colors.white54 : Colors.black54),
        ),
      ],
    );
  }
}
