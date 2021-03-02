import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat/bloc/plant_bloc.dart';
import 'package:chat/bloc/product_bloc.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/bloc/visit_bloc.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/plants_response.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/products_response.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/models/visits_response.dart';
import 'package:chat/pages/plant_detail.dart';
import 'package:chat/pages/room_detail.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/plant_services.dart';
import 'package:chat/services/users_service.dart';
import 'package:chat/services/visit_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/card_product.dart';
import 'package:chat/widgets/carousel_users.dart';
import 'package:chat/widgets/header_appbar_pages.dart';
import 'package:chat/widgets/plant_card.dart';
import 'package:chat/widgets/product_card.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:chat/widgets/visit_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_update_visit.dart';

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
  List<Product> products = [];

  Profiles profile;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: myTabs.length);

    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    this._chargeClubesProfileUsers();

    this._chargeMyLastPlantsByUser();

    this._chargeMyLastVisitByUser();

    super.initState();
  }

  _chargeClubesProfileUsers() async {
    this.profiles = await usuarioService.getProfilesLastUsers();
  }

  _chargeMyLastPlantsByUser() async {
    // this.plants = await plantService.getLastPlantsByUser(profile.user.uid);
    plantBloc.getPlantsByUser(profile.user.uid);
  }

  _chargeMyLastVisitByUser() async {
    // this.visits = await visitService.getLastVisitsByUser(profile.user.uid);

    visitBloc.getVisitsByUser(profile.user.uid);
  }

  _chargeLastProducts() async {
    // this.visits = await visitService.getLastVisitsByUser(profile.user.uid);

    productBloc.getProducts();
  }

  pullToRefreshData() async {
    this._chargeClubesProfileUsers();
    this._chargeMyLastPlantsByUser();
    this._chargeMyLastVisitByUser();
    this._chargeLastProducts();
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
            [FadeIn(child: BannerSlide())],
          ),
        ),
        makeListClubes(context),
        makeHeaderSpacer(context),
        makeHeaderSpacer(context),
        makeHlistCarouselMyProducts(context),
        makeListCarouselMyVisits(context),
        makeHeaderSpacer(context),
        makeListProducts(context)
      ],
    );
  }

  SliverFixedExtentList makeListClubes(context) {
    return SliverFixedExtentList(
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
    );
  }

  SliverFixedExtentList makeHlistCarouselMyProducts(context) {
    return SliverFixedExtentList(
      itemExtent: 190.0,
      delegate: SliverChildListDelegate(
        [
          StreamBuilder<PlantsResponse>(
            stream: plantBloc.plantsUser.stream,
            builder: (context, AsyncSnapshot<PlantsResponse> snapshot) {
              if (snapshot.hasData) {
                plants = snapshot.data.plants;
                return FadeInRight(
                  delay: Duration(microseconds: 500),
                  child: _buildWidgetPlants(plants, context),
                ); // image is ready
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          ),
        ],
      ),
    );
  }

  SliverFixedExtentList makeListCarouselMyVisits(context) {
    return SliverFixedExtentList(
      itemExtent: 150.0,
      delegate: SliverChildListDelegate(
        [
          StreamBuilder<VisitsResponse>(
            stream: visitBloc.visitsUser.stream,
            builder: (context, AsyncSnapshot<VisitsResponse> snapshot) {
              if (snapshot.hasData) {
                visits = snapshot.data.visits;
                return FadeInRight(
                  delay: Duration(milliseconds: 600),
                  child: _buildWidgetVisits(visits, context),
                ); // image is ready
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          )
        ],
      ),
    );
  }

  SliverList makeListProducts(context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
            child: StreamBuilder<ProductsResponse>(
          stream: productBloc.myProducts.stream,
          builder: (context, AsyncSnapshot<ProductsResponse> snapshot) {
            if (snapshot.hasData) {
              products = snapshot.data.products;
              return _buildWidgetProducts(products, context); // image is ready
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        )),
      ]),
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
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  final size = MediaQuery.of(context).size;
  return (plants.length > 0)
      ? CarouselSlider.builder(
          options: CarouselOptions(
            height: size.height / 2,
            viewportFraction: 0.70,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ),
          itemCount: plants.length,
          itemBuilder: (BuildContext context, int index) {
            final plant = plants[index];

            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 20, bottom: 10),
                  child: OpenContainer(
                      closedElevation: 5,
                      openElevation: 5,
                      closedColor: currentTheme.scaffoldBackgroundColor,
                      openColor: currentTheme.scaffoldBackgroundColor,
                      transitionType: ContainerTransitionType.fade,
                      openShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                      ),
                      closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                      ),
                      openBuilder: (_, closeContainer) {
                        return PlantDetailPage(plant: plant);
                      },
                      closedBuilder: (_, openContainer) {
                        return CardPlantPrincipal(
                          plant: plant,
                        );
                      }),
                ),
                buildCircleFavoritePlant(plant.quantity, context),
              ],
            );
          },
        )
      : Container();
}

Widget _buildWidgetVisits(List<Visit> visits, context) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
  final size = MediaQuery.of(context).size;

  return (visits.length > 0)
      ? CarouselSlider.builder(
          options: CarouselOptions(
            height: size.height / 2,
            viewportFraction: 0.70,
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
          itemBuilder: (BuildContext context, int index) {
            final visit = visits[index];

            return Container(
              padding: EdgeInsets.only(right: 10),
              child: OpenContainer(
                  closedColor: currentTheme.scaffoldBackgroundColor,
                  openColor: currentTheme.scaffoldBackgroundColor,
                  transitionType: ContainerTransitionType.fade,
                  openShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  openBuilder: (_, closeContainer) {
                    return AddUpdateVisitPage(
                      visit: visit,
                      plant: visit.plant,
                      isEdit: true,
                    );
                  },
                  closedBuilder: (_, openContainer) {
                    return Container(child: CardVisit(visit: visits[index]));
                  }),
            );
          })
      : Container();
}

Widget _buildWidgetProducts(products, context) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return Container(
    child: SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final product = products[index];

            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 0.0),
                  child: OpenContainer(
                      closedElevation: 5,
                      openElevation: 5,
                      closedColor: currentTheme.scaffoldBackgroundColor,
                      openColor: currentTheme.scaffoldBackgroundColor,
                      transitionType: ContainerTransitionType.fade,
                      openShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                      ),
                      closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                      ),
                      openBuilder: (_, closeContainer) {
                        return Container();
                      },
                      closedBuilder: (_, openContainer) {
                        return Stack(children: [
                          FadeInLeft(
                              delay: Duration(milliseconds: 300 * index),
                              child: CardProduct(product: product)),
                        ]);
                      }),
                ),
              ],
            );
          }),
    ),
  );
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
