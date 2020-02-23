library tab_scaffold;

import 'package:flutter/material.dart';

/// Can open tab by calling ScaffoldTab.of(context).openTab(index)
///
/// Can open previously opened tab by calling ScaffoldTab.of(context).openPreviousTab()
///
/// ScaffoldTab contains Scaffold as its child, so can also call Scaffold.of(context)
class ScaffoldTab extends StatefulWidget {
  final int tabIndex;
  final PreferredSizeWidget appBar;
  final Drawer drawer;
  final Widget bottomNavigationBar;
  final List<Widget> pages;
  final bool extendBody;

  const ScaffoldTab({
    Key key,
    @required this.tabIndex,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    @required this.pages,
    this.extendBody,
  })  : assert(pages != null),
        super(key: key);

  @override
  _ScaffoldTabState createState() => _ScaffoldTabState();

  static _InheritedScaffoldTab of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedScaffoldTab>();
  }
}

class _ScaffoldTabState extends State<ScaffoldTab> {
  List<Widget> _pages;
  List<GlobalKey<NavigatorState>> _navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigatorKeys[widget.tabIndex].currentState.maybePop();
        return false;
      },
      child: _InheritedScaffoldTab(
        appBar: widget.appBar,
        drawer: widget.drawer,
        bottomNavigationBar: widget.bottomNavigationBar,
        pages: _pages,
        tabIndex: widget.tabIndex,
        extendBody: widget.extendBody,
      ),
    );
  }

  @override
  void initState() {
    _navigatorKeys = widget.pages
        .map<GlobalKey<NavigatorState>>((page) => GlobalKey<NavigatorState>())
        .toList();
    _pages = List.generate(
        widget.pages.length, (index) => _navigatorWrappedPage(index));
    super.initState();
  }

  Widget _navigatorWrappedPage(int index) {
    final Map<String, WidgetBuilder> routes = {
      'home': (context) => widget.pages[index],
    };
    return Navigator(
      key: _navigatorKeys[index],
      initialRoute: 'home',
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => routes[routeSettings.name](context));
      },
    );
  }
}

class _InheritedScaffoldTab extends InheritedWidget {
  _InheritedScaffoldTab({
    @required AppBar appBar,
    @required Drawer drawer,
    @required Widget bottomNavigationBar,
    @required List<Widget> pages,
    @required int tabIndex,
    bool extendBody,
  }) : super(
            child: Scaffold(
          appBar: appBar,
          body: _ScaffoldTabChild(
            pages: pages,
            tabIndex: tabIndex,
          ),
          drawer: drawer,
          bottomNavigationBar: bottomNavigationBar,
          extendBody: extendBody ?? false,
        ));

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class _ScaffoldTabChild extends StatelessWidget {
  final List<Widget> pages;
  final int tabIndex;

  _ScaffoldTabChild({
    Key key,
    @required this.pages,
    @required this.tabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: tabIndex,
      children: pages,
    );
  }
}
