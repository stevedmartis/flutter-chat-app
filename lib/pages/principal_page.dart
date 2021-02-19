import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat/bloc/plant_bloc.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/bloc/visit_bloc.dart';
import 'package:chat/helpers/ui_overlay_style.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plants_response.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/models/visits_response.dart';
import 'package:chat/pages/plant_detail.dart';
import 'package:chat/pages/room_detail.dart';
import 'package:chat/routes/routes.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/plant_services.dart';
import 'package:chat/services/visit_service.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/card_product.dart';
import 'package:chat/widgets/carousel_users.dart';
import 'package:chat/widgets/header_custom_search.dart';
import 'package:chat/widgets/menu_drawer.dart';
import 'package:chat/widgets/plant_card_widget.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:chat/widgets/visit_card.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/users_service.dart';

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
    changeStatusLight();
    return SafeArea(
        child: Scaffold(
      endDrawer: PrincipalMenu(),
      body: CollapsingList(_hideBottomNavController),
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
    final currentPage =
        Provider.of<MenuModel>(context, listen: false).currentPage;

    // Provider.of<MenuModel>(context, listen: false).lastPage = currentPage;

    setState(() {
      currentIndex = index;

      Provider.of<MenuModel>(context, listen: false).currentPage = currentIndex;

      if (currentIndex != currentPage) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    pageRouter[currentIndex].page));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final currentPage = Provider.of<MenuModel>(context).currentPage;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: widget._isVisible ? 56.0 : 0.0,
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
                    size: (currentPage == 0) ? 35 : 30,
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
                    size: (currentPage == 2) ? 35 : 30,
                    color: (currentPage == 2)
                        ? currentTheme.accentColor
                        : Colors.white.withOpacity(0.60)),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.handHoldingMedical,
                    size: (currentPage == 3) ? 25 : 22,
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

class CollapsingList extends StatefulWidget {
  final ScrollController _hideBottomNavController;

  CollapsingList(this._hideBottomNavController);

  @override
  _CollapsingListState createState() => _CollapsingListState();
}

class _CollapsingListState extends State<CollapsingList>
    with SingleTickerProviderStateMixin {
  final usuarioService = new UsuariosService();

  final visitService = new VisitService();

  final plantService = new PlantService();

  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'LEFT'),
    new Tab(text: 'RIGHT'),
  ];

  TabController _tabController;

  List<Profiles> profiles = [];

  List<Visit> visits = [];

  List<Plant> plants = [];

  Profiles profile;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: myTabs.length);

    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    this._chargeProfileUsers();

    this._chargeLastPlantsByUser();

    this._chargeLastVisitByUser();

    super.initState();
  }

  _chargeProfileUsers() async {
    this.profiles = await usuarioService.getProfilesLastUsers();

    setState(() {});
  }

  _chargeLastPlantsByUser() async {
    // this.plants = await plantService.getLastPlantsByUser(profile.user.uid);
    plantBloc.getPlantsByUser(profile.user.uid);
    setState(() {});
  }

  _chargeLastVisitByUser() async {
    // this.visits = await visitService.getLastVisitsByUser(profile.user.uid);

    visitBloc.getVisitsByUser(profile.user.uid);

    setState(() {});
  }

  pullToRefreshData() async {
    this._chargeProfileUsers();

    this._chargeLastPlantsByUser();

    this._chargeLastVisitByUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // room = snapshot.data;

        CustomScrollView(
      controller: widget._hideBottomNavController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        makeHeaderCustom(),
        CupertinoSliverRefreshControl(onRefresh: () => pullToRefreshData()),
        makeHeaderSpacer(context),
        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [BannerSlide()],
          ),
        ),
        makeHeaderSpacer(context),
        SliverFixedExtentList(
          itemExtent: 100.0,
          delegate: SliverChildListDelegate(
            [
              FutureBuilder(
                future: this.usuarioService.getProfilesLastUsers(),
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasData) {
                    profiles = snapshot.data;
                    return Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: CarouselUsersSliderCustom(
                            profiles: snapshot.data)); // image is ready
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
        makeHeaderSpacer(context),
        SliverFixedExtentList(
          itemExtent: 200.0,
          delegate: SliverChildListDelegate(
            [
              StreamBuilder<PlantsResponse>(
                stream: plantBloc.plantsUser.stream,
                builder: (context, AsyncSnapshot<PlantsResponse> snapshot) {
                  if (snapshot.hasData) {
                    plants = snapshot.data.plants;
                    return _buildWidgetPlants(
                        plants, context); // image is ready
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
        // makeHeaderSpacer(context),
        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [
              StreamBuilder<VisitsResponse>(
                stream: visitBloc.visitsUser.stream,
                builder: (context, AsyncSnapshot<VisitsResponse> snapshot) {
                  if (snapshot.hasData) {
                    visits = snapshot.data.visits;
                    return _buildWidgetVisits(
                        visits, context); // image is ready
                  } else {
                    return Container(
                        height: 400.0,
                        child: Center(
                            child: CircularProgressIndicator())); // placeholder
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  SliverPersistentHeader makeHeaderSpacer(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
          minHeight: 20,
          maxHeight: 20,
          child: Row(
            children: [Container()],
          )),
    );
  }

  SliverPersistentHeader makeHeaderCustom() {
    return SliverPersistentHeader(
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                color: Colors.black,
                child: Container(
                    color: Colors.black, child: CustomAppBarHeader()))));
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              bottom: TabBar(
                  indicatorWeight: 3.0,
                  indicatorColor: currentTheme.accentColor,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.my_location,
                            color: (_tabController.index == 0)
                                ? currentTheme.accentColor
                                : Colors.white)),
                    Tab(
                        icon: Icon(Icons.favorite,
                            color: (_tabController.index == 1)
                                ? currentTheme.accentColor
                                : Colors.white)),
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
}

SliverPersistentHeader makeProductsCard(context) {
  //   final roomModel = Provider.of<Room>(context);

  return SliverPersistentHeader(
    pinned: false,
    delegate: SliverAppBarDelegate(
      minHeight: 70.0,
      maxHeight: 70.0,
      child: StreamBuilder<RoomsResponse>(
        stream: roomBloc.myRooms.stream,
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

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverCustomHeaderDelegate(
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
  bool shouldRebuild(covariant SliverCustomHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
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

class LastVisitsByUser extends StatelessWidget {
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

Widget _buildWidgetPlants(List<Plant> plants, context) {
  final plantService = Provider.of<PlantService>(context, listen: false);

  return (plants.length > 0)
      ? CarouselSlider.builder(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.90,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ),
          itemCount: plants.length,
          itemBuilder: (BuildContext context, int index) {
            final plant = plants[index];
            return GestureDetector(
                onTap: () => {
                      plantService.plant = plant,
                      Navigator.of(context)
                          .push(createRoutePlantDetail(plant, true)),
                    },
                child: Stack(
                  children: [
                    CardPlant(plant: plant),
                    Hero(
                        tag: plant.quantity + plant.id,
                        child: buildCircleFavoritePlantDash(
                            plant.quantity, context)),
                  ],
                ));
          },
        )
      : Container();
}

Widget _buildWidgetVisits(List<Visit> visits, context) {
  final visitService = Provider.of<VisitService>(context, listen: false);
  final awsService = Provider.of<AwsService>(context, listen: false);

  return (visits.length > 0)
      ? CarouselSlider.builder(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.90,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ),
          itemCount: visits.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () => {
              awsService.isUpload = false,
              visitService.visit = visits[index],
              Navigator.of(context).push(createRouteNewVisit(
                  visits[index], visits[index].plant, true)),
            },
            child: CardVisit(visit: visits[index]),
          ),
        )
      : Container();
}

final List<String> imgList = [
  'assets/banners/banner_weed4.jpg',
  'assets/banners/banner_weed1.jpg',
  'assets/banners/banner_weed2.jpg',
  'assets/banners/banner_weed5.png',
  'assets/banners/banner_weed3.jpg',
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
                          '',
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
