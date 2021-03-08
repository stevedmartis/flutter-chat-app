import 'package:chat/bloc/product_bloc.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/product_services.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/image_product_expanded.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CoverImageProductPage extends StatefulWidget {
  CoverImageProductPage(
      {this.product, this.isUserAuth = true, this.isEdit = false});
  final Product product;
  final bool isUserAuth;

  final bool isEdit;

  @override
  CoverImageProductPageState createState() => CoverImageProductPageState();
}

class CoverImageProductPageState extends State<CoverImageProductPage> {
  File imageCover;
  final picker = ImagePicker();
  Profiles profile;
  // AwsService authService;

  bool loadingImage = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    final authService = Provider.of<AuthService>(context, listen: false);

    profile = authService.profile;
    super.initState();

    if (!widget.isEdit) {
      _selectImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: currentTheme.accentColor,
          ),
          iconSize: 40,
          onPressed: () => {
            setState(() {
              Navigator.pop(context);
            }),
          },

          //  Navigator.pushReplacementNamed(context, '/profile-edit'),
          color: Colors.white,
        ),
        actions: [
          (!loadingImage)
              ? IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate,
                    color: currentTheme.accentColor,
                  ),
                  iconSize: 40,
                  onPressed: () async =>
                      (!widget.isEdit) ? _selectImage() : _editImage(),
                  color: Colors.white,
                )
              : _buildLoadingWidget(),
        ],
      ),
      backgroundColor: Colors.black,
      body: Hero(
        tag: widget.product.coverImage,
        child: Material(
          type: MaterialType.transparency,
          child: ImageCoverProductExpanded(
            width: 100,
            height: 100,
            product: widget.product,
            fontsize: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
        padding: EdgeInsets.only(right: 10),
        height: 400.0,
        child: Center(child: CircularProgressIndicator()));
  }

  _selectImage() async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final productService = Provider.of<ProductService>(context, listen: false);

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      setState(() {
        //  plantBlo
        loadingImage = true;
      });

      /* awsService.uploadAvatar(
            widget.profile.user.uid, fileType[0], fileType[1], image); */
      final resp = await awsService.uploadImageCoverVisit(
          fileType[0], fileType[1], imageCover);

      setState(() {
        //  plantBloc.imageUpdate.add(true);

        productBloc.imageUpdate.add(true);

        productService.product.coverImage = resp;
        // plantBloc.getPlantsByUser(profile.user.uid);

        loadingImage = false;
        // plantService.plant.coverImage = resp;

        // awsService.isUpload = true;
      });
    } else {
      print('No image selected.');
    }
  }

  _editImage() async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final productService = Provider.of<ProductService>(context, listen: false);

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      setState(() {
        //  plantBlo
        loadingImage = true;
      });

      /* awsService.uploadAvatar(
            widget.profile.user.uid, fileType[0], fileType[1], image); */
      final resp = await awsService.updateImageCoverProduct(
          fileType[0], fileType[1], imageCover, widget.product.id);

      setState(() {
        productBloc.imageUpdate.add(true);
        // plantBloc.getPlantsByUser(profile.user.uid);

        productService.product.coverImage = resp;

        loadingImage = false;
      });
    } else {
      print('No image selected.');
    }
  }
}
