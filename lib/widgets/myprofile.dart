import 'dart:async';

import 'package:chat/models/profiles.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/pages/avatar_image.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/my_profile.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/users_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/carousel_tabs.dart';
import 'package:chat/widgets/headercurves_logo_text.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class MyProfile extends StatefulWidget {
  MyProfile({
    Key key,
    this.title,
    this.isUserAuth = false,
    this.isUserEdit = false,
    @required this.profile,
  }) : super(key: key);

  final String title;

  final bool isUserAuth;

  final bool isUserEdit;
  final Profiles profile;

  @override
  _MyProfileState createState() => new _MyProfileState();
}

class NetworkImageDecoder {
  final NetworkImage image;
  const NetworkImageDecoder({this.image});

  Future<ImageInfo> get imageInfo async {
    final Completer<ImageInfo> completer = Completer();
    image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(info),
          ),
        );
    return await completer.future;
  }

  Future<ui.Image> get uiImage async {
    final ImageInfo _info = await imageInfo;
    return _info.image;
  }
}

class _MyProfileState extends State<MyProfile> {
  ScrollController _scrollController;

  String name = '';
  List<User> users = [];
  AuthService authService;
  final usuarioService = new UsuariosService();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => MediaQuery.of(context).padding.bottom;

  Future<ui.Image> _image(String url) async =>
      await NetworkImageDecoder(image: NetworkImage(url)).uiImage;

  @override
  void initState() {
    this._chargeUsers();
    this.authService = Provider.of<AuthService>(context, listen: false);
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  _chargeUsers() async {
    this.users = await usuarioService.getUsers();
    // await authService.getProfileByUserId(widget.profile.user.uid);

    name = widget.profile.name;

    if (mounted) {
      setState(() {});
    }
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 200;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final username = widget.profile.user.username.toLowerCase();

    return Scaffold(
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          _snapAppbar();
          if (_scrollController.offset >= 250) {}
          return false;
        },
        child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: _showTitle
                    ? Colors.black
                    : currentTheme.scaffoldBackgroundColor,
                leading: Container(
                    width: size.width / 2,
                    height: size.height / 2,
                    margin: EdgeInsets.only(left: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: CircleAvatar(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios,
                                size: size.width / 20,
                                color: currentTheme.accentColor),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          backgroundColor: Colors.black.withOpacity(0.70)),
                    )),
                actions: [
                  Container(
                      width: size.width / 11,
                      height: size.height / 2,
                      margin: EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: CircleAvatar(
                            child: IconButton(
                              icon: FaIcon(FontAwesomeIcons.slidersH,
                                  size: size.width / 22,
                                  color: currentTheme.accentColor),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            backgroundColor: Colors.black.withOpacity(0.70)),
                      )),
                ],

                centerTitle: false,
                pinned: true,
                // title : (between leading and actions) ,
                expandedHeight: maxHeight,
                // collapsedHeight: 56.0001,
                flexibleSpace: FlexibleSpaceBar(
                  background: FutureBuilder<ui.Image>(
                    future: _image(widget.profile.getHeaderImg()),
                    builder: (BuildContext context,
                            AsyncSnapshot<ui.Image> snapshot) =>
                        !snapshot.hasData
                            ? HeaderMultiCurvesImage(
                                isUserEdit: widget.isUserEdit,
                                isUserAuth: widget.isUserAuth,
                                isEmpty: true,
                                name: name,
                                username: username,
                                color: Colors.white,
                                image: snapshot.data,
                              )
                            : HeaderMultiCurvesImage(
                                isUserEdit: widget.isUserEdit,
                                isUserAuth: widget.isUserAuth,
                                name: name,
                                username: username,
                                color: Colors.white,
                                image: snapshot.data,
                              ),
                  ),
                  titlePadding: EdgeInsets.all(0),
                  title: GestureDetector(
                    onTap: () => {
                      if (!widget.isUserAuth)
                        Navigator.of(context).push(createRouteChat())
                      else
                        Navigator.of(context).push(createRouteMyProfile()),

                      if (widget.isUserEdit)
                        Navigator.of(context).pushReplacement(PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 200),
                            pageBuilder: (_, __, ___) =>
                                AvatarImagePage(this.widget.profile))),

                      // make changes here

                      //Navigator.of(context).push(createRouteAvatarProfile(this.user));
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: (_showTitle) ? 50 : 70,
                      height: (_showTitle) ? 50 : 70,
                      margin: EdgeInsets.only(left: size.width / 7.0),
                      child: Hero(
                        tag: widget.profile.user.uid,
                        child: Material(
                          type: MaterialType.transparency,
                          child: ImageUserChat(
                            width: 100,
                            height: 100,
                            profile: widget.profile,
                            fontsize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  centerTitle: false,
                ),
              ),
              if (!widget.isUserEdit)
                makeHeaderTabs(context)
              else
                SliverFillRemaining(
                    hasScrollBody: false,
                    child: FormEditUserprofile(widget.profile.user)),
              if (!widget.isUserEdit)
                SliverFixedExtentList(
                  itemExtent: 150.0,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildCard(index);
                    },
                  ),
                ),
              /* SliverList(
                delegate:
                    SliverChildListDelegate(List<Text>.generate(100, (int i) {
                  return Text("List item $i");
                })),
              ), */
            ]),
      ),
    );
  }

  Card _buildCard(int index) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Text("Item $index"),
      ),
    );
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 70.0,
        maxHeight: 70.0,
        child: FutureBuilder(
          future: this.usuarioService.getUsers(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Stack(fit: StackFit.expand, children: [
                  TabsScrollCustom(users: users),
                  _buildEditCircle()
                ]),
              );
              // image is ready
            } else {
              return Container(
                  height: 400.0,
                  child: Center(
                      child: CircularProgressIndicator())); // placeholder
            }
          },
        ),
      ),
    );
  }

  Container _buildEditCircle() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return (widget.isUserAuth)
        ? Container(
            margin: EdgeInsets.only(left: 350),
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: CircleAvatar(
                  child: (IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: currentTheme.accentColor,
                      size: 35,
                    ),
                    onPressed: () {
                      if (!widget.isUserAuth)
                        return true;
                      else
                        Navigator.of(context).push(_createRouteRoomsPage());

                      //globalKey.currentState.openEndDrawer();
                    },
                  )),
                  backgroundColor: Colors.black.withOpacity(0.30)),
            ))
        : Container();
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_scrollController.offset > 0 &&
        _scrollController.offset < scrollDistance) {
      final double snapOffset =
          _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _scrollController.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }
}

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}

Route _createRouteRoomsPage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => RoomsListPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route createRouteMyProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.fastLinearToSlowEaseIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route createRouteChat() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ChatPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
