import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
import 'package:chat/widgets/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarouselUsersSliderCustom extends StatefulWidget {
  const CarouselUsersSliderCustom({
    Key key,
    @required this.profiles,
  }) : super(key: key);

  final List<Profiles> profiles;

  @override
  _CarouselUsersSliderCustomState createState() =>
      _CarouselUsersSliderCustomState();
}

class _CarouselUsersSliderCustomState extends State<CarouselUsersSliderCustom> {
  @override
  Widget build(BuildContext context) {
    return (widget.profiles.length >= 6)
        ? CarouselSlider.builder(
            options: CarouselOptions(
              height: 100,
              viewportFraction: 0.30,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: widget.profiles.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                final chatService =
                    Provider.of<ChatService>(context, listen: false);
                chatService.userFor = widget.profiles[index];

                Navigator.of(context)
                    .push(createRouteProfileSelect(widget.profiles[index]));
              },
              child:
                  FadeInLeft(child: Preview(profile: widget.profiles[index])),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(left: 20, right: 20),
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: widget.profiles.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding: EdgeInsets.only(right: 15),
                  child: FadeInLeft(child: _buildBox(index: index)));
            },
          );
  }

  Widget _buildBox({int index}) => Container(
        child: GestureDetector(
          onTap: () {
            final chatService =
                Provider.of<ChatService>(context, listen: false);
            chatService.userFor = widget.profiles[index];
            Navigator.of(context)
                .push(createRouteProfileSelect(widget.profiles[index]));
          },
          child: UserItem(profile: widget.profiles[index]),
        ),
      );
}

class Preview extends StatefulWidget {
  const Preview({
    Key key,
    @required this.profile,
  }) : super(key: key);

  final Profiles profile;

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    child: Hero(
                        tag: widget.profile.user.uid,
                        child: Material(
                          type: MaterialType.transparency,
                          child: ImageUserChat(
                            width: 100,
                            height: 100,
                            profile: widget.profile,
                            fontsize: 20,
                          ),
                        )),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 30.0,
                    top: 60.0,
                    right: 0.0,
                    child: Container(
                        child: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 80),
                              child: Text(
                                (widget.profile.user.username.length >= 10)
                                    ? widget.profile.user.username
                                            .substring(0, 7) +
                                        '...'
                                    : widget.profile.user.username,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              )),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 65),
          width: 17.0,
          height: 17.0,
          decoration: new BoxDecoration(
            color: widget.profile.user.online
                ? Colors.green[300]
                : Color(0xff969B9B),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class CarouselCategorySliderCustom extends StatefulWidget {
  const CarouselCategorySliderCustom({
    Key key,
    @required this.profiles,
  }) : super(key: key);

  final List<Profiles> profiles;

  @override
  _CarouselCategorySliderCustomState createState() =>
      _CarouselCategorySliderCustomState();
}

class _CarouselCategorySliderCustomState
    extends State<CarouselCategorySliderCustom> {
  @override
  Widget build(BuildContext context) {
    return (widget.profiles.length >= 6)
        ? CarouselSlider.builder(
            options: CarouselOptions(
              height: 100,
              viewportFraction: 0.30,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: widget.profiles.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                final chatService =
                    Provider.of<ChatService>(context, listen: false);
                chatService.userFor = widget.profiles[index];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MyProfile(
                              title: '',
                              profile: widget.profiles[index],
                            )));
              },
              child: _buildBoxCategory(index: index),
            ),
          )
        : ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: widget.profiles.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildBoxCategory(index: index);
            },
          );
  }

  Widget _buildBoxCategory({int index}) => Container(
        child: GestureDetector(
          onTap: () {
            final chatService =
                Provider.of<ChatService>(context, listen: false);
            chatService.userFor = widget.profiles[index];
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MyProfile(
                          title: '',
                          profile: widget.profiles[index],
                        )));
          },
          child:
              _BtnOption(title: 'Mas', image: 'assets/banners/cart_image.jpg'),
        ),
      );
}

class _BtnOption extends StatelessWidget {
  final String title;
  final String image;
  const _BtnOption({Key key, @required this.title, @required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Stack(
            children: <Widget>[
              Image.asset(
                image,
                height: 70.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 20,
                          blurRadius: 20,
                          offset: Offset(0, 20))
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Center(
                    child: Text(
                      this.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class UserItem extends StatefulWidget {
  const UserItem({
    Key key,
    @required this.profile,
  }) : super(key: key);

  final Profiles profile;

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                child: Container(
                  width: 100,
                  height: 100,
                  child: Hero(
                      tag: widget.profile.user.uid,
                      child: Material(
                        type: MaterialType.transparency,
                        child: ImageUserChat(
                          width: 100,
                          height: 100,
                          profile: widget.profile,
                          fontsize: 20,
                        ),
                      )),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 30.0,
                top: 60.0,
                right: 0.0,
                child: Container(
                    child: Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 80),
                          child: Text(
                            (widget.profile.user.username.length >= 10)
                                ? widget.profile.user.username.substring(0, 7) +
                                    '...'
                                : widget.profile.user.username,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, top: 65),
          width: 17.0,
          height: 17.0,
          decoration: new BoxDecoration(
            color: widget.profile.user.online
                ? Colors.green[300]
                : Color(0xff969B9B),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

Route createRouteProfileSelect(Profiles profile) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyProfile(
      title: '',
      profile: profile,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
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
