import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/models/notification.dart';
import 'package:chat/models/profiles.dart';

import 'package:chat/routes/routes.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/notification_service.dart';
import 'package:chat/services/socket_service.dart';

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
  SocketService socketService;
  final notificationService = new NotificationService();
  AuthService authService;

  Profiles profile;

  @override
  initState() {
    this.socketService = Provider.of<SocketService>(context, listen: false);

    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    getNotificationsActive();

    this.socketService.socket?.on('principal-message', _listenMessage);

    super.initState();
  }

  void getNotificationsActive() async {
    var notifications =
        await notificationService.getNotificationByUser(profile.user.uid);

    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int number = notifiModel.numberNotifiBell;
    number = notifications.subscriptionsNotifi.length;
    notifiModel.numberNotifiBell = number;

    if (number >= 2) {
      final controller = notifiModel.bounceControllerBell;
      controller.forward(from: 0.0);
    }

    int numberMessages = notifiModel.number;
    numberMessages = notifications.messagesNotifi.length;
    notifiModel.number = numberMessages;

    if (numberMessages >= 2) {
      final controller2 = notifiModel.bounceController;
      controller2.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    // this.socketService.socket.off('principal-message');
    super.dispose();
  }

  void _listenMessage(dynamic payload) {
    final notifiModel = Provider.of<NotificationModel>(context, listen: false);
    int number = notifiModel.number;
    number++;
    notifiModel.number = number;

    if (number >= 2) {
      final controller = notifiModel.bounceController;
      controller.forward(from: 0.0);
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentPage = Provider.of<MenuModel>(context).currentPage;

    final currentTheme = Provider.of<ThemeChanger>(context);
    final appTheme = Provider.of<ThemeChanger>(context);
    final authService = Provider.of<AuthService>(context);

    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    appTheme.customTheme = darkModeOn;

    final _onFirstPage = (currentPage == 0) ? true : false;

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
            fillColor: currentTheme.currentTheme.scaffoldBackgroundColor,
            transitionType: SharedAxisTransitionType.horizontal,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pageRouter[currentPage].page,
      ),

      //CollapsingList(_hideBottomNavController),
      bottomNavigationBar:
          BottomNavigation(isVisible: authService.bottomVisible),
      // floatingActionButton: ButtomFloating(),
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

      if (currentIndex == 4) {
        Provider.of<NotificationModel>(context, listen: false)
            .numberNotifiBell = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final currentPage = Provider.of<MenuModel>(context).currentPage;
    final int number = Provider.of<NotificationModel>(context).numberNotifiBell;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: widget._isVisible ? 60.0 : 0.0,
      child: Wrap(
        children: <Widget>[
          BottomNavigationBar(
            currentIndex: currentPage,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: (currentTheme.customTheme)
                ? currentTheme.currentTheme.cardColor
                : Colors.white,
            selectedItemColor: currentTheme.currentTheme.accentColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: (currentPage == 0)
                    ? Icon(Icons.home, size: 30)
                    : Icon(Icons.home_outlined,
                        size: 30,
                        color: (currentPage == 0)
                            ? currentTheme.currentTheme.accentColor
                            : currentTheme.currentTheme.primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group,
                    size: (currentPage == 1) ? 30 : 30,
                    color: (currentPage == 1)
                        ? currentTheme.currentTheme.accentColor
                        : currentTheme.currentTheme.primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: (currentPage == 2)
                    ? FaIcon(
                        FontAwesomeIcons.doorOpen,
                        size: 25,
                      )
                    : FaIcon(FontAwesomeIcons.doorClosed,
                        size: 25,
                        color: (currentPage == 2)
                            ? currentTheme.currentTheme.accentColor
                            : currentTheme.currentTheme.primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.handHoldingMedical,
                    size: (currentPage == 3) ? 25 : 25,
                    color: (currentPage == 3)
                        ? currentTheme.currentTheme.accentColor
                        : currentTheme.currentTheme.primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: (number > 0) ? 0 : 24, top: 10),
                        child: FaIcon(
                          (currentPage == 4)
                              ? FontAwesomeIcons.solidBell
                              : FontAwesomeIcons.bell,
                          color: (currentPage == 4)
                              ? currentTheme.currentTheme.accentColor
                              : currentTheme.currentTheme.primaryColor,
                          size: (currentPage == 4) ? 30 : 30,
                        ),
                      ),
                      (number > 0)
                          ? Positioned(
                              top: 0.0,
                              right: 10.0,
                              bottom: 15.0,
                              child: BounceInDown(
                                from: 5,
                                animate: (number > 0) ? true : false,
                                child: Bounce(
                                  delay: Duration(seconds: 2),
                                  from: 5,
                                  controller: (controller) =>
                                      Provider.of<NotificationModel>(context)
                                          .bounceControllerBell = controller,
                                  child: Container(
                                    child: Text(
                                      '$number',
                                      style: TextStyle(
                                          color: (currentTheme.customTheme)
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    alignment: Alignment.center,
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        color: (currentTheme.customTheme)
                                            ? currentTheme
                                                .currentTheme.accentColor
                                            : Colors.black,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  label: ''),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomNavBarV2 extends StatefulWidget {
  @override
  _BottomNavBarV2State createState() => _BottomNavBarV2State();
}

class _BottomNavBarV2State extends State<BottomNavBarV2> {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.shopping_basket),
                        elevation: 0.1,
                        onPressed: () {}),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 0
                                ? Colors.orange
                                : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.restaurant_menu,
                              color: currentIndex == 1
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(1);
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.bookmark,
                              color: currentIndex == 2
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(2);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: currentIndex == 3
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setBottomBarIndex(3);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
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
