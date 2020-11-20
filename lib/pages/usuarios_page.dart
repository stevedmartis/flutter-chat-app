import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/header_custom_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/models/usuario.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarioService = new UsuariosService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> users = [];


  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService   = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>( context );

    final user = authService.user;

    return Scaffold(
     // appBar: AppBarBase(user: user, socketService: socketService),
      body:         _MainScroll()
   );
  }

  ListView _listViewUsuarios() {

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile( users[i] ), 
      separatorBuilder: (_, i) => Divider(), 
      itemCount: users.length
    );
  }

  ListTile _usuarioListTile( Usuario usuario ) {
    return ListTile(
        title: Text( usuario.nombre ),
        subtitle: Text( usuario.email ),
        leading: CircleAvatar(
          child: Text( usuario.nombre .substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }


  _cargarUsuarios() async { 

    this.users = await usuarioService.getUsuarios();
    print('${users}');
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

  }
}

class AppBarBase extends StatelessWidget {
  const AppBarBase({
    Key key,
    @required this.user,
    @required this.socketService,
  }) : super(key: key);

  final Usuario user;
  final SocketService socketService;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text( user.nombre , style: TextStyle(color: Colors.black87 ) ),
      elevation: 1,
      backgroundColor: Colors.black,
      leading:/*  IconButton(
        icon: Icon( Icons.exit_to_app, color: Colors.black87 ),
        onPressed: () {

          socketService.disconnect();
          Navigator.pushReplacementNamed(context, 'login');
          AuthService.deleteToken();

        },
      ), */
        Container(
          margin: EdgeInsets.only(left:10),
                        padding: EdgeInsets.all(4.0),

                    child: CircleAvatar(
          
            child: Text( user.nombre .substring(0,2).toUpperCase()),
          backgroundColor: Colors.blue[100],
      ),
        ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only( right: 10 ),
          child: (socketService.serverStatus == ServerStatus.Online )
          ? Icon( Icons.check_circle, color: Colors.blue[400] )
          : Icon( Icons.offline_bolt, color: Colors.red ),
        ),


      ],
    );
  }
}


class _MainScroll extends StatelessWidget {




    final itemsProfile = [
   
     SizedBox(height: 100,),
        Text('hello'),
         Text('hello'),
                    SizedBox(height: 700,),

          Text('hello'),
           Text('hello')
 

  ];

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;



    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverPersistentHeader(
          floating: true,
          delegate: _SliverCustomHeaderDelegate(
            
              minHeight: 90,
              maxHeight: 90,
              child: Container(
               color: Colors.black,
                child:    Container(
                  margin: EdgeInsets.only(top:25),
                  child: CustomAppBarHeader()))
              )),
        
        SliverList(
          delegate: 
          

          SliverChildListDelegate([...itemsProfile, SizedBox(height: 100)])
         
        )
      ],
    );
  }
}


class _SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverCustomHeaderDelegate(
      {@required this.minHeight,
      @required this.maxHeight,
      @required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant _SliverCustomHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}