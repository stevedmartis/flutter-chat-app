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
import 'package:chat/widgets/product_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

class RoomDetailPage extends StatefulWidget {
  final Room room;
  RoomDetailPage({@required this.room});

  @override
  _RoomDetailPageState createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  SocketService socketService;
  final productService = new ProductService();
  List<Product> products = [];
  Future<List<Product>> getJobFuture;
  Profiles profile;

  @override
  void initState() {
    super.initState();

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

    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
          title: Text(
            widget.room.name,
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
                        setState(() {
                          //createRouteNewProduct(widget.room);

                          Navigator.pushReplacement(
                              context, createRouteNewProduct(widget.room));
                          //addNewProduct();
                        })
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
        child: FutureBuilder(
            future: getJobFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    height: 400.0,
                    child: Center(child: CircularProgressIndicator()));
              } else {
                products = snapshot.data;

                if (products.length < 1) {
                  return Center(
                    child: Text('No Products, create a new'),
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _buildWidgetProduct(products));
                }
              }
            }),
      ),
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

  addNewProduct() {
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
            height: MediaQuery.of(context).size.height * 0.70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 150, right: 150),
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
                    "New Product",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                _createName(bloc),
                SizedBox(
                  height: 30,
                ),
                _createDescription(bloc),
                SizedBox(
                  height: 40,
                ),
                ButtonAccent(
                    color: currentTheme.accentColor,
                    text: 'Done',
                    onPressed: () => _handleAddProduct(context)),
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
