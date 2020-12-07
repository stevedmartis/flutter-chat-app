import 'package:chat/models/usuario.dart';
import 'package:chat/services/users_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';

class RoomsListPage extends StatefulWidget {
  @override
  _RoomsListPageState createState() => _RoomsListPageState();
}

class _RoomsListPageState extends State<RoomsListPage> {
  SocketService socketService;
  AuthService authService;
  final usuarioService = new UsuariosService();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    this._chargeUsers();
    this.authService = Provider.of<AuthService>(context, listen: false);
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = this.users.removeAt(oldindex);
      this.users.insert(newindex, items);
    });
  }

  _chargeUsers() async {
    this.users = await usuarioService.getUsers();
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: CustomAppBarText(
        title: 'My Rooms',
      ),
      body: ReorderableListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(30),
        children: <Widget>[
          for (final item in this.users)
            Card(
              color: Colors.black,
              key: ValueKey(item),
              child: ListTile(
                trailing: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: Icon(
                    Icons.add,
                    color: currentTheme.accentColor,
                  ),
                ),
                selectedTileColor: currentTheme.accentColor,
                focusColor: currentTheme.accentColor,
                hoverColor: Colors.white,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(0.5)),
                visualDensity: VisualDensity.comfortable,
                title: Text(item.username),
                subtitle: Text(
                  '10 productos',
                  style: TextStyle(color: currentTheme.secondaryHeaderColor),
                ),
                leading: Icon(
                  Icons.drag_handle,
                  color: currentTheme.accentColor,
                ),
              ),
            ),
        ],
        onReorder: reorderData,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class CustomAppBarText extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CustomAppBarText({
    this.title,
    Key key,
  })  : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return AppBar(
      backgroundColor: Colors.black,
      actions: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Icon(
            Icons.add,
            color: currentTheme.accentColor,
            size: 30,
          ),
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              this.title,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: currentTheme.accentColor,
        ),
        iconSize: 30,
        onPressed: () => Navigator.pop(context),
        color: Colors.white,
      ),
      automaticallyImplyLeading: true,
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final User user;

  CustomAppBar({
    @required this.user,
    this.title,
    Key key,
  })  : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      actions: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            child: Container(
              width: 50,
              height: 50,
              child: Hero(
                  tag: user.uid,
                  child: ImageUserChat(
                      width: 100, height: 100, user: user, fontsize: 20)),
            ),
          ),
          Container(
            child: Text(
              user.username,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        iconSize: 30,
        onPressed: () => Navigator.pop(context),
        color: Colors.white,
      ),
      automaticallyImplyLeading: true,
    );
  }
}
