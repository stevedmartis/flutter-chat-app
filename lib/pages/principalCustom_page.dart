import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat/bloc/plant_bloc.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/bloc/visit_bloc.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plants_response.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/models/visits_response.dart';
import 'package:chat/pages/plant_detail.dart';
import 'package:chat/pages/room_detail.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/plant_services.dart';
import 'package:chat/services/users_service.dart';
import 'package:chat/services/visit_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/card_product.dart';
import 'package:chat/widgets/carousel_users.dart';
import 'package:chat/widgets/header_appbar_pages.dart';
import 'package:chat/widgets/plant_card_widget.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:chat/widgets/visit_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollapsingList extends StatefulWidget {
  @override
  _CollapsingListState createState() => _CollapsingListState();
}

class _CollapsingListState extends State<CollapsingList>
    with SingleTickerProviderStateMixin {
  final usuarioService = new UsuariosService();

  ScrollController _hideBottomNavController;

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

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

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
  }

  _chargeLastPlantsByUser() async {
    // this.plants = await plantService.getLastPlantsByUser(profile.user.uid);
    plantBloc.getPlantsByUser(profile.user.uid);
  }

  _chargeLastVisitByUser() async {
    // this.visits = await visitService.getLastVisitsByUser(profile.user.uid);

    visitBloc.getVisitsByUser(profile.user.uid);
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
      controller: _hideBottomNavController,
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
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error);
                  } else {
                    return _buildLoadingWidget();
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
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error);
                  } else {
                    return _buildLoadingWidget();
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
                    color: Colors.black,
                    child: CustomAppBarHeaderPages(
                      title: '',
                      action: Container(),
                      showContent: true,
                    )))));
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
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

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
            return OpenContainer(
                closedColor: currentTheme.scaffoldBackgroundColor,
                openColor: currentTheme.scaffoldBackgroundColor,
                transitionType: ContainerTransitionType.fade,
                openShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                openBuilder: (_, closeContainer) {
                  return PlantDetailPage(plant: plant);
                },
                closedBuilder: (_, openContainer) {
                  return FadeInRight(
                    child: Stack(
                      children: [
                        CardPlant(plant: plant),
                        buildCircleFavoritePlant(plant.quantity, context),
                      ],
                    ),
                  );
                });
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
            child: FadeInRight(
                delay: Duration(milliseconds: 300),
                child: CardVisit(visit: visits[index])),
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
