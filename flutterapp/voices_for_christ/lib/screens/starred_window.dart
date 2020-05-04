import 'package:flutter/material.dart';
import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/widgets/shared/message_list.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({ Key key }) : super(key: key);

  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  int _tabIndex = 0;
  List<Message> _favorites = [];
  List<Message> _unplayedFavorites = [];
  List<Message> _playedFavorites = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    //return _favoritesList();
    return Expanded(
      child: Column(
        children: <Widget>[
          _tabBar(context),
          _favoritesList(),
        ],
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          _tabBarItem(context, 0, 'All'),
          _tabBarItem(context, 1, 'Unplayed'),
          _tabBarItem(context, 2, 'Played'),
        ],
      ),
    );
  }

  Widget _tabBarItem(BuildContext context, int tabIndex, String text) {
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
            child: Text(text,
              style: TextStyle(
                color: tabIndex == _tabIndex ? Theme.of(context).secondaryHeaderColor : Theme.of(context).secondaryHeaderColor.withOpacity(0.7),
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),),
        ),
      ),
    );
  }

  Widget _favoritesList() {
    List<Message> favs;
    switch(_tabIndex) {
      case 0:
        favs = _favorites;
        break;
      case 1:
        favs = _unplayedFavorites;
        break;
      case 2:
        favs = _playedFavorites;
        break;
      default:
        favs = _favorites;
    }

    return favs.length > 0
      ? Expanded(
          child: ListView.builder(
            itemCount: favs.length,
            itemBuilder: (context, index) {
              return MessageDetails(message: favs[index]);
            },
          ),
        )
      : Expanded(
          child: Center(
            child: _isLoading
              ? CircularProgressIndicator()
              : Text('Nothing here yet'),
          ),
        );
  }

  void _switchTabs(int index) {
    loadFavorites();
    setState(() {
      _tabIndex = index;
    });
  }

  /*Widget _favoritesList() {
    return _favorites.length > 0
      ? Expanded(
          child: ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              return MessageDetails(message: _favorites[index]);
            },
          ),
        )
      : Expanded(
          child: Center(
            child: _isLoading
              ? CircularProgressIndicator()
              : Text('No starred messages'),
          ),
        );
  }*/

  void loadFavorites() async {
    setState(() {
      _isLoading = true;
    });
    final db = MessageDB.instance;
    List<Message> result = await db.queryFavorites();
    setState(() {
      _favorites = result;
      _playedFavorites = result.where((f) => f.isplayed == 1).toList();
      _unplayedFavorites = result.where((f) => f.isplayed != 1).toList();
      _isLoading = false;
    });
  }
}