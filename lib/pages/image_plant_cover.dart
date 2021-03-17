import 'package:chat/bloc/plant_bloc.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/plant_services.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/image_cover_expanded.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CoverImagePlantPage extends StatefulWidget {
  CoverImagePlantPage(
      {this.plant, this.isUserAuth = true, this.isEdit = false});
  final Plant plant;
  final bool isUserAuth;

  final bool isEdit;

  @override
  CoverImagePlantPageState createState() => CoverImagePlantPageState();
}

class CoverImagePlantPageState extends State<CoverImagePlantPage> {
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

    if (!widget.isEdit) {
      _selectImage(false);
    }

    super.initState();
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
                  icon: FaIcon(
                    FontAwesomeIcons.camera,
                    color: currentTheme.accentColor,
                  ),
                  iconSize: 30,
                  onPressed: () async =>
                      (!widget.isEdit) ? _selectImage(true) : _editImage(true),
                  color: Colors.white,
                )
              : _buildLoadingWidget(),
          (!loadingImage)
              ? IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate,
                    color: currentTheme.accentColor,
                  ),
                  iconSize: 40,
                  onPressed: () async => (!widget.isEdit)
                      ? _selectImage(false)
                      : _editImage(false),
                  color: Colors.white,
                )
              : _buildLoadingWidget(),
        ],
      ),
      backgroundColor: Colors.black,
      body: Hero(
        tag: widget.plant.coverImage,
        child: Material(
          type: MaterialType.transparency,
          child: ImageCoverPlantExpanded(
            width: 100,
            height: 100,
            plant: widget.plant,
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

  _selectImage(bool isCamera) async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final plantService = Provider.of<PlantService>(context, listen: false);

    final pickedFile = await picker.getImage(
        source: (isCamera) ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      setState(() {
        //  plantBlo
        loadingImage = true;
      });

      final resp = await awsService.uploadImageCoverVisit(
          fileType[0], fileType[1], imageCover);

      setState(() {
        //  plantBloc.imageUpdate.add(true);

        plantBloc.imageUpdate.add(true);

        plantService.plant.coverImage = resp;
        plantBloc.getPlantsByUser(profile.user.uid);

        loadingImage = false;
        // plantService.plant.coverImage = resp;

        // awsService.isUpload = true;
      });
    } else {
      print('No image selected.');
    }
  }

  _editImage(bool isCamera) async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final plantService = Provider.of<PlantService>(context, listen: false);

    final pickedFile = await picker.getImage(
        source: (isCamera) ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      setState(() {
        //  plantBlo
        loadingImage = true;
      });

      final resp = await awsService.updateImageCoverPlant(
          fileType[0], fileType[1], imageCover, widget.plant.id);

      setState(() {
        plantBloc.imageUpdate.add(true);
        plantBloc.getPlantsByUser(profile.user.uid);

        plantService.plant.coverImage = resp;

        loadingImage = false;
      });
    } else {
      print('No image selected.');
    }
  }
}
