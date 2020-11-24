import 'package:chat/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class GridLayoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _MenuModel(),
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          GridLayout(),
        ],
      )),
    );
  }
}

/* 
class _PositionedMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double widthView = MediaQuery.of(context).size.width;

    final show = Provider.of<_MenuModel>(context).show;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

  if ( widthView > 500 ){
    widthView = widthView - 300;
  }

    return Positioned(
        bottom: 0,
        child: Container(
          height: 100,
          width: widthView,
          child: Row(children: [
            Spacer(),
            
            FadeIn(
              animate: show,
                child: GridLayoutMenu(
                show: show, 
                backgroundColor: appTheme.scaffoldBackgroundColor,
                activeColor: appTheme.accentColor,
              // inactiveColor: Colors.green,
              items: [
                GLMenuButton(icon: Icons.star, onPressed: () {}),
                GLMenuButton(icon: Icons.search, onPressed: () {}),
                GLMenuButton(icon: Icons.notifications, onPressed: () {}),
                GLMenuButton(icon: Icons.supervised_user_circle, onPressed: () {}),
          ]

          ),
            ),
          Spacer(),

          ],),
        ));
  }
}
 */
class GridLayout extends StatefulWidget {
  @override
  _GridLayoutState createState() => _GridLayoutState();
}

class _GridLayoutState extends State<GridLayout> {
  final List<int> items = List.generate(200, (i) => i);
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    double prevScroll = 0;

    controller.addListener(() {
      if (controller.offset > prevScroll && controller.offset > 150) {
        Provider.of<_MenuModel>(context, listen: false).show = false;
      } else {
        Provider.of<_MenuModel>(context, listen: false).show = true;
      }
      prevScroll = controller.offset;
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int count;

    if (MediaQuery.of(context).size.width > 500) {
      count = 3;
    } else {
      count = 2;
    }
    return StaggeredGridView.countBuilder(
      controller: controller,
      crossAxisCount: count,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) => _GridLayoutItem(index),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(1, index.isEven ? 1 : 2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class _GridLayoutItem extends StatelessWidget {
  final int index;

  _GridLayoutItem(this.index);

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: new Center(
          child: new CircleAvatar(
            backgroundColor: Colors.white,
            child: new Text('$index'),
          ),
        ));
  }
}

class _MenuModel with ChangeNotifier {
  bool _show = true;

  bool get show => this._show;

  set show(bool value) {
    this._show = value;
    notifyListeners();
  }
}
