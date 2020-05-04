import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:voices_for_christ/models/main_model.dart';
import 'package:voices_for_christ/screens/search_window.dart';
import 'package:voices_for_christ/screens/starred_window.dart';
import 'package:voices_for_christ/screens/downloads_window.dart';
import 'package:voices_for_christ/screens/playlists_window.dart';
import 'package:voices_for_christ/widgets/home_screen/app_bar.dart';
import 'package:voices_for_christ/widgets/home_screen/play_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key key, this.theme, this.setTheme }) : super(key: key);

  final String theme;
  final Function setTheme;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  String title = 'Search Messages';
  PanelController playbarController = PanelController();

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title),
      drawer: menuDrawer(context, widget.theme, widget.setTheme),
      body: Center(
        child: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _body(pageIndex),
                PlayBar(),
              ],
            );
          }
        ),
      ),
      bottomNavigationBar: _bottomNav(context, pageIndex),
    );
  }*/

  @override
  Widget build(BuildContext homecontext) {
    return Scaffold(
      appBar: appBar(homecontext, title, widget.theme, widget.setTheme),
      //drawer: menuDrawer(homecontext, widget.theme, widget.setTheme),
      body: Center(
        child: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            return SlidingUpPanel(
              minHeight: model.currentlyPlayingMessage == null ? 0.0 : 75.0,
              maxHeight: model.currentlyPlayingMessage == null ? 0.0 : 450.0,
              controller: playbarController,
              backdropEnabled: true,
              collapsed: ClosedPlayBar(togglePanel: togglePlaybar,),
              panel: OpenPlayBar(togglePanel: togglePlaybar),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _body(pageIndex, homecontext),
                    SizedBox(height: 130),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _bottomNav(homecontext, pageIndex),
    );
  }

  void togglePlaybar() {
    if (playbarController.isPanelOpen) {
      playbarController.close();
    } else {
      playbarController.open();
    }
  }

  Widget _body(int pageIndex, BuildContext homecontext) {
    switch (pageIndex) {
      case 0:
        return SearchWindow(parentContext: homecontext);
      case 1:
        return FavoritesList();
      case 2:
        return LibraryWindow();
      case 3:
        return DownloadsList();
      default:
        return SearchWindow();
    }
  }

  Widget _bottomNav(BuildContext context, int pageIndex) {
    return BottomNavigationBar(
      currentIndex: pageIndex,
      onTap: _tapBottomNav,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('Search')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          title: Text('Favorites')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play),
          title: Text('Playlists')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.file_download),
          title: Text('Downloads')
        ),
      ],
      selectedItemColor: Theme.of(context).selectedRowColor,
      elevation: 0,
      backgroundColor: Theme.of(context).bottomAppBarColor,
      type: BottomNavigationBarType.fixed,
    );
  }

  void _tapBottomNav(int index) {
    setState(() {
      pageIndex = index;
      title = _getPageTitle(index);
    });
  }

  String _getPageTitle(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return 'Search Messages';
      case 1:
        return 'Favorites';
      case 2:
        return 'Playlists';
      case 3:
        return 'Downloaded Messages';
      default:
        return 'Voices for Christ';
    }
  }
}