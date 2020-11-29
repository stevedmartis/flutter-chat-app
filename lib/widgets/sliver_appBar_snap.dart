import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/header_custom_search.dart';
import 'package:chat/widgets/sliver_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SliverAppBarSnap extends StatefulWidget {
  SliverAppBarSnap({@required this.user});

  final User user;

  @override
  _SliverAppBarSnapState createState() => _SliverAppBarSnapState();
}

class _SliverAppBarSnapState extends State<SliverAppBarSnap> {
  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  bool isEmpty = false;

  AuthService authService;

  @override
  void initState() {
    this.authService = Provider.of<AuthService>(context, listen: false);

    super.initState();
  }

  SliverPersistentHeader makeHeaderTabs(context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: DefaultTabController(
          length: 6,
          child: Container(
            color: Colors.black,
            child: TabBar(
                indicatorWeight: 1.0,
                indicatorColor: currentTheme.accentColor,
                tabs: [
                  Tab(icon: Icon(Icons.menu)),
                  Tab(icon: Icon(Icons.my_location)),
                  Tab(icon: Icon(Icons.my_location)),
                  Tab(icon: Icon(Icons.my_location)),
                  Tab(icon: Icon(Icons.my_location)),
                  Tab(icon: Icon(Icons.my_location)),
                ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context).currentTheme;
    //final userFor = authService.user;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.forward),
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            isEmpty = !isEmpty;
          });
        },
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          _snapAppbar();
          print('${_controller.offset}');
          if (_controller.offset > 180) {}
          return false;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          controller: _controller,
          slivers: [
            SliverAppBar(
              leading: Container(
                margin: EdgeInsets.only(left: 20),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: currentTheme.accentColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              backgroundColor: Colors.black,
              title: CustomSliverAppBarHeader(user: widget.user),
              pinned: true,
              stretch: true,
              flexibleSpace: Header(
                user: widget.user,
                maxHeight: 250,
                minHeight: 250,
              ),
              expandedHeight: 250,
            ),
            makeHeaderTabs(context),
            if (!isEmpty)
              SliverFixedExtentList(
                itemExtent: 150.0,
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildCard(index);
                  },
                ),
              )
            else
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "List is empty",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Card _buildCard(int index) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Text("Item $index"),
      ),
    );
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
