import 'package:flutter/material.dart';
import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/widgets/shared/message_list.dart';

class DownloadsList extends StatefulWidget {
  const DownloadsList({ Key key }) : super(key: key);

  @override
  _DownloadsListState createState() => _DownloadsListState();
}

class _DownloadsListState extends State<DownloadsList> {
  int _tabIndex = 0;
  List<Message> _downloads = [];
  List<Message> _unplayedDownloads = [];
  List<Message> _playedDownloads = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadDownloads();
  }

  @override
  Widget build(BuildContext context) {
    //return _downloadsList();
    return Expanded(
      child: Column(
        children: <Widget>[
          _tabBar(context),
          _downloadsList(),
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

  Widget _downloadsList() {
    List<Message> downloads;
    switch(_tabIndex) {
      case 0:
        downloads = _downloads;
        break;
      case 1:
        downloads = _unplayedDownloads;
        break;
      case 2:
        downloads = _playedDownloads;
        break;
      default:
        downloads = _downloads;
    }

    return downloads.length > 0
      ? Expanded(
          child: ListView.builder(
            itemCount: downloads.length,
            itemBuilder: (context, index) {
              return MessageDetails(message: downloads[index]);
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
    loadDownloads();
    setState(() {
      _tabIndex = index;
    });
  }

  /*Widget _downloadsList() {
    return _downloads.length > 0
      ? Expanded(
          child: ListView.builder(
            itemCount: _downloads.length,
            itemBuilder: (context, index) {
              return MessageDetails(message: _downloads[index]);
            },
          ),
        )
      : Expanded(
          child: Center(
            child: _isLoading
              ? CircularProgressIndicator()
              : Text('No messages downloaded'),
          ),
        );
  }*/

  void loadDownloads() async {
    setState(() {
      _isLoading = true;
    });
    final db = MessageDB.instance;
    List<Message> result = await db.queryDownloads();
    setState(() {
      _downloads = result;
      _playedDownloads = result.where((f) => f.isplayed == 1).toList();
      _unplayedDownloads = result.where((f) => f.isplayed != 1).toList();
      _isLoading = false;
    });
  }
}