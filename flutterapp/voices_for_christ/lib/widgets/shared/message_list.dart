import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/data/playlist_class.dart';
import 'package:voices_for_christ/models/main_model.dart';
import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/widgets/shared/message_metadata.dart' as meta;
import 'package:voices_for_christ/widgets/shared/action_row_widgets.dart';

class MessageDetails extends StatefulWidget {
  const MessageDetails({ Key key, this.message, this.playingFromPlaylist }) : super(key: key);

  final Message message;
  final int playingFromPlaylist;

  @override
  _MessageDetailsState createState() => _MessageDetailsState();
}

class _MessageDetailsState extends State<MessageDetails> with TickerProviderStateMixin {
  bool _isExpanded = false;
  List<Playlist> _playlists = [];

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      vsync: this,
      duration: Duration(milliseconds: 150),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0),
              width: 0.0,
            ),
          ),
        ),
        child: _isExpanded
          ? _maximizedDetails(context, widget.message, widget.playingFromPlaylist)
          : _minimizedDetails(context, widget.message, widget.playingFromPlaylist),
        //child: isExpanded ? _maximizedDetails(context, widget.index, widget.message) : _minimizedDetails(context, widget.index, widget.message),
      ),
    );
  }

  Widget _maximizedDetails(BuildContext context, Message message, int playingFromPlaylist) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _favButton(model, message),
                  Expanded(
                    child: GestureDetector(
                      onTap: () { setState(() {_isExpanded = !_isExpanded;}); },
                      behavior: HitTestBehavior.translucent,
                      child: meta.title(context, message, false),
                    ),
                  ),
                  /*IconButton(
                    icon: Icon(Icons.keyboard_arrow_up),
                    color: Theme.of(context).splashColor,
                    enableFeedback: false,
                    onPressed: () { setState(() {_isExpanded = !_isExpanded;}); },
                  ),*/
                ],
              ),
              meta.details(context, message),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: _actionRow(context, model, message, playingFromPlaylist),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _minimizedDetails(BuildContext context, Message message, int playingFromPlaylist) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _favButton(model, message),
              Expanded(
                child: GestureDetector(
                  //onTap: () { model.playMessage(message); },
                  onTap: () { setState(() {_isExpanded = !_isExpanded;}); },
                  behavior: HitTestBehavior.translucent,
                  child: meta.title(context, message, false),
                ),
              ),
              message.isdownloaded == 1
                ? _playButton(model, message, playingFromPlaylist, false)
                : _downloadButton(model, message),
              /*IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                color: Theme.of(context).splashColor,
                enableFeedback: false,
                onPressed: () { setState(() {_isExpanded = !_isExpanded;}); },
              ),*/
            ],
          ),
        );
      }
    );
  }

  Widget _actionRow(BuildContext context, MainModel model, Message message, int playingFromPlaylist) {
    /*IconData favIcon = message.isfavorite == 1
                      ? Icons.favorite
                      : Icons.favorite_border;*/
    /*Widget _downloadOrPlay;
    if (message.isdownloaded == 1) {
      _downloadOrPlay = model.isPlaying
          ? actionRowItem(message, model.pauseMessage, 'Pause', Icons.pause, Theme.of(context).buttonColor, true)
          : actionRowItem(message, model.playMessage, 'Play', Icons.play_arrow, Theme.of(context).buttonColor, true);
    } else {
      _downloadOrPlay = message.iscurrentlydownloading == 1
        ? actionRowItem(message, null, 'Downloading', null, Theme.of(context).buttonColor, false)
        : actionRowItem(message, model.downloadMessage, 'Download', Icons.file_download, Theme.of(context).buttonColor, true);
      //_downloadOrPlay = actionRowItem(message, model.downloadMessage, 'Download', Icons.file_download, Theme.of(context).buttonColor, true);
    }*/

    Widget _playOrPause;
    if (message?.isdownloaded == 1) {
      _playOrPause = model.isPlaying && message.id == model.currentlyPlayingMessage?.id
        ? actionRowItem(message, model.pauseMessage, 'Pause', Icons.pause, Theme.of(context).buttonColor, true)
        : _playButton(model, message, playingFromPlaylist, true); //actionRowItem(message, model.playMessage, 'Play', Icons.play_arrow, Theme.of(context).buttonColor, true);
    } else {
      _playOrPause = actionRowItem(message, null, 'Play', Icons.play_arrow, Theme.of(context).disabledColor, true);
    }

    Widget _downloadOrDelete;
    if (message.isdownloaded == 1) {
      _downloadOrDelete = actionRowItem(message, model.deleteMessageDownload, 'Delete', Icons.delete, Theme.of(context).buttonColor, false);
    } else {
      _downloadOrDelete = message.iscurrentlydownloading == 1
        ? actionRowItem(message, null, 'Downloading', null, Theme.of(context).buttonColor, false)
        : actionRowItem(message, model.downloadMessage, 'Download', Icons.file_download, Theme.of(context).buttonColor, true);
    }

    Widget _setPlayedOrUnplayed = message.isplayed == 1
      ? actionRowItem(message, model.setMessageUnplayed, 'Set Unplayed', Icons.restore, Theme.of(context).buttonColor, false)
      : actionRowItem(message, model.setMessagePlayed, 'Set Played', Icons.done, Theme.of(context).buttonColor, false);

    return Row(
      children: <Widget>[
        //_downloadOrPlay,
        _playOrPause,
        actionRowDivider(context),
        actionRowItem(message, _addToPlaylist, 'Add to Playlist', Icons.playlist_add, Theme.of(context).buttonColor, false),
        actionRowDivider(context),
        _setPlayedOrUnplayed,
        actionRowDivider(context),
        _downloadOrDelete,
      ],
    );
  }

  Widget _playButton(MainModel model, Message message, int playingFromPlaylist, bool includeText) {
    bool msgIsPlaying = model.isPlaying && message.id == model.currentlyPlayingMessage?.id;
    
    BorderSide border = BorderSide(width: 2.0, color: Theme.of(context).buttonColor);
    Icon icon = msgIsPlaying
      ? Icon(Icons.pause, color: Theme.of(context).buttonColor)
      : Icon(Icons.play_arrow, color: Theme.of(context).buttonColor);

    if (includeText) {
      return Expanded(
        child: Column(
          children: <Widget>[
            RawMaterialButton(
              child: icon,
              shape: CircleBorder(side: border),
              padding: EdgeInsets.all(5.0),
              constraints: BoxConstraints(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashColor: Colors.transparent,
              onPressed: () {
                if (msgIsPlaying) {
                  model.pauseMessage(message);
                } else {
                  model.playMessage(message);
                }
                // set playlist
                if (playingFromPlaylist != null) {
                  model.setCurrentPlaylist(playingFromPlaylist);
                } else {
                  model.setCurrentPlaylist(null);
                }
              },
            ),
            RawMaterialButton(
              child: Text(msgIsPlaying ? 'Pause' : 'Play',
                style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 13.0),
              ),
              constraints: BoxConstraints(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.only(top: 4.0),
              splashColor: Colors.transparent,
              onPressed: () { 
                if (msgIsPlaying) {
                  model.pauseMessage(message);
                } else {
                  model.playMessage(message);
                }
                // set playlist
                if (playingFromPlaylist != null) {
                  model.setCurrentPlaylist(playingFromPlaylist);
                } else {
                  model.setCurrentPlaylist(null);
                }
              },
            )
          ],
        ),
      );
    }
    
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 15.0, 15.0),
      child: RawMaterialButton(
        child: icon,
        shape: CircleBorder(side: border),
        padding: EdgeInsets.all(5.0),
        constraints: BoxConstraints(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashColor: Colors.transparent,
        onPressed: () {
          if (msgIsPlaying) {
            model.pauseMessage(message);
          } else {
            model.playMessage(message);
          }
          // set playlist
          if (playingFromPlaylist != null) {
            model.setCurrentPlaylist(playingFromPlaylist);
          } else {
            model.setCurrentPlaylist(null);
          }
        },
      ),
    );
  }

  Widget _favButton(MainModel model, Message message) {
    Icon favIcon = message.isfavorite == 1
      ? Icon(Icons.star, color: Theme.of(context).textSelectionColor)
      : Icon(Icons.star_border, color: Theme.of(context).textSelectionColor);

    return IconButton(
      icon: favIcon,
      tooltip: 'Favorite',
      onPressed: () { model.toggleFavorite(message); },
      enableFeedback: false,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  Widget _downloadButton(MainModel model, Message message) {
    if (message.iscurrentlydownloading == 1) {
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 15.0, 0.0),
        child: CircularProgressIndicator(backgroundColor: Theme.of(context).buttonColor,),
      );
    }

    if (message.isdownloaded == 1) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 15.0, 15.0),
      child: actionIconButton(message, model.downloadMessage, Icons.file_download, Theme.of(context).buttonColor, true),
    );
  }

  void _addToPlaylist(Message message) async {
    final db = MessageDB.instance;
    List<Playlist> result = await db.getAllPlaylists();
    _playlists = result;

    List<Widget> _dialogOptions = [];
    for (int i = 0; i < _playlists.length; i++) {
      _dialogOptions.add(SimpleDialogOption(
        child: Text(_playlists[i].title),
        onPressed: () { 
          Navigator.of(context).pop();
          db.addMessageToPlaylist(message, _playlists[i]);
        },
      ));
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Add to Playlist'),
          children: _dialogOptions
        );
      }
    );
  }
}