import 'dart:typed_data';

import 'package:chat/models/profile.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/pages/avatar_image.dart';
import 'package:chat/pages/my_profile.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/users_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/carousel_tabs.dart';
import 'package:chat/widgets/headercurves_logo_text.dart';
import 'package:chat/widgets/sliver_header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:async';

class SliverAppBarSnap extends StatefulWidget {
  SliverAppBarSnap({
    @required this.profile,
    this.isUserAuth = false,
    this.isUserEdit = false,
  });

  final Profiles profile;

  final bool isUserAuth;
  final bool isUserEdit;

  @override
  _SliverAppBarSnapState createState() => _SliverAppBarSnapState();
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

class _SliverAppBarSnapState extends State<SliverAppBarSnap> {
  final usuarioService = new UsuariosService();

  List<User> users = [];

  String name = '';

  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => 65 + MediaQuery.of(context).padding.top;

  bool isEmpty = false;

  AuthService authService;

  @override
  void initState() {
    this._chargeUsers();
    this.authService = Provider.of<AuthService>(context, listen: false);

    super.initState();
  }

  _chargeUsers() async {
    this.users = await usuarioService.getUsers();
    // await authService.getProfileByUserId(widget.profile.user.uid);

    name = widget.profile.name;

    if (mounted) {
      setState(() {});
    }

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _controller.dispose();
    super.dispose();
  }

  static const String _url =
      //  'https://thumbs.dreamstime.com/z/mega-sale-discount-vector-layout-concept-illustration-abstract-horizontal-advertising-promotion-banner-special-offer-126871873.jpg';
      //  'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940';
      // 'https://media.istockphoto.com/vectors/watch-shop-web-header-or-banner-design-vector-id475264080?k=6&m=475264080&s=170667a&w=0&h=2TRrVcUyWH9PaPsN8AzAp__XYfyijEGgFmw1Ex9kS0I=';
      //   'https://cdn4.vectorstock.com/i/1000x1000/26/38/workout-fashion-concept-banner-header-vector-26762638.jpg';
      // 'https://previews.123rf.com/images/bestforbest/bestforbest2001/bestforbest200100047/138514486-wishlist-isometric-vector-banner-smartphone-with-a-heart-and-a-list-with-checkmarks-of-favorite-wish.jpg';
      // 'https://cdn.vtldesign.com/wp-content/uploads/2018/01/blello_banner.png';
      //   'https://fiverr-res.cloudinary.com/images/t_main1,q_auto,f_auto,q_auto,f_auto/gigs/106604167/original/082d49d73c586363607ae1c9626afd3bb71d4045/do-design-the-product-ad.jpg';
      // 'https://miro.medium.com/max/1200/0*He_QWZmayGk_JHdm';
      'https://image.shutterstock.com/z/stock-photo-fruit-header-image-330188381.jpg';
  Future<ui.Image> _image(String url) async =>
      await NetworkImageDecoder(image: NetworkImage(url)).uiImage;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    var backgroundColor = Colors.white; // this color could be anything
    var foregroundColor =
        backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final size = MediaQuery.of(context).size;

    final username = widget.profile.user.username.toLowerCase();
    print(widget.profile);
    return Scaffold(
      key: widget.key,
      floatingActionButton: (!widget.isUserEdit)
          ? FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: currentTheme.accentColor,
              onPressed: () {
                Navigator.of(context).push(_createRouteRoomsPage());

                setState(() {
                  isEmpty = !isEmpty;
                });
              },
            )
          : Container(),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          _snapAppbar();
          print('${_controller.offset}');
          if (_controller.offset > 180) {}
          return false;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          controller: _controller,
          slivers: [
            SliverAppBar(
              leading: Container(
                  width: size.width / 2,
                  height: size.height / 2,
                  margin: EdgeInsets.only(left: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: CircleAvatar(
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              size: size.width / 22,
                              color: currentTheme.accentColor),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        backgroundColor: Colors.black.withOpacity(0.70)),
                  )),
              backgroundColor: currentTheme.scaffoldBackgroundColor,
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
              /*  title: Center(
                child: Container(
                    margin: EdgeInsets.only(left: 30),
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentTheme.scaffoldBackgroundColor
                          .withOpacity(0.80),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            spreadRadius: -5,
                            blurRadius: 10,
                            offset: Offset(0, 5))
                      ],
                    ),
                    child: SearchContent()),
              ), */
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                title: Stack(children: [
                  FutureBuilder<ui.Image>(
                    future: _image(widget.profile.getHeaderImg()),
                    builder: (BuildContext context,
                            AsyncSnapshot<ui.Image> snapshot) =>
                        !snapshot.hasData
                            ? HeaderMultiCurves(
                                color: currentTheme.scaffoldBackgroundColor,
                              )
                            : HeaderMultiCurvesImage(
                                color: Colors.white,
                                image: snapshot.data,
                              ),
                  ),
                  HeaderUserInfo(
                    profile: widget.profile,
                    isUserAuth: widget.isUserAuth,
                    isUserEdit: widget.isUserEdit,
                    name: name,
                    currentTheme: currentTheme,
                    username: username,
                  ),
                ]),
              ),
              expandedHeight: maxHeight,
              collapsedHeight: minHeight,
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
            if (isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "List is empty",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 70.0,
        maxHeight: 70.0,
        child: FutureBuilder(
          future: this.usuarioService.getUsers(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Stack(fit: StackFit.expand, children: [
                TabsScrollCustom(users: users),
                _buildEditCircle()
              ]);
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

  Route _createRouteRoomsPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => RoomsListPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
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

  Container _buildEditCircle() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return (widget.isUserAuth)
        ? Container(
            margin: EdgeInsets.only(left: 300),
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
                  backgroundColor: Colors.black.withOpacity(0.70)),
            ))
        : Container();
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }
}

class HeaderUserInfo extends StatefulWidget {
  const HeaderUserInfo(
      {Key key,
      @required this.name,
      @required this.currentTheme,
      @required this.username,
      @required this.isUserAuth,
      @required this.profile,
      @required this.isUserEdit})
      : super(key: key);

  final String name;
  final ThemeData currentTheme;
  final String username;
  final bool isUserAuth;
  final Profiles profile;
  final bool isUserEdit;

  @override
  _HeaderUserInfoState createState() => _HeaderUserInfoState();
}

class _HeaderUserInfoState extends State<HeaderUserInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.profile}');

    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        GestureDetector(
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
          child: Container(
            width: 70,
            height: 70,
            margin: EdgeInsets.only(left: 50, top: 200),
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
        if (!widget.isUserEdit)
          Container(
            margin:
                EdgeInsets.only(left: size.width / 3.5, top: size.height / 4.3),
            width: size.width / 2,
            height: size.height / 2,
            child: Center(
              child: Container(
                child: Text(
                  (widget.name.length >= 20)
                      ? widget.name.substring(0, 20) + '...'
                      : widget.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: (widget.name.length >= 14) ? 14 : 16,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        if (!widget.isUserEdit)
          Container(
            margin:
                EdgeInsets.only(left: size.width / 3.0, top: size.height / 3.6),
            width: size.width / 2,
            height: size.height / 2,
            child: Center(
              child: Container(
                child: Text(
                  (widget.username.length >= 20)
                      ? '@' + widget.username.substring(0, 20) + '...'
                      : '@' + widget.username,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                      fontSize: 12, color: Colors.white.withOpacity(0.60)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        if (!widget.isUserEdit)
          Container(
              width: size.width / 12,
              height: size.height / 12,
              margin: EdgeInsets.only(
                  left: size.width / 2.5, top: size.height / 5.6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: CircleAvatar(
                    child: (IconButton(
                      icon: Center(
                        child: Icon(
                          (!widget.isUserAuth) ? Icons.share : Icons.settings,
                          color: widget.currentTheme.accentColor,
                          size: 17,
                        ),
                      ),
                      onPressed: () {
                        if (!widget.isUserAuth)
                          return true;
                        else
                          Navigator.of(context).push(createRouteMyProfile());

                        //globalKey.currentState.openEndDrawer();
                      },
                    )),
                    backgroundColor: Colors.black.withOpacity(0.70)),
              )),
        if (!widget.isUserEdit)
          Container(
              width: size.width / 12,
              height: size.height / 12,
              margin:
                  EdgeInsets.only(left: size.width / 2, top: size.height / 5.6),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: CircleAvatar(
                    child: (IconButton(
                      icon: Icon(
                        (!widget.isUserAuth) ? Icons.favorite : Icons.edit,
                        color: widget.currentTheme.accentColor,
                        size: 17,
                      ),
                      onPressed: () {
                        if (!widget.isUserAuth)
                          return true;
                        else
                          Navigator.of(context).push(createRouteMyProfile());

                        //globalKey.currentState.openEndDrawer();
                      },
                    )),
                    backgroundColor: Colors.black.withOpacity(0.70)),
              )),
      ],
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final List<ui.Image> images;
  const MyCustomPainter({
    this.images,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (ui.Image image in images)
      canvas.drawImage(
        image,
        Offset(0.0, 0.0),
        Paint(),
      );
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) => false;
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class ImageMask extends StatefulWidget {
  final ImageProvider image;
  final double width;
  final double height;
  final Widget child;

  const ImageMask(
      {@required this.image, this.width, this.height, @required this.child});

  @override
  _ImageMaskState createState() => _ImageMaskState();
}

class _ImageMaskState extends State<ImageMask> {
  Future<Shader> _shader;

  @override
  void initState() {
    super.initState();
    _shader = _loadShader(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _shader,
      builder: (_, AsyncSnapshot<Shader> snapshot) {
        return snapshot.connectionState != ConnectionState.done ||
                snapshot.hasError
            ? SizedBox(width: widget.width, height: widget.height)
            : ShaderMask(
                blendMode: BlendMode.dstATop,
                shaderCallback: (bounds) => snapshot.data,
                child: widget.child,
              );
      },
    );
  }

  Future<Shader> _loadShader(BuildContext context) async {
    final completer = Completer<ImageInfo>();

    // use the ResizeImage provider to resolve the image in the required size
    ResizeImage(widget.image,
            width: widget.width.toInt(), height: widget.height.toInt())
        .resolve(ImageConfiguration(size: Size(widget.width, widget.height)))
        .addListener(
            ImageStreamListener((info, _) => completer.complete(info)));

    final info = await completer.future;
    return ImageShader(
      info.image,
      TileMode.clamp,
      TileMode.clamp,
      Float64List.fromList(Matrix4.identity().storage),
    );
  }
}

PageRoute<Object> _createTutorialDetailRoute(Widget child) {
  return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 200),
      transitionsBuilder: (context, anim, secondaryAnim, child) =>
          FadeTransition(opacity: anim, child: child),
      pageBuilder: (context, anim, secondaryAnim) => child);
}
