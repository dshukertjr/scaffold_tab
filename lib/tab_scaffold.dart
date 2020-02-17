library tab_scaffold;

import 'package:flutter/material.dart';

/// Can open tab by calling ScaffoldTab.of(context).openTab(index)
///
/// Can open previously opened tab by calling ScaffoldTab.of(context).openPreviousTab()
///
/// ScaffoldTab contains Scaffold as its child, so can also call Scaffold.of(context)
class ScaffoldTab extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Drawer drawer;
  final Widget bottomNavigationBar;
  final List<Widget> pages;

  const ScaffoldTab({
    Key key,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    @required this.pages,
  })  : assert(pages != null),
        super(key: key);

  @override
  _ScaffoldTabState createState() => _ScaffoldTabState();

  static _InheritedScaffoldTab of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedScaffoldTab>();
  }
}

class _ScaffoldTabState extends State<ScaffoldTab> {
  int _tabIndex = 0;
  List<int> _tabHistory = [0];
  List<Widget> _pages;
  List<GlobalKey<NavigatorState>> _navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final poped = await _navigatorKeys[_tabIndex].currentState.maybePop();
        if (!poped) {
          _openPreviousTab();
        }
        return false;
      },
      child: _InheritedScaffoldTab(
        appBar: widget.appBar,
        drawer: widget.drawer,
        bottomNavigationBar: widget.bottomNavigationBar,
        pages: _pages,
        tabIndex: _tabIndex,
        parentOpenTab: _openTab,
        parentOpenPreviousTab: _openPreviousTab,
      ),
    );
  }

  void _openTab(int index) {
    if (index == _tabIndex) {
      return;
    }
    _tabHistory.add(index);
    setState(() {
      _tabIndex = index;
    });
  }

  void _openPreviousTab() {
    if (_tabHistory.length < 2) {
      return;
    }
    _tabHistory.removeLast();
    setState(() {
      _tabIndex = _tabHistory.last;
    });
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
  final PreferredSizeWidget appBar;
  final Drawer drawer;
  final Widget bottomNavigationBar;
  final List<Widget> pages;
  final void Function(int index) parentOpenTab;
  final void Function() parentOpenPreviousTab;
  final int tabIndex;

  _InheritedScaffoldTab({
    @required this.appBar,
    @required this.drawer,
    @required this.bottomNavigationBar,
    @required this.pages,
    @required this.parentOpenTab,
    @required this.parentOpenPreviousTab,
    @required this.tabIndex,
  }) : super(
            child: Scaffold(
          appBar: appBar,
          body: _ScaffoldTabChild(
            pages: pages,
            tabIndex: tabIndex,
          ),
          drawer: drawer,
          bottomNavigationBar: bottomNavigationBar,
        ));

  void openTab(int index) {
    parentOpenTab(index);
  }

  void openPreviousTab() {
    parentOpenPreviousTab();
  }

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
