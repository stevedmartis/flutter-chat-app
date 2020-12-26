import 'dart:async';

import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/pages/avatar_image.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/my_profile.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/room_services.dart';
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
  bool fromRooms = false;
  // List<Room> rooms = [];
  Future<List<Room>> getRoomsFuture;
  AuthService authService;

  final roomService = new RoomService();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => MediaQuery.of(context).padding.bottom;

  Future<ui.Image> _image(String url) async =>
      await NetworkImageDecoder(image: NetworkImage(url)).uiImage;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));
    name = widget.profile.name;
    roomBloc.getRooms(widget.profile.user.uid);
    // this._chargeRoomsUser();
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 100;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    //final username = widget.profile.user.username.toLowerCase();

    return Scaffold(
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
                                onPressed: () => {
                                      Navigator.pop(context),
                                    }),
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
                      initialData: null,
                      future: _image(widget.profile.getHeaderImg()),
                      builder: (BuildContext context,
                              AsyncSnapshot<ui.Image> snapshot) =>
                          !snapshot.hasData
                              ? HeaderMultiCurvesImage(
                                  isEmpty: true,
                                  color: Colors.white,
                                  image: snapshot.data,
                                )
                              : HeaderMultiCurvesImage(
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
                          Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 200),
                                  pageBuilder: (_, __, ___) =>
                                      AvatarImagePage(this.widget.profile))),

                        // make changes here

                        //Navigator.of(context).push(createRouteAvatarProfile(this.user));
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: (_showTitle) ? 50 : 70,
                        height: (_showTitle) ? 50 : 70,
                        margin: EdgeInsets.only(
                            left: (_showTitle)
                                ? size.width / 7.0
                                : size.width / 12.0),
                        child: Hero(
                          tag: widget.profile.user.uid,
                          child: Material(
                            type: MaterialType.transparency,
                            child: ImageUserChat(
                              width: 100,
                              // showBorderAvatar: _showBorderAvatar,
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
                (!this.widget.isUserEdit)
                    ? makeHeaderInfo(context)
                    : makeHeaderSpacer(context),
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

  SliverPersistentHeader makeHeaderSpacer(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
          minHeight: 10,
          maxHeight: 10,
          child: Row(
            children: [Container()],
          )),
    );
  }

  SliverPersistentHeader makeHeaderInfo(context) {
    //   final roomModel = Provider.of<Room>(context);
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final username = widget.profile.user.username.toLowerCase();
    //final size = MediaQuery.of(context).size;

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
          minHeight: 60.0,
          maxHeight: 150.0,
          child: Container(
            padding: EdgeInsets.only(top: 5.0),
            color: currentTheme.scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!this.widget.isUserEdit)
                  Container(
                    padding: EdgeInsets.only(left: 40, top: 5.0),
                    //margin: EdgeInsets.only(left: size.width / 6, top: 10),
                    child: (name.isEmpty)
                        ? Text(
                            (name.length >= 12)
                                ? username.substring(0, 12) + '...'
                                : username,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: (name.length >= 15) ? 24 : 26,
                                color: Colors.white),
                          )
                        : Text(
                            (name.length >= 12)
                                ? name.substring(0, 12) + '...'
                                : name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: (name.length >= 15) ? 24 : 26,
                                color: Colors.white),
                          ),
                  ),
                Spacer(),
                if (!this.widget.isUserEdit)
                  Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: CircleAvatar(
                            child: (IconButton(
                              icon: Center(
                                child: Icon(
                                    (!widget.isUserAuth)
                                        ? Icons.share
                                        : Icons.settings,
                                    color: currentTheme.accentColor,
                                    size: 25),
                              ),
                              onPressed: () {
                                if (!widget.isUserAuth)
                                  return true;
                                else
                                  Navigator.of(context)
                                      .push(createRouteMyProfile());

                                //globalKey.currentState.openEndDrawer();
                              },
                            )),
                            backgroundColor: Colors.black.withOpacity(0.70)),
                      )),
                if (!this.widget.isUserEdit)
                  Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: CircleAvatar(
                            child: (IconButton(
                              icon: Icon(
                                (!widget.isUserAuth)
                                    ? Icons.favorite
                                    : Icons.edit,
                                color: currentTheme.accentColor,
                                size: 25,
                              ),
                              onPressed: () {
                                if (!widget.isUserAuth)
                                  return true;
                                else
                                  Navigator.of(context)
                                      .push(createRouteMyProfile());

                                //globalKey.currentState.openEndDrawer();
                              },
                            )),
                            backgroundColor: Colors.black.withOpacity(0.70)),
                      )),
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
        _buildEditCircle()
      ]),
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

  Container _buildEditCircle() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    //  final roomModel = Provider.of<Room>(context, listen: false);

    final size = MediaQuery.of(context).size;

    return (widget.isUserAuth)
        ? Container(
            margin: EdgeInsets.only(left: size.width / 1.3),
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
                          //roomModel.isRoute = true;
                          //globalKey.currentState.openEndDrawer();
                          //Navigator.of(context).push(createRouteRooms());
                          //Navigator.popAndPushNamed(context, 'rooms');

                          Navigator.of(context).pushNamed('rooms');
                      })),
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

/* 
        FutureBuilder(
          future: getRoomsFuture,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              final rooms = snapshot.data;

              //roomModel.rooms = rooms;

              //setState(() {});

              return Container(
                child: Stack(fit: StackFit.expand, children: [
                  TabsScrollCustom(
                    rooms: rooms,
                    isAuthUser: widget.isUserAuth,
                  ),
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
        ), */
