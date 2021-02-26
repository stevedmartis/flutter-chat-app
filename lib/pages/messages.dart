import 'package:animate_do/animate_do.dart';
import 'package:chat/models/notification.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/models/profiles_response.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/principalCustom_page.dart';
import 'package:chat/providers/messages_providers.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/customappbar_simple.dart';
import 'package:chat/widgets/text_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with TickerProviderStateMixin {
  final messagesProvider = new MessagesProvider();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  Profiles profile;

  @override
  void initState() {
    super.initState();

    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    profile = authService.profile;
    // this.socketService.socket.on('personal-message', _listenMessage);
  }

/*   void _listenMessage(dynamic payload) {
    ChatMessage message = new ChatMessage(
      text: payload['message'],
      uid: payload['by'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  } */

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              makeHeaderCustom('Mensajes'),
              makeListChats(context)
            ]),
        //bottomNavigationBar: BottomNavigation(isVisible: _isVisible),
      ),
    );
  }

  SliverPersistentHeader makeHeaderCustom(String title) {
    return SliverPersistentHeader(
        floating: true,
        delegate: SliverCustomHeaderDelegate(
            minHeight: 60,
            maxHeight: 60,
            child: Container(
                child: Container(
                    color: Colors.black,
                    child: CustomAppBarSimplePages(
                      title: title,
                    )))));
  }

  SliverList makeListChats(context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      buildSuggestions(context),
    ]));
  }

  Widget buildSuggestions(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    return FutureBuilder(
      future: messagesProvider.getProfilesChatByUser(profile.user.uid),
      builder:
          (BuildContext context, AsyncSnapshot<ProfilesResponse> snapshot) {
        if (snapshot.hasData) {
          final profiles = snapshot.data.profiles;

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: profiles.length,
            itemBuilder: (BuildContext ctxt, int index) {
              final message = profiles[index];

              final suscriptionEnabled =
                  message.subscribeApproved && message.subscribeActive;

              final DateTime dateMessage = message.messageDate;

              final DateFormat formatter = DateFormat('dd MMM');
              final String formatted = formatter.format(dateMessage);

              final DateFormat dFormatter = DateFormat('kk:mm a');
              final String timeFormatted = dFormatter.format(dateMessage);
              final nameSub =
                  (message.name == "") ? message.user.username : message.name;
              return Column(
                children: [
                  FadeInLeft(
                    delay: Duration(milliseconds: 300 * index),
                    child: Material(
                      child: ListTile(
                        tileColor:
                            currentTheme.currentTheme.scaffoldBackgroundColor,
                        leading: ImageUserChat(
                            width: 100,
                            height: 100,
                            profile: message,
                            fontsize: 20),
                        title: Text(nameSub,
                            style: TextStyle(
                                color: (currentTheme.customTheme)
                                    ? Colors.white54
                                    : Colors.black,
                                fontSize: 18)),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            EmojiText(
                                text: message.message,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: (currentTheme.customTheme)
                                      ? Colors.white54
                                      : Colors.grey,
                                ),
                                emojiFontMultiplier: 1.5),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              '· $timeFormatted',
                              style: TextStyle(
                                  color: (currentTheme.customTheme)
                                      ? Colors.white54
                                      : currentTheme.currentTheme.primaryColor,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        trailing: (suscriptionEnabled)
                            ? Text(
                                formatted,
                                style: TextStyle(
                                    color:
                                        currentTheme.currentTheme.accentColor),
                              )
                            : Text(''),
                        onTap: () {
                          final chatService =
                              Provider.of<ChatService>(context, listen: false);
                          chatService.userFor = message;

                          final notifiModel = Provider.of<NotificationModel>(
                              context,
                              listen: false);

                          notifiModel.number = 0;

                          Navigator.push(context, createRouteChat());
                        },
                      ),
                    ),
                  ),
                  Divider(height: 1),
                ],
              );
            },
          );
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
        height: 400.0, child: Center(child: CircularProgressIndicator()));
  }

  Route createRouteChat() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
        isFromMessage: true,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    /*   for (ChatMessage message in _messages) {
      message.animationController.dispose();
    } */

    //this.socketService.socket.off('personal-message');
    super.dispose();
  }
}
