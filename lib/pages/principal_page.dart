import 'package:animations/animations.dart';
import 'package:chat/helpers/ui_overlay_style.dart';

import 'package:chat/routes/routes.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/menu_drawer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  ScrollController _hideBottomNavController;

  var _isVisible;

  @override
  initState() {
    super.initState();

    this.bottomControll();
  }

  @override
  void dispose() {
    super.dispose();
    _hideBottomNavController.dispose();
  }

  bottomControll() {
    _isVisible = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(
      () {
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
            });
        }
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
            });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = Provider.of<MenuModel>(context).currentPage;

    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final _onFirstPage = (currentPage == 0) ? true : false;

    print(currentPage);
    changeStatusLight();
    return SafeArea(
        child: Scaffold(
      endDrawer: PrincipalMenu(),
      body: PageTransitionSwitcher(
        duration: Duration(milliseconds: 500),
        reverse: !_onFirstPage,
        transitionBuilder: (Widget child, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SharedAxisTransition(
            fillColor: currentTheme.scaffoldBackgroundColor,
            transitionType: SharedAxisTransitionType.horizontal,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pageRouter[currentPage].page,
      ),

      //CollapsingList(_hideBottomNavController),
      bottomNavigationBar: BottomNavigation(isVisible: _isVisible),
    ));
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    Key key,
    @required isVisible,
  })  : _isVisible = isVisible,
        super(key: key);

  final bool _isVisible;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;

      Provider.of<MenuModel>(context, listen: false).currentPage = currentIndex;

      /*  if (currentIndex != currentPage) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    pageRouter[currentIndex].page));
      } */
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final currentPage = Provider.of<MenuModel>(context).currentPage;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: widget._isVisible ? 60.0 : 0.0,
      child: Wrap(
        children: <Widget>[
          BottomNavigationBar(
            currentIndex: currentPage,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            unselectedItemColor: Colors.white.withOpacity(0.60),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    size: (currentPage == 0) ? 30 : 25,
                    color: (currentPage == 0)
                        ? currentTheme.accentColor
                        : Colors.white.withOpacity(0.60)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.users,
                    size: (currentPage == 1) ? 30 : 25,
                    color: (currentPage == 1)
                        ? currentTheme.accentColor
                        : Colors.white.withOpacity(0.60)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.meeting_room,
                    size: (currentPage == 2) ? 30 : 25,
                    color: (currentPage == 2)
                        ? currentTheme.accentColor
                        : Colors.white.withOpacity(0.60)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.handHoldingMedical,
                    size: (currentPage == 3) ? 30 : 25,
                    color: (currentPage == 3)
                        ? currentTheme.accentColor
                        : Colors.white.withOpacity(0.60)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.bell,
                    size: (currentPage == 4) ? 30 : 25,
                    color: (currentPage == 4)
                        ? currentTheme.accentColor
                        : Colors.white.withOpacity(0.60)),
                label: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuModel with ChangeNotifier {
  int _currentPage = 0;
  int _lastPage = 0;

  int get currentPage => this._currentPage;

  set currentPage(int value) {
    this._currentPage = value;
    notifyListeners();
  }

  int get lastPage => this._lastPage;

  set lastPage(int value) {
    this._lastPage = value;
    notifyListeners();
  }
}
