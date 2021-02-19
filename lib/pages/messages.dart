import 'package:chat/models/profiles.dart';
import 'package:chat/models/profiles_response.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/principalCustom_page.dart';
import 'package:chat/pages/profile_page.dart';
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

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final Profiles profile;

  CustomAppBar({
    this.title,
    this.profile,
    Key key,
  })  : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return AppBar(
      leadingWidth: 65,
      backgroundColor: Colors.black,
      actions: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Icon(
            Icons.more_vert,
            color: currentTheme.accentColor,
            size: 30,
          ),
        ),
      ],
      title: Text('Mensajes'),
      leading: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(left: 10.0),
        child: GestureDetector(
          onTap: () {
            {
              Navigator.push(context, _createRoute());
            }
          },
          child: Container(
            child: Hero(
              tag: widget.profile.user.uid,
              child: Material(
                type: MaterialType.transparency,
                child: ImageUserChat(
                  width: 100,
                  height: 100,
                  profile: widget.profile,
                  fontsize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
      automaticallyImplyLeading: true,
    );
  }
}

Route _createRoute() {
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
  List<ChatMessage> _messages = [];

  ScrollController _hideBottomNavController;

  var _isVisible;

  @override
  void initState() {
    super.initState();

    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    profile = authService.profile;
    this.socketService.socket.on('personal-message', _listenMessage);
  }

  void _listenMessage(dynamic payload) {
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
  }

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
                color: Colors.black,
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
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

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
                  Material(
                    child: ListTile(
                      tileColor: currentTheme.scaffoldBackgroundColor,
                      leading: ImageUserChat(
                          width: 100,
                          height: 100,
                          profile: message,
                          fontsize: 20),
                      title: Text(nameSub,
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmojiText(
                              text: message.message,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white54),
                              emojiFontMultiplier: 1.5),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            '· $timeFormatted',
                            style:
                                TextStyle(color: Colors.white54, fontSize: 15),
                          ),
                        ],
                      ),
                      trailing: (suscriptionEnabled)
                          ? Text(
                              formatted,
                              style: TextStyle(color: currentTheme.accentColor),
                            )
                          : Text(''),
                      onTap: () {
                        final chatService =
                            Provider.of<ChatService>(context, listen: false);
                        chatService.userFor = message;

                        Navigator.push(context, createRouteChat());
                      },
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
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    this.socketService.socket.off('personal-message');
    super.dispose();
  }
}
