import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/pages/users_list_page.dart';
import 'package:chat/providers/users_provider.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/card_swipe.dart';
import 'package:chat/widgets/header_custom_search.dart';
import 'package:chat/widgets/pageview_horizontal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/chat_service.dart';
import 'package:chat/services/users_service.dart';
import 'package:chat/services/socket_service.dart';
import 'dart:math' as math;
import 'package:chat/models/usuario.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final usuarioService = new UsuariosService();

  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    //final socketService = Provider.of<SocketService>(context);

    //final user = authService.user;

    changeStatusLight();

    return SafeArea(
        child: Scaffold(
            // appBar: AppBarBase(user: user, socketService: socketService),
            body: CollapsingList()));
  }
}

class CarouselSliderCustom extends StatelessWidget {
  const CarouselSliderCustom({
    Key key,
    @required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return CarouselSlider.builder(
      options: CarouselOptions(
        height: 100,
        viewportFraction: 0.30,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
      ),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.userFor = users[index];
          Navigator.pushNamed(context, 'chat');
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  (users[index].image.isEmpty)
                      ? Container(
                          width: 120,
                          height: 120,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: CircleAvatar(
                              minRadius: 120,
                              child: Text(users[index]
                                  .name
                                  .substring(0, 2)
                                  .toUpperCase()),
                              backgroundColor: currentTheme.accentColor,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: FadeInImage(
                              image: NetworkImage(users[index].getPosterImg()),
                              placeholder: AssetImage('assets/tag-logo.png'),
                              fit: BoxFit.cover),
                        ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: (users[index].online)
                                ? LinearGradient(
                                    colors: [
                                      Colors.green[300],
                                      Color.fromARGB(0, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.30),
                                      Color.fromARGB(0, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  )),
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Container(
                                width: 13.0,
                                height: 13.0,
                                decoration: new BoxDecoration(
                                  color: users[index].online
                                      ? Colors.green[300]
                                      : Colors.white.withOpacity(0.10),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 90),
                                child: Text(
                                  users[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class _SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverCustomHeaderDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverCustomHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CollapsingList extends StatefulWidget {
  @override
  _CollapsingListState createState() => _CollapsingListState();
}

class _CollapsingListState extends State<CollapsingList>
    with SingleTickerProviderStateMixin {
  final usuarioService = new UsuariosService();

  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'LEFT'),
    new Tab(text: 'RIGHT'),
  ];

  TabController _tabController;

  List<User> users = [];

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: myTabs.length);
    this._chargeUsers();
    super.initState();
  }

  _chargeUsers() async {
    this.users = await usuarioService.getUsers();
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  SliverPersistentHeader makeHeaderCustom() {
    return SliverPersistentHeader(
        floating: true,
        delegate: _SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: Container(child: CustomAppBarHeader()))));
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 60.0,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                  indicatorColor: currentTheme.accentColor,
                  tabs: [
                    Tab(icon: Icon(Icons.my_location)),
                    Tab(icon: Icon(Icons.favorite)),
                  ],
                  onTap: (value) => {
                        _tabController
                            .animateTo((_tabController.index + 1) % 2),
                        setState(() {
                          _tabController.index = value;
                        })
                      }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return CustomScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        makeHeaderCustom(),

        CupertinoSliverRefreshControl(onRefresh: () => _chargeUsers()),

        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [BannerSlide()],
          ),
        ),

        SliverFixedExtentList(
          itemExtent: 100.0,
          delegate: SliverChildListDelegate(
            [
              FutureBuilder(
                future: this.usuarioService.getUsers(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSliderCustom(users: users); // image is ready
                  } else {
                    return Container(
                        height: 400.0,
                        child: Center(
                            child: CircularProgressIndicator())); // placeholder
                  }
                },
              ),
            ],
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 10.0,
          delegate: SliverChildListDelegate(
            [
              Container(color: currentTheme.scaffoldBackgroundColor),
            ],
          ),
        ),

        SliverGrid.count(
          crossAxisCount: 4,
          children: [
            _BtnOption(title: 'Market', image: 'assets/banners/cart_image.jpg'),
            _BtnOption(title: 'Market', image: 'assets/banners/cart_image.jpg'),
            _BtnOption(title: 'Market', image: 'assets/banners/cart_image.jpg'),
            _BtnOption(title: 'Market', image: 'assets/banners/cart_image.jpg'),
            _BtnOption(title: 'Market', image: 'assets/banners/cart_image.jpg'),
            _BtnOption(title: 'Market', image: 'assets/banners/cart_image.jpg'),
            _BtnOption(title: 'Market', image: 'assets/banners/cart_image.jpg'),
            _BtnOption(title: 'Market', image: 'assets/banners/cart_image.jpg'),
          ],
        ),

        SliverFixedExtentList(
          itemExtent: 10.0,
          delegate: SliverChildListDelegate(
            [
              Container(color: currentTheme.scaffoldBackgroundColor),
            ],
          ),
        ),

        makeHeaderTabs(context),

        (_tabController.index == 0)
            ? SliverGrid.count(
                crossAxisCount: 3,
                children: [
                  Container(color: Colors.red, height: 150.0),
                  Container(color: Colors.purple, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                  Container(color: Colors.orange, height: 150.0),
                  Container(color: Colors.yellow, height: 150.0),
                  Container(color: Colors.pink, height: 150.0),
                  Container(color: Colors.cyan, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.orange, height: 150.0),
                  Container(color: Colors.yellow, height: 150.0),
                  Container(color: Colors.pink, height: 150.0),
                  Container(color: Colors.cyan, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.orange, height: 150.0),
                  Container(color: Colors.yellow, height: 150.0),
                  Container(color: Colors.pink, height: 150.0),
                  Container(color: Colors.cyan, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                  Container(color: Colors.amber, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.yellow, height: 150.0),
                  Container(color: Colors.pink, height: 150.0),
                  Container(color: Colors.cyan, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                ],
              )
            : Container(
                child: SliverGrid.count(
                crossAxisCount: 3,
                children: [
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.red, height: 150.0),
                  Container(color: Colors.purple, height: 150.0),
                  Container(color: Colors.orange, height: 150.0),
                  Container(color: Colors.pink, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.cyan, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.amber, height: 150.0),
                  Container(color: Colors.yellow, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.orange, height: 150.0),
                  Container(color: Colors.yellow, height: 150.0),
                  Container(color: Colors.pink, height: 150.0),
                  Container(color: Colors.cyan, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.green, height: 150.0),
                  Container(color: Colors.amber, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                  Container(color: Colors.yellow, height: 150.0),
                  Container(color: Colors.pink, height: 150.0),
                  Container(color: Colors.cyan, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                ],
              )),

        // Yes, this could also be a SliverFixedExtentList. Writing
        // this way just for an example of SliverList construction.
      ],
    );
  }
}

class _BtnOption extends StatelessWidget {
  final String title;
  final String image;
  const _BtnOption({Key key, @required this.title, @required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Stack(
            children: <Widget>[
              Image.asset(
                image,
                height: 1000.0,
                width: 1000.0,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          spreadRadius: -5,
                          blurRadius: 10,
                          offset: Offset(0, 10))
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Text(
                    this.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class _BtnShadow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final text;
  final double left;

  const _BtnShadow(
      {this.icon = Icons.ac_unit, @required this.text, this.color, this.left});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Icon(this.icon, size: 30, color: Colors.white),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: this.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    spreadRadius: -5,
                    blurRadius: 20,
                    offset: Offset(0, 10))
              ]),
        ),
        Container(
            margin: EdgeInsets.only(top: 75, left: this.left),
            child: Text(this.text))
      ],
    );
  }
}

class BannerSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
        child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: (screenSize.height > 500) ? 2.2 : 2.6,
              enlargeCenterPage: true,
              autoPlayInterval: Duration(seconds: 5),
            ),
            items: imageSliders));
  }
}

final List<String> imgList = [
  'assets/banners/banner1.jpg',
  'assets/banners/banner2.jpg',
  'assets/banners/banner3.jpg',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      item,
                      height: 1000.0,
                      width: 1000.0,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
