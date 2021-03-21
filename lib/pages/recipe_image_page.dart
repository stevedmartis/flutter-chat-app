import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';

import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/recipe_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecipeImagePage extends StatefulWidget {
  RecipeImagePage({this.profile, this.isUserAuth = true});
  final Profiles profile;
  final bool isUserAuth;

  @override
  _RecipeImagePageState createState() => _RecipeImagePageState();
}

class _RecipeImagePageState extends State<RecipeImagePage> {
  File imageRecipe;
  final picker = ImagePicker();
  bool loadingImage = false;

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
    final nameSub = (widget.profile.name == "")
        ? widget.profile.user.username
        : widget.profile.name;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: (widget.isUserAuth) ? Text('Mi Receta') : Text(nameSub),
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
                  iconSize: 25,
                  onPressed: () async => _editImage(true),
                  color: Colors.white,
                )
              : _buildLoadingWidget(),
          (!loadingImage)
              ? IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate,
                    color: currentTheme.accentColor,
                  ),
                  iconSize: 35,
                  onPressed: () async => _editImage(false),
                  color: Colors.white,
                )
              : Container()
        ],
      ),
      backgroundColor: Colors.black,
      body: Hero(
        tag: widget.profile.imageHeader,
        child: Material(
          type: MaterialType.transparency,
          child: RecipeImageExpanded(
            width: 100,
            height: 100,
            profile: widget.profile,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
        padding: EdgeInsets.only(right: 10),
        height: 400.0,
        child: Center(
            child: CircularProgressIndicator(
          color: currentTheme.accentColor,
        )));
  }

  _editImage(
    bool isCamera,
  ) async {
    final awsService = Provider.of<AwsService>(context, listen: false);

    final authService = Provider.of<AuthService>(context, listen: false);

    final profile = authService.profile;

    final pickedFile = await picker.getImage(
        source: (isCamera) ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      imageRecipe = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      setState(() {
        //  plantBlo
        loadingImage = true;
      });

      final resp = await awsService.uploadImageCoverPlant(
          fileType[0], fileType[1], imageRecipe);

      final editProfileOk =
          await authService.editImageRecipe(resp, profile.user.uid);

      if (editProfileOk != null) {
        if (editProfileOk.ok == true) {
          setState(() {
            //  plantBlo

            //profile.imageRecipe = resp;

            loadingImage = false;
          });
        } else {
          mostrarAlerta(context, 'Error', editProfileOk);
        }
      } else {
        mostrarAlerta(
            context, 'Error del servidor', 'lo sentimos, Intentelo mas tarde');
      }
    } else {
      print('No image selected.');
    }
  }
}
