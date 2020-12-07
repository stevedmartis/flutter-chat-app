import 'package:chat/services/users_service.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserListState();
  }
}

class _UserListState extends State<UserList> {
  final usuarioService = new UsuariosService();

  List<dynamic> _users = [];

  void fetchUsers() async {
    setState(() {});

    var result = await usuarioService.getUsers();
    setState(() {
      _users = result;
    });
  }

  Widget _buildList() {
    return _users.length != 0
        ? RefreshIndicator(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      itemCount: _users.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(_users[index].username);
                      }),
                )
              ],
            ),
            onRefresh: _getData,
          )
        : Center(child: CircularProgressIndicator());
  }

  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
        child: _buildList(),
      ),
    );
  }
}
