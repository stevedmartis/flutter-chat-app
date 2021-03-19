import 'package:chat/bloc/provider.dart';
import 'package:chat/bloc/room_bloc.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/button_gold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;

    return Container(
      color: currentTheme.scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: currentTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Enter your name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.blue,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {},
            ),
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewRoomScreen extends StatelessWidget {
  NewRoomScreen(this.handleadd);

  final dynamic handleadd;

  @override
  Widget build(BuildContext context) {
    final currentTheme =
        Provider.of<ThemeChanger>(context, listen: false).currentTheme;

    final bloc = CustomProvider.roomBlocIn(context);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, left: 150, right: 150),
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Color(0xffEBECF0).withOpacity(0.30),
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
              child: Text(
                "Create Room",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            _createName(bloc),
            SizedBox(
              height: 30,
            ),
            _createDescription(bloc),
            SizedBox(
              height: 40,
            ),
            ButtonAccent(
                color: currentTheme.accentColor,
                text: 'Guardar',
                onPressed: () => {handleadd}),
          ],
        ),
      ),
    );
  }
}

Widget _createName(RoomBloc bloc) {
  return StreamBuilder(
    stream: bloc.nameStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        child: TextField(
          //  keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              // icon: Icon(Icons.perm_identity),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Name',
              //counterText: snapshot.data,
              errorText: snapshot.error),
          onChanged: bloc.changeName,
        ),
      );
    },
  );
}

Widget _createDescription(RoomBloc bloc) {
  return StreamBuilder(
    stream: bloc.descriptionStream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Container(
        child: TextField(
          //  keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              // icon: Icon(Icons.perm_identity),
              //  fillColor: currentTheme.accentColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              hintText: '',
              labelText: 'Description',
              //counterText: snapshot.data,
              errorText: snapshot.error),
          onChanged: bloc.changeDescription,
        ),
      );
    },
  );
}
