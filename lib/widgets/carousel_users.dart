import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat/models/profiles.dart';
import 'package:chat/pages/user_page.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/widgets/avatar_user_chat.dart';
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
    return CarouselSlider.builder(
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
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.userFor = widget.profiles[index];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      UserPage(profile: widget.profiles[index])));
        },
        child: Preview(profile: widget.profiles[index]),
      ),
    );
  }
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
          padding: EdgeInsets.all(5),
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
                    left: 20.0,
                    top: 60.0,
                    right: 0.0,
                    child: Container(
                        child: Container(
                      margin: EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Container(
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
