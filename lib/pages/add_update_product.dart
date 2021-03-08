import 'package:chat/bloc/product_bloc.dart';
import 'package:chat/bloc/provider.dart';

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/catalogo.dart';

import 'package:chat/models/products.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/room.dart';
import 'package:chat/pages/new_product.dart';
import 'package:chat/pages/profile_page.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/plant_services.dart';
import 'package:chat/services/product_services.dart';

import 'package:chat/theme/theme.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import 'image_cover_product.dart';

//final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class AddUpdateProductPage extends StatefulWidget {
  AddUpdateProductPage({this.product, this.isEdit = false, this.catalogo});

  final Product product;
  final bool isEdit;
  final Catalogo catalogo;

  @override
  _AddUpdateProductPageState createState() => _AddUpdateProductPageState();
}

class _AddUpdateProductPageState extends State<AddUpdateProductPage> {
  Product product;
  final nameCtrl = TextEditingController();

  final descriptionCtrl = TextEditingController();

  final quantityCtrl = TextEditingController();

  var tchCtrl = new MaskedTextController(mask: '00');
  var cbdCtrl = new MaskedTextController(mask: '00');

  bool isNameChange = false;
  bool isAboutChange = false;

  bool errorRequired = false;

  bool loading = false;

  String setDateF;

  String optionItemSelected;

  bool isDefault;

  bool isThcChange = false;

  bool isCbdChange = false;
  bool isRatingChange = false;
  Profiles profile;

  double ratingActual = 0;

  @override
  void initState() {
    final productService = Provider.of<ProductService>(context, listen: false);
    product = (widget.isEdit) ? productService.product : widget.product;

    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;

    errorRequired = (widget.isEdit) ? false : true;
    nameCtrl.text = widget.product.name;
    descriptionCtrl.text = widget.product.description;

    ratingActual =
        (widget.isEdit) ? double.parse(widget.product.ratingInit) : 0;

    productBloc.imageUpdate.add(true);
    nameCtrl.addListener(() {
      // print('${nameCtrl.text}');
      setState(() {
        if (widget.product.name != nameCtrl.text)
          this.isNameChange = true;
        else
          this.isNameChange = false;

        if (nameCtrl.text == "")
          errorRequired = true;
        else
          errorRequired = false;
      });
    });
    descriptionCtrl.addListener(() {
      setState(() {
        if (widget.product.description != descriptionCtrl.text)
          this.isAboutChange = true;
        else
          this.isAboutChange = false;
      });
    });

    tchCtrl.addListener(() {
      setState(() {
        if (widget.product.thc != tchCtrl.text)
          this.isThcChange = true;
        else
          this.isThcChange = false;
      });
    });

    cbdCtrl.addListener(() {
      setState(() {
        if (widget.product.cbd != cbdCtrl.text)
          this.isCbdChange = true;
        else
          this.isCbdChange = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();

    descriptionCtrl.dispose();

    // plantBloc?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final isImageUpdate = Provider.of<AwsService>(context).isUploadImagePlant;

    final bloc = CustomProvider.productBlocIn(context);

    final size = MediaQuery.of(context).size;

    final isControllerChange = isNameChange && isThcChange && isCbdChange;

    final isControllerChangeEdit = isNameChange ||
        isAboutChange ||
        isImageUpdate ||
        isThcChange ||
        isCbdChange ||
        isRatingChange;

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor:
              (currentTheme.customTheme) ? Colors.black : Colors.white,
          actions: [
            (widget.isEdit)
                ? _createButton(bloc, isControllerChangeEdit)
                : _createButton(bloc, isControllerChange),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: currentTheme.currentTheme.accentColor,
            ),
            iconSize: 30,
            onPressed: () {
              final plantService =
                  Provider.of<PlantService>(context, listen: false);

              plantService.plant = null;

              //  Navigator.pushReplacement(context, createRouteProfile()),
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          title: (widget.isEdit)
              ? Text(
                  'Editar tratamiento',
                  style: TextStyle(
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : Colors.black),
                )
              : Text(
                  'Crear tratamiento',
                  style: TextStyle(
                      color: (currentTheme.customTheme)
                          ? Colors.white
                          : Colors.black),
                ),
        ),
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            //  _snapAppbar();
            // if (_scrollController.offset >= 250) {}
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: ClampingScrollPhysics()),
                // controller: _scrollController,
                slivers: <Widget>[
                  SliverFixedExtentList(
                    itemExtent: size.height / 3.7,
                    delegate: SliverChildListDelegate(
                      [
                        StreamBuilder<bool>(
                          stream: productBloc.imageUpdate.stream,
                          builder: (context, AsyncSnapshot<bool> snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 200),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          CoverImageProductPage(
                                              product: this.product,
                                              isEdit: widget.isEdit)));
                                },
                                child: Hero(
                                  tag: widget.product.coverImage,
                                  child: Image(
                                    image: NetworkImage(
                                      this.product.getCoverImg(),
                                    ),
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              );
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
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            _createName(bloc),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(child: _createThc(bloc)),
                                SizedBox(
                                  width: 50,
                                ),
                                Expanded(child: _createCbd(bloc)),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Valoración inicial: ',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Container(
                                  child: Text(
                                    '$ratingActual',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RatingBar.builder(
                              initialRating: ratingActual,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 5.0),
                              itemBuilder: (context, i) => (ratingActual == 5.0)
                                  ? FaIcon(
                                      FontAwesomeIcons.solidStar,
                                      color: Colors.amber,
                                    )
                                  : FaIcon(
                                      FontAwesomeIcons.star,
                                      color: Colors.amber,
                                    ),
                              onRatingUpdate: (rating) {
                                print(rating);

                                setState(() {
                                  ratingActual = rating;

                                  isRatingChange = true;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _createDescription(bloc),
                            SizedBox(
                              height: 10,
                            ),

                            /*   _createDescription(bloc), */
                          ],
                        ),
                      )),
                ]),
          ),
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

  Widget _createName(ProductBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: nameCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(30),
            ],
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),

                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Nombre  *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }

  Widget _createDescription(ProductBloc bloc) {
    //final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return StreamBuilder(
      stream: bloc.descriptionStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            inputFormatters: [
              new LengthLimitingTextInputFormatter(500),
            ],
            controller: descriptionCtrl,
            //  keyboardType: TextInputType.emailAddress,

            maxLines: 4,
            //  keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'Descripción ',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeDescription,
          ),
        );
      },
    );
  }

  Widget _createThc(ProductBloc bloc) {
    return StreamBuilder(
      stream: bloc.tchStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: tchCtrl,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                suffixIcon: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (currentTheme.customTheme)
                            ? Colors.white54
                            : Colors.black54,
                      ),
                    )),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'THC *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeThc,
          ),
        );
      },
    );
  }

  Widget _createCbd(ProductBloc bloc) {
    return StreamBuilder(
      stream: bloc.tchStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context);

        return Container(
          child: TextField(
            style: TextStyle(
              color: (currentTheme.customTheme) ? Colors.white : Colors.black,
            ),
            controller: cbdCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                suffixIcon: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (currentTheme.customTheme)
                            ? Colors.white54
                            : Colors.black54,
                      ),
                    )),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: (currentTheme.customTheme)
                      ? Colors.white54
                      : Colors.black54,
                ),
                // icon: Icon(Icons.perm_identity),
                //  fillColor: currentTheme.accentColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: currentTheme.currentTheme.accentColor, width: 2.0),
                ),
                hintText: '',
                labelText: 'CBD *',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeCbd,
          ),
        );
      },
    );
  }

  Widget _createButton(
    ProductBloc bloc,
    bool isControllerChange,
  ) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                      color: (isControllerChange && !errorRequired)
                          ? currentTheme.accentColor
                          : Colors.grey.withOpacity(0.60),
                      fontSize: 18),
                ),
              ),
            ),
            onTap: isControllerChange && !errorRequired && !loading
                ? () => {
                      setState(() {
                        loading = true;
                      }),
                      FocusScope.of(context).unfocus(),
                      (widget.isEdit)
                          ? _editProduct(bloc)
                          : _createProduct(bloc),
                    }
                : null);
      },
    );
  }

  _createProduct(ProductBloc bloc) async {
    final productService = Provider.of<ProductService>(context, listen: false);
    final awsService = Provider.of<AwsService>(context, listen: false);

    final catalogo = widget.catalogo.id;
    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    final name = (bloc.name == null) ? widget.catalogo.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.catalogo.description
        : bloc.description.trim();

    final ratingActualString = ratingActual.toString();

    final thc = (bloc.thc == null) ? widget.product.thc : bloc.thc.trim();

    final cbd = (bloc.cbd == null) ? widget.product.cbd : bloc.cbd.trim();

    final newProduct = Product(
        name: name,
        description: description,
        coverImage: widget.product.coverImage,
        catalogo: catalogo,
        ratingInit: ratingActualString,
        user: uid,
        cbd: cbd,
        thc: thc);

    final createProductResp = await productService.createProduct(newProduct);

    if (createProductResp != null) {
      if (createProductResp.ok) {
        // widget.plants.add(createPlantResp.plant);
        productService.product = createProductResp.product;
        // productBloc.getPlant(createPlantResp.plant);

        setState(() {
          loading = false;

          // plantBloc.getPlantsByUser(profile.user.uid);
          productBloc.getProducts(uid);

          awsService.isUploadImagePlant = true;
        });
        Navigator.pop(context);
        setState(() {});
      } else {
        setState(() {
          loading = false;
        });
        mostrarAlerta(context, 'Error', createProductResp.msg);
      }
    } else {
      mostrarAlerta(
          context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
    }
    //Navigator.pushReplacementNamed(context, '');
  }

  _editProduct(ProductBloc bloc) async {
    final productService = Provider.of<ProductService>(context, listen: false);
    final awsService = Provider.of<AwsService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    final uid = authService.profile.user.uid;

    final name = (bloc.name == null) ? widget.product.name : bloc.name.trim();
    final description = (descriptionCtrl.text == "")
        ? widget.product.description
        : descriptionCtrl.text.trim();

    final thc = (bloc.thc == null) ? widget.product.thc : bloc.thc.trim();

    final cbd = (bloc.cbd == null) ? widget.product.cbd : bloc.cbd.trim();

    final ratingActualString = ratingActual.toString();

    final editProduct = Product(
        name: name,
        description: description,
        ratingInit: ratingActualString,
        coverImage: productService.product.coverImage,
        id: widget.product.id,
        thc: thc,
        cbd: cbd);

    if (widget.isEdit) {
      final editProductRes = await productService.editProduct(editProduct);

      if (editProductRes != null) {
        if (editProductRes.ok) {
          // widget.rooms.removeWhere((element) => element.id == editRoomRes.room.id)

          productBloc.getProducts(uid);

          setState(() {
            loading = false;
            awsService.isUploadImageProduct = true;
            productService.product = editProductRes.product;
          });
          // room = editRoomRes.room;

          Navigator.pop(context);
        } else {
          setState(() {
            loading = false;
          });
          mostrarAlerta(context, 'Error', editProductRes.msg);
        }
      } else {
        mostrarAlerta(
            context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
      }
    }

    //Navigator.pushReplacementNamed(context, '');
  }
}

Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-0.5, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route createRouteAddImages(Room room) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewProductPage(
      room: room,
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
