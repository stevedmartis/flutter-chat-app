import 'dart:typed_data';

import 'package:chat/models/usuario.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/users_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/carousel_tabs.dart';
import 'package:chat/widgets/header_custom_search.dart';
import 'package:chat/widgets/headercurves_logo_text.dart';
import 'package:chat/widgets/sliver_header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:async';

class SliverAppBarSnap extends StatefulWidget {
  SliverAppBarSnap({@required this.user, this.isUserAuth = false});

  final User user;

  final bool isUserAuth;

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

  @override
  void initState() {
    this._chargeUsers();
    this.authService = Provider.of<AuthService>(context, listen: false);

    super.initState();
  }

  _chargeUsers() async {
    this.users = await usuarioService.getUsers();

    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => 65 + MediaQuery.of(context).padding.top;

  bool isEmpty = false;

  AuthService authService;

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

  SliverPersistentHeader makeHeaderTabs(context) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
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
                  child: TabsScrollCustom(users: users)); // image is ready
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
        var begin = Offset(0.0, 1.0);
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

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    var backgroundColor = Colors.white; // this color could be anything
    var foregroundColor =
        backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: currentTheme.accentColor,
        onPressed: () {
          Navigator.of(context).push(_createRouteRoomsPage());

          setState(() {
            isEmpty = !isEmpty;
          });
        },
      ),
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
                margin: EdgeInsets.only(left: 20),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: foregroundColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              actions: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.slidersH,
                        color: foregroundColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
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
                    future: _image(_url),
                    builder: (BuildContext context,
                            AsyncSnapshot<ui.Image> snapshot) =>
                        !snapshot.hasData
                            ? Container(
                                height: 400.0,
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : HeaderMultiCurvesImage(
                                color: Colors.white,
                                image: snapshot.data,
                              ),
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
/*                 if (!isUserAuth)
                  Navigator.of(context).push(_createRouteChat());
                else
                  Navigator.of(context).push(_createRouteMyProfile()); */
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          margin: EdgeInsets.only(left: 50, top: 170),
                          child: Hero(
                            tag: widget.user.uid,
                            child: ImageUserChat(
                              width: 100,
                              height: 100,
                              user: widget.user,
                              fontsize: 13,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(30),
                        margin: EdgeInsets.only(left: 100, top: 100),
                        width: 200,
                        height: 150,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              (widget.user.username.length >= 14)
                                  ? widget.user.username.substring(0, 14) +
                                      '...'
                                  : widget.user.username,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: TextStyle(
                                  fontSize: 20, color: foregroundColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(left: 170, top: 210),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            child: CircleAvatar(
                                minRadius: 20,
                                child: FittedBox(
                                  child: Icon(
                                    Icons.share,
                                    size: 15,
                                    color: currentTheme.accentColor,
                                  ),
                                ),
                                backgroundColor: Colors.black),
                          )),
                      Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(left: 210, top: 210),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            child: CircleAvatar(
                                minRadius: 10,
                                child: FittedBox(
                                  child: Icon(
                                    Icons.favorite,
                                    size: 15,
                                    color: currentTheme.accentColor,
                                  ),
                                ),
                                backgroundColor: Colors.black),
                          )),
                    ],
                  ),
                ]),
              ),
              expandedHeight: maxHeight,
              collapsedHeight: minHeight,
            ),
            makeHeaderTabs(context),
            if (!isEmpty)
              SliverFixedExtentList(
                itemExtent: 150.0,
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildCard(index);
                  },
                ),
              )
            else
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
