import 'dart:async';

import 'package:chat/bloc/product_bloc.dart';
import 'package:chat/bloc/provider.dart';

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';
import 'package:chat/pages/new_product.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/services/product_services.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/button_gold.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:chat/widgets/product_widget.dart';
import 'package:chat/widgets/room_card.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import '../utils//extension.dart';

class RoomDetailPage extends StatefulWidget {
  final Room room;
  RoomDetailPage({@required this.room});

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage>
    with SingleTickerProviderStateMixin {
  SocketService socketService;
  final productService = new ProductService();
  List<Product> products = [];
  Future<List<Product>> getJobFuture;
  Profiles profile;
  ScrollController _scrollController;

  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'Plants'),
    new Tab(text: 'Wind'),
    new Tab(text: 'Light'),
  ];
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(vsync: this, length: myTabs.length);

    print(widget.room);
    this._chargeProducts();
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = this.products.removeAt(oldindex);
      this.products.insert(newindex, items);
    });
  }

  _chargeProducts() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    getJobFuture = productService.geProductByRoom(profile.user.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final name = widget.room.name.toLowerCase();

    final nameFinal = name.isEmpty ? "" : name.capitalize();
    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
          title: Text(
            nameFinal,
            style: TextStyle(),
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
        child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            slivers: <Widget>[
              makeHeaderInfo(context),

              makeHeaderTabs(context)
              //   makeHeaderSpacer(context),
              //  makeHeaderTabs(context),

              /*  SliverList(
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
    );
  }

  SliverPersistentHeader makeHeaderInfo(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final about = widget.room.description;
    final size = MediaQuery.of(context).size;

    final co2 = widget.room.co2 ? 'Yes' : 'No';
    final co2Control = widget.room.co2Control ? 'Yes' : 'No';
    final timeOn = widget.room.timeOn;
    final timeOff = widget.room.timeOff;

    return SliverPersistentHeader(
      pinned: false,
      delegate: SliverAppBarDelegate(
          minHeight: (about.length > 0) ? 250 : 200,
          maxHeight: (about.length > 0) ? 250 : 200,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20.0),
            color: currentTheme.scaffoldBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
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
                  wide: widget.room.wide,
                  long: widget.room.long,
                  tall: widget.room.tall,
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
                          //  Navigator.of(context).push(createRouteEditProfile());
                        }),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildWidgetProduct(data) {
    print(data);
    return Container(
      child: SizedBox(
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return CardProduct(index: index);
            }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleAddProduct(BuildContext context) async {
    final productService = Provider.of<ProductService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final bloc = CustomProvider.productBlocIn(context);

    print('================');
    print('name: ${bloc.name}');
    print('desc: ${bloc.description}');
    print('================');

    final product = new Product(
        name: bloc.name,
        description: bloc.description,
        id: authService.profile.user.uid);

    final addProductOk = await productService.createProduct(product);

    if (addProductOk != null) {
      if (addProductOk == true) {
        //socketService.connect();
        //Navigator.push(context, _createRute());

        Navigator.pop(context);

        Timer(
            Duration(milliseconds: 300),
            () => {
                  setState(() {
                    products.add(product);
                  }),
                });
        productBloc.getProducts(authService.profile.user.uid);
      } else {
        mostrarAlerta(context, 'Registro incorrecto', addProductOk);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _deleteProduct(String id, int index) async {
    final res = await this.productService.deleteRoom(id);

    final authService = Provider.of<AuthService>(context, listen: false);

    if (res) {
      setState(() {
        products.removeAt(index);
      });

      productBloc.getProducts(authService.profile.user.uid);
    }
  }

  createModalSelection() {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;

    final bloc = CustomProvider.productBlocIn(context);

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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      leading: Icon(Icons.local_florist,
                          size: 30, color: currentTheme.accentColor),
                      title: Text(
                        'Flower',
                        style: TextStyle(fontSize: 20),
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
                          size: 30, color: currentTheme.accentColor),
                      title: Text(
                        'Aire',
                        style: TextStyle(fontSize: 20),
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
                          size: 30, color: currentTheme.accentColor),
                      title: Text(
                        'Luz',
                        style: TextStyle(fontSize: 20),
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

  Widget _createName(ProductBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.yellow, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Name',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeName,
          ),
        );
      },
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
              backgroundColor: Colors.black,
              bottom: TabBar(
                  indicatorWeight: 3.0,
                  indicatorColor: currentTheme.accentColor,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.local_florist,
                            color: (_tabController.index == 0)
                                ? currentTheme.accentColor
                                : Colors.white)),
                    Tab(
                        icon: FaIcon(FontAwesomeIcons.wind,
                            color: (_tabController.index == 1)
                                ? currentTheme.accentColor
                                : Colors.white)),
                    Tab(
                        icon: FaIcon(FontAwesomeIcons.lightbulb,
                            color: (_tabController.index == 2)
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

  Widget _createDescription(ProductBloc bloc) {
    return StreamBuilder(
      stream: bloc.descriptionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: TextField(
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.yellow, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: '',
                labelText: 'Description',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDescription,
          ),
        );
      },
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

Route createRouteNewProduct(Room room) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        NewProductPage(room: room),
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
