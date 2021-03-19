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
import 'package:chat/models/product_principal.dart';
import 'package:chat/models/products_profiles_response.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/models/visits_response.dart';
import 'package:chat/pages/plant_detail.dart';
import 'package:chat/pages/product_profile_detail.dart';
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
import 'package:chat/widgets/productProfile_card.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:chat/widgets/visit_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  List<ProductProfile> productsProfiles = [];

  var _isVisible;

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

    this._chargeLastProducts();

    this.bottomControll();

    _isVisible = true;
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(
      () {
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
              authService.bottomVisible = false;
            });
        }
        if (_hideBottomNavController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
              authService.bottomVisible = true;
            });
        }
      },
    );

    super.initState();
  }

  bottomControll() {}

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

    productBloc.getProducts(profile.user.uid);
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
    _hideBottomNavController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return
        // room = snapshot.data;

        CustomScrollView(
      controller: _hideBottomNavController,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        makeHeaderCustom(),
        CupertinoSliverRefreshControl(onRefresh: () => pullToRefreshData()),
        makeHeaderSpacerShort(context),
        SliverFixedExtentList(
          itemExtent: size.height / 4,
          delegate: SliverChildListDelegate(
            [FadeIn(child: BannerSlide())],
          ),
        ),
        makeHeaderSpacerShort(context),
        makeListClubes(context),
        makeHeaderSpacerShort(context),
        makelistCarouselMyPlants(context),
        makeListCarouselMyVisits(context),
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
                return Container(); // placeholder
              }
            },
          ),
        ],
      ),
    );
  }

  SliverList makelistCarouselMyPlants(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: StreamBuilder<PlantsResponse>(
            stream: plantBloc.plantsUser.stream,
            builder: (context, AsyncSnapshot<PlantsResponse> snapshot) {
              if (snapshot.hasData) {
                plants = snapshot.data.plants;

                return Stack(
                  children: [
                    (plants.length > 0)
                        ? FadeIn(
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 40, top: 0, bottom: 0),
                              child: Text(
                                'Mis Cultivos',
                                style: TextStyle(
                                    color: (currentTheme.customTheme)
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          )
                        : Container(),
                    FadeInRight(
                      delay: Duration(microseconds: 500),
                      child: _buildWidgetPlants(plants, context),
                    ),
                  ],
                ); // image is ready
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget(context);
              }
            },
          ),
        ),
      ]),
    );
  }

  SliverList makeListCarouselMyVisits(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final size = MediaQuery.of(context).size;

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
            child: StreamBuilder<VisitsResponse>(
          stream: visitBloc.visitsUser.stream,
          builder: (context, AsyncSnapshot<VisitsResponse> snapshot) {
            if (snapshot.hasData) {
              visits = snapshot.data.visits;
              return Stack(
                children: [
                  (visits.length > 0)
                      ? FadeIn(
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 40, top: size.height / 30, bottom: 0),
                            child: Text(
                              'Ultimas Visitas',
                              style: TextStyle(
                                  color: (currentTheme.customTheme)
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        )
                      : Container(),
                  FadeInRight(
                    delay: Duration(milliseconds: 600),
                    child: _buildWidgetVisits(visits, context),
                  ),
                ],
              ); // image is ready
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget(context);
            }
          },
        )),
      ]),
    );
  }

  SliverList makeListProducts(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return SliverList(
      delegate: SliverChildListDelegate([
        Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
              ),
              child: Text(
                'Tratamientos',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 40),
                child: StreamBuilder<ProductsProfilesResponse>(
                  stream: productBloc.produtsProfiles.stream,
                  builder: (context,
                      AsyncSnapshot<ProductsProfilesResponse> snapshot) {
                    if (snapshot.hasData) {
                      productsProfiles = snapshot.data.productsProfiles;
                      return (productsProfiles.length > 0)
                          ? _buildWidgetProducts(
                              productsProfiles, context, profile)
                          : Container();
                    } else if (snapshot.hasError) {
                      return _buildErrorWidget(snapshot.error);
                    } else {
                      return _buildLoadingWidget(context);
                    }
                  },
                )),
          ],
        ),
      ]),
    );
  }

  SliverPersistentHeader makeHeaderSpacer(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
          minHeight: 40,
          maxHeight: 40,
          child: Row(
            children: [Container()],
          )),
    );
  }

  SliverPersistentHeader makeHeaderSpacerShort(context) {
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
            return _buildLoadingWidget(context);
          }
        },
      ),
    ),
  );
}

Widget _buildLoadingWidget(context) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

  return Container(
      height: 400.0,
      child: Center(
          child: CircularProgressIndicator(
        color: currentTheme.accentColor,
      )));
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
              viewportFraction: 0.70,
              height: screenSize.height,
              aspectRatio: (screenSize.height > 500) ? 2.9 : 2.9,
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
            height: size.height / 3.0,
            viewportFraction: 0.80,
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

            return Container(
              padding:
                  EdgeInsets.only(right: 20, bottom: 10, top: size.height / 20),
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
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          child: CardPlantPrincipal(
                            plant: plant,
                          ),
                        ),
                        buildCircleQuantityPlant(plant.quantity, context),
                      ],
                    );
                  }),
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
            height: size.height / 3,
            viewportFraction: 0.80,
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

            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10, top: size.height / 12),
                  child: OpenContainer(
                      closedElevation: 5,
                      openElevation: 5,
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
                        return Container(
                            child: CardVisit(visit: visits[index]));
                      }),
                ),
              ],
            );
          })
      : Container();
}

Widget _buildWidgetProducts(
    List<ProductProfile> productsProfiles, context, profile) {
  final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
  final size = MediaQuery.of(context).size;

  return Container(
    child: SizedBox(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: productsProfiles.length,
          itemBuilder: (BuildContext ctxt, int index) {
            final productProfiles = productsProfiles[index];

            final isUserAuth =
                (productProfiles.profile.user.uid == profile.user.uid)
                    ? true
                    : false;

            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: size.height / 30,
                  ),
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
                        return ProductProfileDetailPage(
                            productProfile: productProfiles,
                            isUserAuth: isUserAuth);
                      },
                      closedBuilder: (_, openContainer) {
                        return FadeInLeft(
                            delay: Duration(milliseconds: 300 * index),
                            child: CardProductProfile(
                                productProfile: productProfiles));
                      }),
                ),
              ],
            );
          }),
    ),
  );
}

class Banners {
  final int id;
  final String title;
  final String subTitle;
  final String url;

  const Banners(this.id, this.url, this.title, this.subTitle);
}

const List<Banners> getBanners = <Banners>[
  Banners(
      1,
      'assets/banners/10-2.png',
      'Cultivo Medicinal Seguro y Transparente.',
      'dispensarios, pacientes y tratamientos'),
  Banners(
      2,
      'assets/banners/ba8.jpeg',
      'Cultiva mejor! registra tus Plantas y Visitas',
      'Visitas y Tratamientos'),
  Banners(
      3,
      'assets/banners/a10.jpeg',
      'Suscribete a Clubs y encuentra tu Tratamientos',
      'Suscripciones en línea para pacientes con receta médica'),
];

final List<Widget> imageSliders = getBanners
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      item.url,
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
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
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
