/* import 'package:chat/models/room.dart';
import 'package:chat/pages/form_new_product.dart';
import 'package:chat/pages/profile_page.dart';

import 'package:chat/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:photo_manager/photo_manager.dart';

class NewProductPage extends StatefulWidget {
  final Room room;
  NewProductPage({@required this.room});

  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  int currentPage = 0;
  int lastPage;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Scaffold(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            title: Text(
              'New Product',
              style: TextStyle(),
            ),
            backgroundColor: Colors.black,
            actions: [
              GestureDetector(
                onTap: () =>
                    Navigator.pushReplacement(context, createRouteNewProduct()),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: currentTheme.accentColor, fontSize: 18),
                  ),
                ),
              )
            ],
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: currentTheme.accentColor,
              ),
              iconSize: 30,
              onPressed: () =>
                  //  Navigator.pushReplacement(context, createRouteProfile()),
                  Navigator.pop(context),
              color: Colors.white,
            )),
        body: MediaGrid());
  }
}

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<Widget> _mediaList = [];
  int currentPage = 0;
  int lastPage;
  List<AssetEntity> itemList;
  List<AssetEntity> selectedList;

  @override
  void initState() {
    loadList();
    super.initState();
    _fetchNewMedia();
  }

  loadList() {
    itemList = [];
    selectedList = [];
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);

      List<AssetEntity> media =
          await albums[0].getAssetListPaged(currentPage, 60);

      List<Widget> temp = [];
      for (var item in media) {
        temp.add(ImageItem(
            item: item,
            isSelected: (bool value) {
              setState(() {
                if (value) {
                  selectedList.add(item);
                } else {
                  selectedList.remove(item);
                }
              });
            }));
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: _mediaList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return _mediaList[index];
                }),
          ),
          /* Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(right: 5, bottom: 5),
                child: GestureDetector(
                  onTap: () => _fetchNewMedia(),
                  child: Text(
                    'Chosse selec',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ), */
        ],
      ),
    );
  }
}

class ImageItem extends StatefulWidget {
  const ImageItem({Key key, @required this.item, this.isSelected})
      : super(key: key);

  final AssetEntity item;
  final ValueChanged<bool> isSelected;

  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: FutureBuilder(
        future: widget.item.thumbDataWithSize(200, 200),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.memory(
                    snapshot.data,
                    fit: BoxFit.cover,
                  ),
                ),
                isSelected
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            width: 30,
                            height: 30,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              child: CircleAvatar(
                                  child: Center(
                                    child: Icon(Icons.check,
                                        size: 20, color: Colors.white),
                                  ),
                                  backgroundColor: Colors.blue),
                            )),
                      )
                    : Container(),
                if (widget.item.type == AssetType.video)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5, bottom: 5),
                      child: Icon(
                        Icons.videocam,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            );
          return Container();
        },
      ),
    );
  }
}

Route createRouteProfile() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SliverAppBarProfilepPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1.0, 0.0);
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

Route createRouteNewProduct() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        FormNewProductPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(-1.0, 0.0);
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
 */
