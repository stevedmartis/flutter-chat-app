import 'dart:async';

import 'package:chat/bloc/profile_bloc.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/pages/profile_page2.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/room_services.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/card_product.dart';
import 'package:chat/widgets/carousel_tabs.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../utils//extension.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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

class _MyProfileState extends State<MyProfile> with TickerProviderStateMixin {
  ScrollController _scrollController;

  String name = '';
  bool fromRooms = false;
  bool activeTabs = false;

  Future<List<Room>> getRoomsFuture;
  AuthService authService;

  final roomService = new RoomService();
  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  bool isLike = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
    name = widget.profile.name;

    // profileBloc.imageUpdate.add(true);
    roomBloc.getRooms(widget.profile.user.uid);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    //  _heartAnimationController?.dispose();
    //roomBloc.disposeRooms();
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 130;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    //final username = widget.profile.user.username.toLowerCase();

    return Scaffold(
      // bottomNavigationBar: BottomNavigation(isVisible: _isVisible),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          _snapAppbar();
          if (_scrollController.offset >= 250) {}
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  stretch: true,
                  stretchTriggerOffset: 250.0,

                  backgroundColor: _showTitle
                      ? Colors.black
                      : currentTheme.scaffoldBackgroundColor,
                  leading: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: CircleAvatar(
                            child: IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                    size: size.width / 20,
                                    color: (_showTitle)
                                        ? currentTheme.accentColor
                                        : Colors.white),
                                onPressed: () => {
                                      {
                                        Provider.of<MenuModel>(context,
                                                listen: false)
                                            .currentPage = 0,
                                      },
                                      Navigator.pop(context),
                                    }),
                            backgroundColor: Colors.black.withOpacity(0.60)),
                      )),

                  actions: [
                    Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(right: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: CircleAvatar(
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      size: size.width / 15,
                                      color: (_showTitle)
                                          ? currentTheme.accentColor
                                          : Colors.white),
                                  onPressed: () => createSelectionNvigator(),
                                ),
                              ),
                              backgroundColor: Colors.black.withOpacity(0.60)),
                        )),
                  ],

                  centerTitle: false,
                  pinned: true,
                  /* title: Center(
                    child: Container(
                        //  margin: EdgeInsets.only(left: 0),
                        width: size.height / 3,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (!_showTitle)
                              ? Colors.black.withOpacity(0.60)
                              : currentTheme.scaffoldBackgroundColor
                                  .withOpacity(0.90),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          boxShadow: [],
                        ),
                        child: SearchContent()),
                  ),
 */
                  expandedHeight: maxHeight,
                  shadowColor: currentTheme.scaffoldBackgroundColor,

                  // collapsedHeight: 56.0001,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.zoomBackground,
                      StretchMode.fadeTitle,
                      // StretchMode.blurBackground
                    ],
                    background: ProfilePage(
                      isEmpty: false,
                      loading: false,
                      //image: snapshot.data,
                      isUserAuth: widget.isUserAuth,
                      isUserEdit: widget.isUserEdit,
                      profile: widget.profile,
                    ),
                    centerTitle: false,
                  ),
                ),
                (!this.widget.isUserEdit)
                    ? makeHeaderInfo(context)
                    : makeHeaderSpacer(context),
                if (!widget.isUserEdit) makeHeaderTabs(context),
                /* SliverList(
                  delegate: SliverChildListDelegate(
                      List<Widget>.generate(10, (int i) {
                    return Stack(
                      children: [
                        CardProduct(index: i),
                        GestureDetector(
                            onTap: () {}, child: _buildCircleFavoriteProduct()),
                      ],
                    );
                  })),
                ), */
              ]),
        ),
      ),
    );
  }

  createSelectionNvigator() {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;
    final size = MediaQuery.of(context).size;
    //final bloc = CustomProvider.roomBlocIn(context);

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: currentTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: 20, left: size.width / 3.0, right: size.width / 3.0),
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Color(0xffEBECF0).withOpacity(0.30),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Create",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                //_createName(bloc),
                SizedBox(
                  height: 30,
                ),
                //_createDescription(bloc),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 70.0,
        maxHeight: 70.0,
        child: StreamBuilder<RoomsResponse>(
          stream: roomBloc.subject.stream,
          builder: (context, AsyncSnapshot<RoomsResponse> snapshot) {
            if (snapshot.hasData) {
              return _buildUserWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ),
    );
  }

  SliverPersistentHeader makeProductsCard(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
        minHeight: 70.0,
        maxHeight: 70.0,
        child: StreamBuilder<RoomsResponse>(
          stream: roomBloc.subject.stream,
          builder: (context, AsyncSnapshot<RoomsResponse> snapshot) {
            if (snapshot.hasData) {
              return _buildWidgetProduct(snapshot.data.rooms);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),
      ),
    );
  }

  SliverPersistentHeader makeHeaderSpacer(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
          minHeight: 10,
          maxHeight: 10,
          child: Row(
            children: [Container()],
          )),
    );
  }

  SliverPersistentHeader makeHeaderDefaultTabs(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
          minHeight: 70,
          maxHeight: 70,
          child: Row(
            children: [Container()],
          )),
    );
  }

  SliverPersistentHeader makeHeaderInfo(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final username = widget.profile.user.username.toLowerCase();
    final about = widget.profile.about;
    final size = MediaQuery.of(context).size;

    final nameFinal = name.isEmpty ? "" : name.capitalize();

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
          minHeight: (about.length > 10) ? 100.0 : 80.0,
          maxHeight: (about.length > 80) ? 180.0 : 80.0,
          child: Container(
            padding: EdgeInsets.only(top: 10.0),
            color: currentTheme.scaffoldBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!this.widget.isUserEdit)
                  Expanded(
                    flex: -2,
                    child: Container(
                      width: size.width - 15.0,
                      padding:
                          EdgeInsets.only(left: size.width / 20.0, top: 5.0),
                      //margin: EdgeInsets.only(left: size.width / 6, top: 10),
                      child: (nameFinal == "")
                          ? Text(
                              username,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: (name.length >= 15) ? 20 : 22,
                                  color: Colors.white),
                            )
                          : Text(
                              (nameFinal.length >= 45)
                                  ? nameFinal.substring(0, 45)
                                  : nameFinal,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: (nameFinal.length >= 15) ? 20 : 22,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                if (!this.widget.isUserEdit)
                  Expanded(
                    flex: -2,
                    child: Container(
                        width: size.width - 1.10,
                        padding: EdgeInsets.only(
                            left: size.width / 20.0, top: 5.0, bottom: 10),
                        //margin: EdgeInsets.only(left: size.width / 6, top: 10),

                        child: Text(
                          '@' + username,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: (username.length >= 16) ? 16 : 18,
                              color: Colors.white.withOpacity(0.60)),
                        )),
                  ),
                Expanded(
                  child: Container(
                      width: size.width - 50,
                      padding:
                          EdgeInsets.only(left: size.width / 20.0, right: 10),
                      //margin: EdgeInsets.only(left: size.width / 6, top: 10),

                      child: (about.length > 0)
                          ? convertHashtag(
                              about,
                              currentTheme.accentColor,
                            )
                          : Container()),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildUserWidget(RoomsResponse data) {
    return Container(
      child: Stack(fit: StackFit.expand, children: [
        TabsScrollCustom(
          rooms: data.rooms,
          isAuthUser: widget.isUserAuth,
        ),
        /*  AnimatedOpacity(
            opacity: !_showTitle ? 1.0 : 0.0,
            duration: Duration(milliseconds: 250),
            child: _buildEditCircle()) */
      ]),
    );
  }

  Widget _buildWidgetProduct(data) {
    return Container(
      child: SizedBox(
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return InfoPage(index: index);
            }),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
        height: 400.0, child: Center(child: CircularProgressIndicator()));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget itemCake() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            "Dark Belgium chocolate",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: Colors.white),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Cold",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Fresh",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "\$30.25",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black54),
                  ),
                  Text(
                    "per Quantity",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        color: Colors.black),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
            ],
          ),
        ],
      ),
    );
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

RichText convertHashtag(String text, Color color) {
  List<String> split = text.split(RegExp("#"));

  List<String> hashtags = split.getRange(1, split.length).fold([], (t, e) {
    var texts = e.split(" ");

    if (texts.length > 1) {
      return List.from(t)
        ..addAll(["#${texts.first}", "${e.substring(texts.first.length)}"]);
    }
    return List.from(t)..add("#${texts.first}");
  });

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
            text: split.first,
            style:
                TextStyle(color: Colors.white.withOpacity(0.60), fontSize: 16))
      ]..addAll(hashtags
          .map((text) => text.contains("#")
              ? TextSpan(
                  text: text, style: TextStyle(color: color, fontSize: 16))
              : TextSpan(
                  text: text,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.60), fontSize: 16)))
          .toList()),
    ),
  );
}

Route createRoutePrincipalPage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PrincipalPage(),
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
    transitionDuration: Duration(seconds: 1),
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
    transitionDuration: Duration(milliseconds: 400),
  );
}

Route createRouteRooms() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => RoomsListPage(),
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
    transitionDuration: Duration(milliseconds: 400),
  );
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height / 1.40);

    var firstControlPoint = Offset(size.width / 3, size.height);
    var firstEndPoint = Offset(size.width / 1.30, size.height - 60.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 60);
    var secondEndPoint = Offset(size.width / 1.30, size.height - 60);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 90);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
