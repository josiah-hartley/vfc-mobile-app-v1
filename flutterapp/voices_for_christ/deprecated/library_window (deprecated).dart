import 'package:flutter/material.dart';
//import 'package:voices_for_christ/widgets/library_window/favorites_list.dart';
//import 'package:voices_for_christ/widgets/library_window/downloads_list.dart';

class LibraryWindow extends StatefulWidget {
  const LibraryWindow({ Key key }) : super(key: key);

  @override
  _LibraryWindowState createState() => _LibraryWindowState();
}

class _LibraryWindowState extends State<LibraryWindow> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          _tabBar(context),
          _body(),
        ],
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          _tabBarItem(context, 0, 'Starred', Icons.star),
          _tabBarItem(context, 1, 'Playlists', Icons.playlist_play),
          _tabBarItem(context, 2, 'Downloaded', Icons.file_download),
        ],
      ),
    );
  }

  Widget _tabBarItem(BuildContext context, int tabIndex, String text, IconData icon) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: tabIndex == _tabIndex ? Theme.of(context).secondaryHeaderColor : Colors.transparent,
            width: 3.0,
          ))
        ),
        child: InkWell(
          onTap: () {_switchTabs(tabIndex);},
          child: Center(child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: <Widget>[
                Icon(icon,
                  color: tabIndex == _tabIndex ? Theme.of(context).secondaryHeaderColor : Theme.of(context).secondaryHeaderColor.withOpacity(0.7),
                ),
                Text(text,
                  style: TextStyle(
                    color: tabIndex == _tabIndex ? Theme.of(context).secondaryHeaderColor : Theme.of(context).secondaryHeaderColor.withOpacity(0.7),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),),
        ),
      ),
    );
  }

  Widget _body() {
    switch(_tabIndex) {
      //case 0: return FavoritesList();
      //case 2: return DownloadsList();
      default: return Container(child: Text('Nothing here yet'));
    }
  }

  void _switchTabs(int index) {
    setState(() {
      _tabIndex = index;
    });
  }
}