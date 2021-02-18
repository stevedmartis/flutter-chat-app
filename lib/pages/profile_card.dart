import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/subscribe_bloc.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/subscribe.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/aws_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/subscription_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/button_gold.dart';
import 'package:chat/widgets/sliver_header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

class ProfileCard extends StatefulWidget {
  ProfileCard(
      {@required this.profileColor,
      this.isUserAuth = false,
      this.isUserEdit = false,
      @required this.profile,
      @required this.image,
      this.loading = false,
      this.isEmpty = false});

  final Color profileColor;
  static const double avatarRadius = 48;
  static const double titleBottomMargin = (avatarRadius * 2) + 18;

  final bool isUserAuth;
  final bool isUserEdit;
  final Profiles profile;

  final bool isEmpty;
  final loading;
  final ui.Image image;

  final picker = ImagePicker();

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Profiles profileClub;

  Subscription subscription;

  @override
  void initState() {
    final authService = Provider.of<AuthService>(context, listen: false);

    profileClub = authService.profile;

    super.initState();

    subscriptionBloc.getSubscription(
        profileClub.user.uid, widget.profile.user.uid);

    setState(() {});
  }

  File imageCover;
  final picker = ImagePicker();

  bool isData = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    final awsService = Provider.of<AwsService>(context, listen: false);
    final bloc = CustomProvider.subscribeBlocIn(context);

    return Stack(
      children: [
        Hero(
            tag: widget.profile.imageHeader,
            child: FadeInImage(
              image: NetworkImage(widget.profile.getHeaderImg()),
              placeholder: AssetImage('assets/loading2.gif'),
              fit: BoxFit.cover,
              height: size.height,
              width: double.infinity,
              alignment: Alignment.center,
            )),
        StreamBuilder<Subscription>(
            stream: subscriptionBloc.subscription.stream,
            builder:
                (BuildContext context, AsyncSnapshot<Subscription> snapshot) {
              if (snapshot.hasData) {
                subscription = snapshot.data;
                final isSuscribeApprove = subscription.subscribeApproved;
                final isSuscribeActive = subscription.subscribeActive;

                return Positioned(
                  child: Container(
                    margin: EdgeInsets.only(left: (widget.isUserEdit) ? 0 : 22),
                    child: Align(
                      alignment: (widget.isUserEdit)
                          ? Alignment.bottomCenter
                          : Alignment.bottomLeft,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: currentTheme.scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: ProfileCard.avatarRadius + 120,
                          backgroundColor: currentTheme.scaffoldBackgroundColor,
                          child: GestureDetector(
                            onTap: () {
                              this.widget.profile.subscribeActive =
                                  (profileClub.isClub)
                                      ? true
                                      : isSuscribeActive;
                              this.widget.profile.subscribeApproved =
                                  (profileClub.isClub)
                                      ? true
                                      : isSuscribeApprove;
                              final chatService = Provider.of<ChatService>(
                                  context,
                                  listen: false);
                              chatService.userFor = this.widget.profile;

                              Navigator.of(context).push(createRouteChat());

                              // make changes here

                              //Navigator.of(context).push(createRouteAvatarProfile(this.user));
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Hero(
                                tag: widget.profile.user.uid,
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: ImageUserChat(
                                    width: 100,
                                    // showBorderAvatar: _showBorderAvatar,
                                    height: 100,
                                    profile: widget.profile,
                                    fontsize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            }),
        (!widget.isUserEdit)
            ? StreamBuilder<Subscription>(
                stream: subscriptionBloc.subscription.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<Subscription> snapshot) {
                  isData = snapshot.hasData;

                  final subscription = snapshot.data;

                  if (isData) {
                    if (subscription.subscribeActive &&
                        subscription.isUpload &&
                        !subscription.subscribeApproved) {
                      return Container(
                        //top: size.height / 3.5,
                        padding: EdgeInsets.only(top: 35.0),
                        margin: EdgeInsets.only(
                            top: size.height / 4.5,
                            left: size.width / 1.8,
                            right: size.width / 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ButtonSubEditProfile(
                              color: currentTheme.scaffoldBackgroundColor
                                  .withOpacity(0.60),
                              textColor: (widget.isUserAuth)
                                  ? Colors.white.withOpacity(0.50)
                                  : Colors.white,
                              text: widget.isUserAuth
                                  ? 'Editar perfil'
                                  : 'Pendiente',
                              onPressed: () {
                                (widget.isUserAuth)
                                    ? Navigator.of(context)
                                        .push(createRouteEditProfile())
                                    : unSubscribe(
                                        context,
                                        bloc,
                                        currentTheme.accentColor,
                                        awsService.isUploadRecipe);
                              }),
                        ),
                      );
                    } else if (subscription.subscribeActive &&
                        subscription.isUpload &&
                        subscription.subscribeApproved) {
                      return Container(
                        //top: size.height / 3.5,
                        padding: EdgeInsets.only(top: 35.0),
                        margin: EdgeInsets.only(
                            top: size.height / 4.5,
                            left: size.width / 1.9,
                            right: size.width / 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ButtonSubEditProfile(
                              color: currentTheme.scaffoldBackgroundColor
                                  .withOpacity(0.60),
                              textColor: (widget.isUserAuth)
                                  ? Colors.white.withOpacity(0.50)
                                  : currentTheme.accentColor,
                              text: widget.isUserAuth
                                  ? 'Editar perfil'
                                  : 'SUSCRITO',
                              onPressed: () {
                                (widget.isUserAuth)
                                    ? Navigator.of(context)
                                        .push(createRouteEditProfile())
                                    : unSubscribe(
                                        context,
                                        bloc,
                                        currentTheme.accentColor,
                                        awsService.isUploadRecipe);
                              }),
                        ),
                      );
                    } else {
                      return Container(
                        //top: size.height / 3.5,
                        padding: EdgeInsets.only(top: 35.0),
                        margin: EdgeInsets.only(
                            top: size.height / 4.5,
                            left: size.width / 1.9,
                            right: size.width / 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ButtonSubEditProfile(
                              color: currentTheme.scaffoldBackgroundColor
                                  .withOpacity(0.60),
                              textColor: (widget.isUserAuth)
                                  ? Colors.white.withOpacity(0.50)
                                  : currentTheme.accentColor,
                              text: widget.isUserAuth
                                  ? 'Editar perfil'
                                  : 'SUSCRIBIRME',
                              onPressed: () {
                                (widget.isUserAuth)
                                    ? Navigator.of(context)
                                        .push(createRouteEditProfile())
                                    : updateFieldToSubscribe(
                                        context,
                                        bloc,
                                        currentTheme.accentColor,
                                        subscription,
                                      );
                              }),
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error);
                  } else {
                    return _buildLoadingWidget();
                  }
                })
            : Container(),
      ],
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

  updateFieldToSubscribe(
      context, SubscribeBloc bloc, color, Subscription subscription) {
    const List<Color> orangeGradients = [
      Color(0xff1C3041),
      Color(0xff1C3041),
      Color(0xff1C3041),
    ];

    if (Platform.isAndroid) {
      // Android
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Envia tu receta para suscribirte '),
                content: Column(
                  children: [
                    StreamBuilder(
                        stream: bloc.subscription,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return GestureDetector(
                              child: roundedRectButton(
                                  "Empecemos!", orangeGradients, false),
                              onTap: subscription.isUpload
                                  ? null
                                  : () => {
                                        FocusScope.of(context).unfocus(),
                                      });
                        }),
                  ],
                ),
                actions: <Widget>[
                  StreamBuilder(
                      stream: bloc.subscription.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        isData = snapshot.hasData;
                        return Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                                    child: Text('Enviar'),
                                    elevation: 5,
                                    textColor: Colors.blue,
                                    onPressed: () => addSubscription(
                                        context, bloc, subscription))),
                            Expanded(
                              child: MaterialButton(
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  onPressed: () => Navigator.pop(context)),
                            ),
                          ],
                        );
                      }),
                ],
              ));
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(
                'Subir receta',
                style: TextStyle(color: Colors.white54, fontSize: 15),
              ),
              content: StreamBuilder(
                  stream: bloc.subscription.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    isData = snapshot.hasData;

                    print(subscription.isUpload);
                    return (!subscription.isUpload && !isData)
                        ? Column(
                            children: [
                              GestureDetector(
                                  child: roundedRectButtonIcon(
                                      "Desde mis fotos",
                                      orangeGradients,
                                      FontAwesomeIcons.fileUpload),
                                  onTap: snapshot.hasData
                                      ? null
                                      : () => {_selectImage(false, bloc)}),
                              GestureDetector(
                                  child: roundedRectButtonIcon(
                                      "Desde mi camara",
                                      orangeGradients,
                                      FontAwesomeIcons.camera),
                                  onTap: snapshot.hasData
                                      ? null
                                      : () => {_selectImage(true, bloc)}),
                            ],
                          )
                        : GestureDetector(
                            onTap: () => {_selectImage(false, bloc)},
                            child: Container(
                              padding: EdgeInsets.only(top: 10.0),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  child: Container(
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          (!subscription.isUpload && !isData)
                                              ? snapshot.data.imageRecipe
                                              : subscription.imageRecipe),
                                      placeholder:
                                          AssetImage('assets/loading2.gif'),
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                    ),
                                  )),
                            ),
                          );
                  }),
              actions: <Widget>[
                StreamBuilder(
                    stream: bloc.subscription,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      isData = snapshot.hasData;
                      return Row(
                        children: [
                          Expanded(
                            child: CupertinoDialogAction(
                                isDefaultAction: true,
                                child: Text(
                                  'ENVIAR',
                                  style: TextStyle(
                                      color: (subscription.isUpload || isData)
                                          ? color
                                          : Colors.white54),
                                ),
                                onPressed: () =>
                                    (subscription.isUpload || isData)
                                        ? addSubscription(
                                            context, bloc, subscription)
                                        : null),
                          ),
                          Expanded(
                            child: CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(color: Colors.white54),
                                ),
                                onPressed: () => Navigator.pop(context)),
                          ),
                        ],
                      );
                    }),
              ],
            ));
  }

  unSubscribe(context, SubscribeBloc bloc, color, bool isUploadRecipe) {
    const List<Color> orangeGradients = [
      Color(0xff1C3041),
      Color(0xff1C3041),
      Color(0xff1C3041),
    ];

    if (Platform.isAndroid) {
      // Android
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Envia tu receta para suscribirte '),
                content: Column(
                  children: [
                    StreamBuilder(
                        stream: bloc.subscription,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return GestureDetector(
                              child: roundedRectButton(
                                  "Empecemos!", orangeGradients, false),
                              onTap: isUploadRecipe
                                  ? null
                                  : () => {
                                        FocusScope.of(context).unfocus(),
                                      });
                        }),
                  ],
                ),
                actions: <Widget>[
                  StreamBuilder(
                      stream: bloc.subscription.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        isData = snapshot.hasData;
                        return Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                                    child: Text('Enviar'),
                                    elevation: 5,
                                    textColor: Colors.blue,
                                    onPressed: () => addSubscription(
                                        context, bloc, subscription))),
                            Expanded(
                              child: MaterialButton(
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  onPressed: () => Navigator.pop(context)),
                            ),
                          ],
                        );
                      }),
                ],
              ));
    }

    final nameClub = widget.profile.name;
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                title: Container(
                  child: Text(
                    '¿Deseas anular tu suscripción a $nameClub ?',
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),
                ),
                actions: <Widget>[
                  Column(
                    children: [
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          child: Text(
                            'ANULAR SUSCRIPCIÓN',
                            style: TextStyle(color: color, fontSize: 15),
                          ),
                          onPressed: () => (isData)
                              ? unSubscription(
                                  context,
                                  bloc,
                                )
                              : null),
                      CupertinoDialogAction(
                          isDestructiveAction: true,
                          child: Text(
                            'Cancelar',
                            style:
                                TextStyle(color: Colors.white54, fontSize: 15),
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  )
                ]));
  }

  _selectImage(bool isCamera, SubscribeBloc bloc) async {
    final awsService = Provider.of<AwsService>(context, listen: false);
    final subscription = subscriptionBloc.subscription.value;

    final pickedFile = await picker.getImage(
        source: (isCamera) ? ImageSource.camera : ImageSource.gallery);

    if (pickedFile != null) {
      imageCover = File(pickedFile.path);

      final fileType = pickedFile.path.split('.');

      /* awsService.uploadAvatar(
            widget.profile.user.uid, fileType[0], fileType[1], image); */
      final resp = await awsService.uploadImageCoverPlant(
          fileType[0], fileType[1], imageCover);

      final newSubscription = new Subscription(
        id: subscription.id,
        subscriptor: profileClub.user.uid,
        club: widget.profile.user.uid,
        imageRecipe: resp,
      );
      setState(() {
        bloc.subscription.add(newSubscription);
      });
    } else {
      print('No image selected.');
    }
  }
}

void addSubscription(
    context, SubscribeBloc bloc, Subscription subscriptionExist) async {
  Subscription subscription = (bloc.subscription.value != null)
      ? bloc.subscription.value
      : subscriptionExist;
  //final socketService = Provider.of<SocketService>(context, listen: false);
  //  socketService.emit('add-band', {'name': name});
  final subscriptionService =
      Provider.of<SubscriptionService>(context, listen: false);

  final resp = await subscriptionService.createSubscription(subscription);

  if (resp.ok) {
    subscriptionBloc.getSubscription(
        resp.subscription.subscriptor, resp.subscription.club);
  }
  Navigator.pop(context);
}

void unSubscription(context, SubscribeBloc bloc) async {
  final subscription = subscriptionBloc.subscription.value;
  //final socketService = Provider.of<SocketService>(context, listen: false);
  //  socketService.emit('add-band', {'name': name});
  final subscriptionService =
      Provider.of<SubscriptionService>(context, listen: false);

  final resp = await subscriptionService.unSubscription(subscription);

  if (resp.ok) {
    subscriptionBloc.getSubscription(
        resp.subscription.subscriptor, resp.subscription.club);
  }
  Navigator.pop(context);
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
