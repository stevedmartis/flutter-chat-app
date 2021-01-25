import 'package:chat/bloc/plant_bloc.dart';

import 'package:chat/bloc/room_bloc.dart';

import 'package:chat/models/plant.dart';

import 'package:chat/models/room.dart';
import 'package:chat/pages/add_update_plant.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/providers/plants_provider.dart';
import 'package:chat/providers/rooms_provider.dart';
import 'package:chat/widgets/plant_card_widget.dart';

import '../utils//extension.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/button_gold.dart';
import 'package:chat/widgets/plant_card_widget.dart';
import 'package:chat/widgets/room_card.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/socket_service.dart';

class RoomDetailPage extends StatefulWidget {
  final Room room;
  final List<Room> rooms;

  RoomDetailPage({@required this.room, this.rooms});

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;

  final plantService = new PlantsApiProvider();

  final roomsApiProvider = new RoomsApiProvider();

  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'Plants'),
    new Tab(text: 'Wind'),
    new Tab(text: 'Light'),
  ];
  TabController _tabController;

  Room room;
  List<Plant> plants = [];

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(vsync: this, length: myTabs.length);

    this._chargePlants();
  }

  _chargePlants() async {
    this.plants = await this.plantService.getPlantsRoom(widget.room.id);

    //getJobFuture = roomBloc.getRooms(profile.user.uid);
    room = roomBloc.getRoom(widget.room);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();

    roomBloc.disposeRoom();

    plantBloc?.disposePlants();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    String nameFinal = "";
    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
          title: StreamBuilder<Room>(
            stream: roomBloc.roomSelect.stream,
            builder: (context, AsyncSnapshot<Room> snapshot) {
              if (snapshot.hasData) {
                return FutureBuilder<Room>(
                    future: this.roomsApiProvider.getRoom(widget.room.id),
                    builder:
                        (BuildContext context, AsyncSnapshot<Room> snapshot) {
                      if (!snapshot.hasData) {
                        return Text(nameFinal);
                      } else {
                        room = snapshot.data;
                        nameFinal =
                            room.name.isEmpty ? "" : room.name.capitalize();
                        return Text(nameFinal);
                      }
                    });
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          ),
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: currentTheme.accentColor,
                  ),
                  iconSize: 30,
                  onPressed: () => {
                        createModalSelection()
                        /*  setState(() {
                          //createRouteNewProduct(widget.room);

                          Navigator.pushReplacement(
                              context, createRouteNewProduct(widget.room));
                          //addNewProduct();
                        }) */
                      }),
            )
          ],
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: currentTheme.accentColor,
            ),
            iconSize: 30,
            onPressed: () =>
                //  Navigator.pushReplacement(context, createRouteProfile()),
                Navigator.pop(context),
            color: Colors.white,
          )),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: StreamBuilder<Room>(
          stream: roomBloc.roomSelect.stream,
          builder: (context, AsyncSnapshot<Room> snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder<Room>(
                  future: this.roomsApiProvider.getRoom(widget.room.id),
                  builder:
                      (BuildContext context, AsyncSnapshot<Room> snapshot) {
                    if (!snapshot.hasData) {
                      return CustomScrollView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: _scrollController,
                          slivers: <Widget>[makeHeaderLoading(context)]);
                    } else {
                      room = snapshot.data;
                      return CustomScrollView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: _scrollController,
                          slivers: <Widget>[
                            makeHeaderInfo(context),
                            makeHeaderTabs(context),
                            makeListPlants(context)
                          ]);
                    }
                  });
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ),

        /* StreamBuilder<Room>(
          stream: roomBloc.roomSelect.stream,
          builder: (context, AsyncSnapshot<Room> snapshot) {
            if (snapshot.hasData) {
              room = snapshot.data;
              return CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  slivers: <Widget>[
                    makeHeaderInfo(context),
                    makeHeaderTabs(context),
                    makeListPlants(context)
                  ]);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ), */
      ),
    );
  }

  SliverFixedExtentList makePlantCard(context) {
    return SliverFixedExtentList(
      itemExtent: 100.0,
      delegate: SliverChildListDelegate([
        FutureBuilder(
          future: this.plantService.getPlantsRoom(widget.room.id),
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Container(
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  child: _buildWidgetPlant(snapshot.data)); // image is ready
            } else {
              return Container(
                  height: 400.0,
                  child: Center(
                      child: CircularProgressIndicator())); // placeholder
            }
          },
        ),
        /* StreamBuilder<PlantsResponse>(
          stream: plantBloc.subject.stream,
          builder: (context, AsyncSnapshot<PlantsResponse> snapshot) {
            if (snapshot.hasData) {
              plants = snapshot.data.plants;

              return (plants.length > 0)
                  ? _buildWidgetPlant(plants)
                  : Center(
                      child: Text('not found'),
                    );
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        ), */
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

  SliverPersistentHeader makeHeaderLoading(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
          minHeight: 200, maxHeight: 200, child: _buildLoadingWidget()),
    );
  }

  SliverPersistentHeader makeHeaderInfo(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final about = room.description;
    final size = MediaQuery.of(context).size;

    final co2 = room.co2 ? 'Yes' : 'No';
    final co2Control = room.co2Control ? 'Yes' : 'No';
    final timeOn = room.timeOn;
    final timeOff = room.timeOff;

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
          minHeight: (about.length > 10) ? 230 : 200,
          maxHeight: (about.length > 10) ? 230 : 200,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10.0, top: 10),
            color: currentTheme.scaffoldBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  //margin: EdgeInsets.only(left: size.width / 6, top: 10),
                  width: size.width / 1.3,
                  child: Text(
                    about,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0, color: Colors.white54),
                  ),
                ),
                /* Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    //margin: EdgeInsets.only(left: size.width / 6, top: 10),

                    child: Text(
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
                ), */
                SizedBox(
                  height: 5.0,
                ),
                RowMeassureRoom(
                  wide: room.wide,
                  long: room.long,
                  tall: room.tall,
                  center: true,
                  fontSize: 15.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Co2 : $co2',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Container(
                      child: Text(
                        'Timer : $co2Control',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 15.0,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                RowTimeOnOffRoom(
                  timeOn: timeOn,
                  timeOff: timeOff,
                  size: 15.0,
                  center: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  //top: size.height / 3.5,
                  width: size.width / 1.3,
                  child: Align(
                    alignment: Alignment.center,
                    child: ButtonSubEditProfile(
                        color: currentTheme.scaffoldBackgroundColor,
                        textColor: Colors.white54,
                        text: 'Editar room',
                        onPressed: () {
                          Navigator.of(context).push(createRouteAddRoom(
                              widget.room, widget.rooms, true));
                        }),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildWidgetPlant(plants) {
    return Container(
      child: SizedBox(
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: plants.length,
            itemBuilder: (BuildContext ctxt, int index) {
              final plant = plants[index];
              return InkWell(
                  onTap: () => {
                        Navigator.of(context).push(createRouteNewPlant(
                            plant, plants, widget.room, true)),
                      },
                  child: Stack(
                    children: [
                      CardPlant(plant: plant),
                      _buildCircleFavoriteProduct(plant.quantity),
                    ],
                  ));
            }),
      ),
    );
  }

  Container _buildCircleFavoriteProduct(String quantity) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.only(left: size.width / 1.20, top: 0),
        width: 50,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: CircleAvatar(
              child: Text(
                '$quantity',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              backgroundColor: currentTheme.accentColor),
        ));
  }

  createModalSelection() {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;
    final plant = new Plant();
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
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 125, right: 125),
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Color(0xffEBECF0).withOpacity(0.60),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Create",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                  child: Center(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      height: 1.0,
                      color: Colors.white60.withOpacity(0.10),
                    ),
                  ),
                ),
                Material(
                  color: currentTheme.scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () => {
                      Navigator.of(context).pop(),
                      Navigator.of(context).push(createRouteNewPlant(
                          plant, plants, widget.room, false)),
                    },
                    child: ListTile(
                      leading: Icon(Icons.local_florist,
                          size: 25, color: currentTheme.accentColor),
                      title: Text(
                        'Flower',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: currentTheme.accentColor,
                        ),
                        iconSize: 30.0,
                        onPressed: () => {
                          //Navigator.pop(context),
                        },
                      ),
                      //trailing:
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                  child: Center(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      height: 1.0,
                      color: Colors.white60.withOpacity(0.10),
                    ),
                  ),
                ),
                Material(
                  color: currentTheme.scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () => {},
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.wind,
                          size: 25, color: currentTheme.accentColor),
                      title: Text(
                        'Aire',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: currentTheme.accentColor,
                        ),
                        iconSize: 30.0,
                        onPressed: () => {
                          //Navigator.pop(context),
                        },
                      ),
                      //trailing:
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                  child: Center(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      height: 1.0,
                      color: Colors.white60.withOpacity(0.10),
                    ),
                  ),
                ),
                Material(
                  color: currentTheme.scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () => {},
                    child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.lightbulb,
                          size: 25, color: currentTheme.accentColor),
                      title: Text(
                        'Luz',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: currentTheme.accentColor,
                        ),
                        iconSize: 30.0,
                        onPressed: () => {
                          //Navigator.pop(context),
                        },
                        color: Colors.white60.withOpacity(0.30),
                      ),
                      //trailing:
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                  child: Center(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
                      height: 1.0,
                      color: Colors.white60.withOpacity(0.10),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  SliverList makeListPlants(context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          child: FutureBuilder(
            future: this.plantService.getPlantsRoom(widget.room.id),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return (snapshot.data.length > 0)
                    ? Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: _buildWidgetPlant(snapshot.data))
                    : Center(
                        child: Container(
                            padding: EdgeInsets.all(50),
                            child: Text('No Plants, add new')),
                      ); // image is ready
              } else {
                return Container(
                    height: 400.0,
                    child: Center(
                        child: CircularProgressIndicator())); // placeholder
              }
            },
          ),
        ),
      ]),
    );
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              bottom: TabBar(
                  indicatorWeight: 3.0,
                  indicatorColor: currentTheme.accentColor,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.local_florist,
                            color: (_tabController.index == 0)
                                ? currentTheme.accentColor
                                : Colors.white54)),
                    Tab(
                        icon: FaIcon(FontAwesomeIcons.wind,
                            color: (_tabController.index == 1)
                                ? currentTheme.accentColor
                                : Colors.white54)),
                    Tab(
                        icon: FaIcon(FontAwesomeIcons.lightbulb,
                            color: (_tabController.index == 2)
                                ? currentTheme.accentColor
                                : Colors.white54)),
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

Route createRouteProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1.0, 0.0);
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

Route createRouteNewPlant(
    Plant plant, List<Plant> plants, Room room, bool isEdit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddUpdatePlantPage(
      plant: plant,
      plants: plants,
      room: room,
      isEdit: isEdit,
    ),
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
    transitionDuration: Duration(milliseconds: 400),
  );
}
