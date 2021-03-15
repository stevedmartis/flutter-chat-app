import 'dart:async';
import 'dart:io';

import 'package:chat/bloc/product_bloc.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/models/product_principal.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';
import 'package:chat/models/rooms_response.dart';
import 'package:chat/models/visit.dart';
import 'package:chat/pages/add_update_product.dart';
import 'package:chat/pages/add_update_visit.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/principal_page.dart';
import 'package:chat/pages/room_list_page.dart';
import 'package:chat/providers/products_provider.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/product_services.dart';
import 'package:chat/services/room_services.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/button_gold.dart';
import 'package:chat/widgets/card_product.dart';
import 'package:chat/widgets/carousel_tabs.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:chat/widgets/sliver_appBar_snap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../utils//extension.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ProductProfileDetailPage extends StatefulWidget {
  ProductProfileDetailPage({
    Key key,
    this.title,
    this.products,
    @required this.productProfile,
    this.isUserAuth,
  }) : super(key: key);

  final String title;

  final ProductProfile productProfile;
  final List<Product> products;
  final bool isUserAuth;

  @override
  _ProductDetailPageState createState() => new _ProductDetailPageState();
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

class _ProductDetailPageState extends State<ProductProfileDetailPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;

  TabController _tabController;

  final productApiProvider = new ProductsApiProvider();
  String name = '';

  Future<List<Room>> getRoomsFuture;
  AuthService authService;
  ProductProfile productProfile;

  Profiles profile;

  final roomService = new RoomService();
  double get maxHeight => 200 + MediaQuery.of(context).padding.top;
  double get minHeight => MediaQuery.of(context).padding.bottom;

  bool isLike = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _tabController = new TabController(vsync: this, length: 1);

    productBloc.imageUpdate.add(true);

    super.initState();

    final authService = Provider.of<AuthService>(context, listen: false);

    final productService = Provider.of<ProductService>(context, listen: false);

    productService.productProfile = null;
    profile = authService.profile;
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController?.dispose();
    _tabController.dispose();
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset >= 130;
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final size = MediaQuery.of(context).size;
    /* final visit = new Visit();

    final visitService = Provider.of<VisitService>(context, listen: false);
    final aws = Provider.of<AwsService>(context, listen: false);
 */
    final productService = Provider.of<ProductService>(context, listen: false);

    setState(() {
      productProfile = (productService.productProfile != null)
          ? productService.productProfile
          : widget.productProfile;
    });

    return Scaffold(
        backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
        // bottomNavigationBar: BottomNavigation(isVisible: _isVisible),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    stretch: true,
                    stretchTriggerOffset: 250.0,

                    backgroundColor: _showTitle
                        ? (currentTheme.customTheme)
                            ? Colors.black
                            : Colors.white
                        : currentTheme.currentTheme.scaffoldBackgroundColor,
                    leading: Container(
                        margin: EdgeInsets.only(left: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: CircleAvatar(
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios,
                                      size: size.width / 20,
                                      color: (_showTitle)
                                          ? currentTheme
                                              .currentTheme.accentColor
                                          : Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              backgroundColor: _showTitle
                                  ? (currentTheme.customTheme)
                                      ? Colors.black54
                                      : Colors.white54
                                  : Colors.black54),
                        )),

                    actions: [
                      /*  Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            child: CircleAvatar(
                                child: IconButton(
                                    icon: Icon(Icons.add,
                                        size: size.width / 15,
                                        color: (_showTitle)
                                            ? currentTheme
                                                .currentTheme.accentColor
                                            : Colors.white),
                                    onPressed: () => {
                                          aws.isUploadImagePlant = false,
                                          visitService.visit = visit,
                                          Navigator.of(context).push(
                                              createRouteNewVisit(visit,
                                                  widget.product.id, false)),
                                        }),
                                backgroundColor: _showTitle
                                    ? (currentTheme.customTheme)
                                        ? Colors.black54
                                        : Colors.white54
                                    : Colors.black54),
                          )), */
                      //  _buildCircleQuantityPlant(),
                    ],

                    centerTitle: true,
                    pinned: true,

                    expandedHeight: maxHeight,
                    // collapsedHeight: 56.0001,
                    flexibleSpace: FlexibleSpaceBar(
                        stretchModes: [
                          StretchMode.zoomBackground,
                          StretchMode.fadeTitle,
                          // StretchMode.blurBackground
                        ],
                        background: Material(
                            type: MaterialType.transparency,
                            child: FadeInImage(
                              image: NetworkImage(
                                  productProfile.product.getCoverImg()),
                              placeholder: AssetImage('assets/loading2.gif'),
                              fit: BoxFit.cover,
                              height: 100,
                              width: double.infinity,
                              alignment: Alignment.center,
                            )),
                        centerTitle: true,
                        title: Container(
                            //  margin: EdgeInsets.only(left: 0),
                            width: size.height / 2,
                            height: 30,
                            child: Container(
                              child: Center(
                                child: Text(
                                  (productProfile.product.name.isNotEmpty)
                                      ? productProfile.product.name.capitalize()
                                      : '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _showTitle
                                          ? (currentTheme.customTheme)
                                              ? Colors.white
                                              : Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ))

                        /* StreamBuilder<Product>(

                        stream: productBloc.productSelect.stream,
                        builder: (context, AsyncSnapshot<Product> snapshot) {
                          if (snapshot.hasData) {
                            product = snapshot.data;

                            return Container(
                                //  margin: EdgeInsets.only(left: 0),
                                width: size.height / 5,
                                height: 30,
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      product.name.capitalize(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _showTitle
                                              ? (currentTheme.customTheme)
                                                  ? Colors.white
                                                  : Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                ));
                          } else if (snapshot.hasError) {
                            return _buildErrorWidget(snapshot.error);
                          } else {
                            return _buildLoadingWidget();
                          }
                        },
                      ),  */
                        ),
                  ),

                  // makeHeaderSpacer(context),
                  makeHeaderInfo(context),
                  // makeHeaderSpacer(context),

                  //   makeHeaderTabs(context),

                  //   makeListVisits(context)
                ])));
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: size.height / 7,
        maxHeight: size.height / 7,
        child: DefaultTabController(
          length: 1,
          child: Scaffold(
            appBar: AppBar(
              leading: null,
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              bottom: TabBar(
                  labelColor: currentTheme.accentColor,
                  indicatorWeight: 3.0,
                  indicatorColor: currentTheme.accentColor,
                  tabs: [
                    /*   Tab(
                        icon: Icon(Icons.local_florist,
                            color: (_tabController.index == 0)
                                ? currentTheme.accentColor
                                : Colors.grey)),
                    Tab(
                        icon: FaIcon(FontAwesomeIcons.wind,
                            color: (_tabController.index == 1)
                                ? currentTheme.accentColor
                                : Colors.grey)), */
                    Tab(
                        text: 'Vistas',
                        icon: FaIcon(FontAwesomeIcons.eye,
                            color: (_tabController.index == 0)
                                ? currentTheme.accentColor
                                : Colors.grey)),
                  ],
                  onTap: (value) => {
                        /* _tabController
                            .animateTo((_tabController.index + 1) % 2),
                        setState(() {
                          _tabController.index = value;
                        }) */
                      }),
            ),
          ),
        ),
      ),
    );
  }

/* 
  SliverList makeListVisits(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          child: FutureBuilder(
            future: this.visitApiProvider.getVisitPlant(widget.plant.id),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                visits = snapshot.data;
                return (visits.length > 0)
                    ? Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: _buildWidgetVisits(visits))
                    : Center(
                        child: Container(
                            padding: EdgeInsets.all(50),
                            child: Text('No hay visitas, Agrega una nueva!',
                                style: TextStyle(
                                  color: (currentTheme.customTheme)
                                      ? Colors.white54
                                      : Colors.black54,
                                ))),
                      ); // image is ready
              } else {
                return Container(
                    height: 100.0,
                    child: Center(
                        child: CircularProgressIndicator())); // placeholder
              }
            },
          ),
        ),
      ]),
    );
  }
 */
/*   _deleteVisit(String id, int index) async {
    final res = await this.visitService.deleteVisit(id);
    if (res) {
      setState(() {
        visits.removeAt(index);
      });
    }
  } */
  _deleteProduct(
    String id,
  ) async {
    final res = await this.productApiProvider.deleteProduct(id);
    if (res) {
      setState(() {
        //    widget.plants.removeAt(index);

        productBloc.getProducts(profile.user.uid);

        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  createSelectionNvigator() {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;
    final size = MediaQuery.of(context).size;
    //final bloc = CustomProvider.roomBlocIn(context);

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
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: 20, left: size.width / 3.0, right: size.width / 3.0),
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Color(0xffEBECF0).withOpacity(0.30),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Create",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                //_createName(bloc),
                SizedBox(
                  height: 30,
                ),
                //_createDescription(bloc),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader makeHeaderTabVisit(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 70.0,
        maxHeight: 70.0,
        child: StreamBuilder<RoomsResponse>(
          stream: roomBloc.myRooms.stream,
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

  SliverPersistentHeader makeHeaderSpacer(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
          minHeight: 10,
          maxHeight: 10,
          child: Row(
            children: [Container()],
          )),
    );
  }

  SliverPersistentHeader makeHeaderDefaultTabs(context) {
    //   final roomModel = Provider.of<Room>(context);

    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
          minHeight: 70,
          maxHeight: 70,
          child: Row(
            children: [Container()],
          )),
    );
  }

  SliverList makeHeaderInfo(context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final authService = Provider.of<AuthService>(context);

    final profile = authService.profile;

    final thc =
        (productProfile.product.thc.isEmpty) ? '0' : productProfile.product.thc;
    final cbd =
        (productProfile.product.cbd.isEmpty) ? '0' : productProfile.product.cbd;

    final about = productProfile.product.description;
    final size = MediaQuery.of(context).size;
    final rating = widget.productProfile.product.ratingInit;

    var ratingDouble = double.parse('$rating');

    final productService = Provider.of<ProductService>(context, listen: false);
    final aws = Provider.of<AwsService>(context, listen: false);

    return SliverList(
      delegate: SliverChildListDelegate([
        //  final sexo = plant.sexo;

        //  final pot = (plant.pot == "") ? "0" : plant.pot;

        //final nameFinal = name.isEmpty ? "" : name.capitalize();
        //  final thc = (plant.thc.isEmpty) ? '0' : plant.thc;
        //  final cbd = (plant.cbd.isEmpty) ? '0' : plant.cbd;

        // final flower = (plant.flowering == "") ? "0" : plant.flowering;
        // final visit = new Visit();

        /*  final germina = product.germinated;
              final flora = product.flowering; */

        Container(
          color: currentTheme.currentTheme.scaffoldBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: size.width / 5, bottom: 5.0),
                child: CbdthcRow(
                  thc: thc,
                  cbd: cbd,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                  width: size.width - 5,
                  padding: EdgeInsets.only(left: size.width / 10.0, right: 30),
                  //margin: EdgeInsets.only(left: size.width / 6, top: 10),

                  child: (about.length > 0)
                      ? convertHashtag(about, context)
                      : Container()),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, left: size.width / 5, bottom: 5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    (ratingDouble >= 1)
                        ? Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.grey,
                          ),
                    (ratingDouble >= 2)
                        ? Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.grey,
                          ),
                    (ratingDouble >= 3)
                        ? Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.grey,
                          ),
                    (ratingDouble >= 4)
                        ? Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.grey,
                          ),
                    (ratingDouble == 5)
                        ? Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.orangeAccent,
                          )
                        : Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.grey,
                          ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: Text(
                        '$ratingDouble',
                        style: TextStyle(
                            color: (currentTheme.customTheme)
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () {
                  //profile.user.uid = '';
                  //Navigator.pushNamed(context, 'detail', arguments: profile);

                  if (productProfile.profile.user.uid != profile.user.uid) {
                    final chatService =
                        Provider.of<ChatService>(context, listen: false);
                    chatService.userFor = productProfile.profile;
                    Navigator.push(context,
                        createRouteProfileSelect(productProfile.profile));
                  } else {
                    Navigator.push(context, createRouteProfile());
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(
                      top: 10, left: size.width / 5, bottom: 5.0),
                  child: Row(
                    children: [
                      Container(
                        child: ImageUserChat(
                            width: 100,
                            height: 100,
                            profile: productProfile.profile,
                            fontsize: 20),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                productProfile.profile.name,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: (currentTheme.customTheme)
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                '@' + productProfile.profile.user.username,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              (widget.isUserAuth)
                  ? Row(
                      children: [
                        Container(
                          width: 130,

                          //top: size.height / 3.5,
                          margin: EdgeInsets.only(left: size.width / 10),

                          // width: size.width / 1.5,
                          child: Align(
                            alignment: Alignment.center,
                            child: ButtonSubEditProfile(
                                color: currentTheme
                                    .currentTheme.scaffoldBackgroundColor,
                                textColor: Colors.grey,
                                text: 'Editar',
                                onPressed: () {
                                  aws.isUploadImagePlant = false;
                                  productService.productProfile =
                                      productProfile;
                                  productService.product =
                                      productProfile.product;

                                  Navigator.of(context).push(
                                      createRouteEditProduct(
                                          widget.productProfile.product));
                                }),
                          ),
                        ),
                        Container(
                          width: 130,
                          //top: size.height / 3.5,
                          margin:
                              EdgeInsets.only(left: size.width / 10, right: 10),
                          // width: size.width / 1.5,
                          child: Align(
                            alignment: Alignment.center,
                            child: ButtonSubEditProfile(
                                isSecond: true,
                                color: currentTheme
                                    .currentTheme.scaffoldBackgroundColor,
                                textColor: Colors.red,
                                text: 'Eliminar',
                                onPressed: () {
                                  confirmDelete(
                                      context,
                                      'Confirmar',
                                      'Desea eliminar el tratamiento?',
                                      widget.productProfile.product.id);
                                }),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 20.0,
              ),
              Divider(
                thickness: 2.0,
                height: 1.0,
              )
            ],
          ),
        ),
      ]),
    );
  }

  confirmDelete(
    BuildContext context,
    String titulo,
    String subtitulo,
    String id,
  ) {
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(titulo),
                content: Text(subtitulo),
                actions: <Widget>[
                  MaterialButton(
                      child: Text('Eliminar'),
                      elevation: 5,
                      textColor: Colors.red,
                      onPressed: () => Navigator.pop(context)),
                  MaterialButton(
                      child: Text(
                        'Cancelar',
                      ),
                      elevation: 5,
                      textColor: Colors.white54,
                      onPressed: () => Navigator.pop(context))
                ],
              ));
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(
                titulo,
              ),
              content: Text(subtitulo),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                  onPressed: () => _deleteProduct(id),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child:
                      Text('Cancelar', style: TextStyle(color: Colors.white54)),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  Widget _buildUserWidget(RoomsResponse data) {
    return Container(
      child: Stack(fit: StackFit.expand, children: [
        TabsScrollCustom(
          rooms: data.rooms,
        ),
        /*  AnimatedOpacity(
            opacity: !_showTitle ? 1.0 : 0.0,
            duration: Duration(milliseconds: 250),
            child: _buildEditCircle()) */
      ]),
    );
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

  Widget itemCake() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            "Dark Belgium chocolate",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: Colors.white),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Cold",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Fresh",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "\$30.25",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black54),
                  ),
                  Text(
                    "per Quantity",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        color: Colors.black),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
              Icon(Icons.star, size: 15, color: Colors.orangeAccent),
            ],
          ),
        ],
      ),
    );
  }

/*   void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_scrollController.offset > 0 &&
        _scrollController.offset < scrollDistance) {
      final double snapOffset =
          _scrollController.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _scrollController.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  } */
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

RichText convertHashtag(String text, context) {
  final currentTheme = Provider.of<ThemeChanger>(context);

  List<String> split = text.split(RegExp("#"));

  List<String> hashtags = split.getRange(1, split.length).fold([], (t, e) {
    var texts = e.split(" ");

    if (texts.length > 1) {
      return List.from(t)
        ..addAll(["#${texts.first}", "${e.substring(texts.first.length)}"]);
    }
    return List.from(t)..add("#${texts.first}");
  });

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
            text: split.first,
            style: TextStyle(
                color: (currentTheme.customTheme)
                    ? Colors.white54
                    : Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 16))
      ]..addAll(hashtags
          .map((text) => text.contains("#")
              ? TextSpan(
                  text: text,
                  style: TextStyle(
                      color: currentTheme.currentTheme.accentColor,
                      fontSize: 16))
              : TextSpan(
                  text: text,
                  style: TextStyle(
                      color: (currentTheme.customTheme)
                          ? Colors.white54
                          : Colors.black54,
                      fontWeight: FontWeight.w400,
                      fontSize: 16)))
          .toList()),
    ),
  );
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

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height / 1.40);

    var firstControlPoint = Offset(size.width / 3, size.height);
    var firstEndPoint = Offset(size.width / 1.30, size.height - 60.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 60);
    var secondEndPoint = Offset(size.width / 1.30, size.height - 60);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 90);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Route createRouteEditProduct(Product product) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddUpdateProductPage(
      product: product,
      isEdit: true,
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

Route createRouteProfileSelect(Profiles profile) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        MyProfile(profile: profile),
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

Route createRouteNewVisit(Visit visit, String plant, bool isEdit) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddUpdateVisitPage(
      visit: visit,
      plant: plant,
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

class CbdthcRow extends StatelessWidget {
  const CbdthcRow(
      {Key key, @required this.thc, @required this.cbd, this.fontSize = 10})
      : super(key: key);

  final String thc;
  final String cbd;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Color(0xffF12937E),
                //color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "THC: $thc %",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white),
              ),
            ),
          ),
          /* Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(0.5),
              child: Text(
                "THC",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54),
              ),
            ),
          ), */
          SizedBox(
            width: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                //color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "CBD: $cbd %",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white),
              ),
            ),
          ),
          /* Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(0.5),
              child: Text(
                "CBD",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54),
              ),
            ),
          ), */
          SizedBox(
            width: 10,
          ),

          /* Container(
            width: 35,
            decoration: BoxDecoration(
              color: Colors.yellow[400],
              //color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              "New",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5),
            ),
          ), */
        ],
      ),
    );
  }
}
