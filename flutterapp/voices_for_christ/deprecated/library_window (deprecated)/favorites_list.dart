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
  List<Message> _favorites = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return _favoritesList();
  }

  Widget _favoritesList() {
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
              ? Text('')
              : Text('No starred messages'),
          ),
        );
  }

  void loadFavorites() async {
    setState(() {
      _isLoading = true;
    });
    final db = MessageDB.instance;
    List<Message> result = await db.queryFavorites();
    setState(() {
      _favorites = result;
      _isLoading = false;
    });
  }
}