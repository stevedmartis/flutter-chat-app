import 'package:chat/pages/profile_model.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LifeTime extends StatelessWidget {
  LifeTime({@required this.born, @required this.died});

  final String born;
  final String died;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Info(title: 'Born', subtitle: born),
        Info(title: 'Died', subtitle: died),
      ],
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    @required this.title,
    @required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(title,
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: Colors.grey.shade600)),
        Text(subtitle, style: Theme.of(context).textTheme.title),
      ],
    );
  }
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LifeTime(
          born: profileData.born,
          died: profileData.died,
        ),
        Divider(
          height: 40,
          thickness: 1,
        ),
/*         Align(
            alignment: Alignment.centerLeft,
            child: Text('About', style: Theme.of(context).textTheme.title)), */
        /*  SizedBox(height: 8),
        Text(
          profileData.about,
          style: Theme.of(context).textTheme.subhead,
        ), */
      ],
    );
  }
}
