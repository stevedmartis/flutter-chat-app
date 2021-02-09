import 'package:chat/bloc/plant_bloc.dart';
import 'package:chat/models/plant.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/plant_services.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/image_cover_expanded.dart';
import 'package:flutter/material.dart';
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
  // AwsService authService;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
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
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              color: currentTheme.accentColor,
            ),
            iconSize: 40,
            onPressed: () async =>
                (!widget.isEdit) ? _selectImage() : _editImage(),
            color: Colors.white,
          ),
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

  _selectImage() async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final plantService = Provider.of<PlantService>(context, listen: false);

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      /* awsService.uploadAvatar(
            widget.profile.user.uid, fileType[0], fileType[1], image); */
      final resp = await awsService.uploadImageCoverPlant(
          fileType[0], fileType[1], imageCover);

      setState(() {
        //  plantBloc.imageUpdate.add(true);

        plantBloc.imageUpdate.add(true);

        plantService.plant.coverImage = resp;

        awsService.isUpload = true;
        // plantService.plant.coverImage = resp;

        // awsService.isUpload = true;
      });
    } else {
      print('No image selected.');
    }
  }

  _editImage() async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final plantService = Provider.of<PlantService>(context, listen: false);

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      /* awsService.uploadAvatar(
            widget.profile.user.uid, fileType[0], fileType[1], image); */
      final resp = await awsService.updateImageCoverPlant(
          fileType[0], fileType[1], imageCover, widget.plant.id);

      setState(() {
        plantBloc.imageUpdate.add(true);

        plantService.plant.coverImage = resp;
      });
    } else {
      print('No image selected.');
    }
  }
}
