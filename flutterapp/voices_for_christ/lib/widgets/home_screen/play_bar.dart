import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/models/main_model.dart';
import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/data/playlist_class.dart';
import 'package:voices_for_christ/widgets/shared/action_row_widgets.dart';
import 'package:voices_for_christ/widgets/shared/message_metadata.dart';

class ClosedPlayBar extends StatefulWidget {
  const ClosedPlayBar({ Key key, this.togglePanel }) : super(key: key);

  final Function togglePanel;

  @override
  _ClosedPlayBarState createState() => _ClosedPlayBarState();
}

class _ClosedPlayBarState extends State<ClosedPlayBar> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          if (model.currentlyPlayingMessage != null) {
            return Dismissible(
              key: Key('playbar'),
              onDismissed: (direction) {
                model.playerPauseMessage(model.currentlyPlayingMessage);
                model.closePlayBar();
                model.closeNotification();
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 13.0,),
                    Center(
                      child: Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor.withOpacity(0.4),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                      ),
                    ),
                    _collapsed(model),
                  ],
                ),
                //child: _collapsed(model),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.0,
                    ),
                    bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
            );
          }
          return SizedBox(height: 0.0,);
        }
    );
  }

  Widget _collapsed(MainModel model) {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () { widget.togglePanel(); },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(model.currentlyPlayingMessage == null ? '' : model.currentlyPlayingMessage.title,
                  overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  Text(model.currentlyPlayingMessage == null ? '' : reversedName(model.currentlyPlayingMessage.speaker),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  //_slider(model),
                ],
              ),
            ),
          ),
        ),
        _favButton(context, model),
        _playPauseButton(context, model),
      ],
    );
  }
}

class OpenPlayBar extends StatefulWidget {
  const OpenPlayBar({ Key key, this.togglePanel }) : super(key: key);

  final Function togglePanel;

  @override
  _OpenPlayBarState createState() => _OpenPlayBarState();
}

class _OpenPlayBarState extends State<OpenPlayBar> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          if (model.currentlyPlayingMessage != null) {
            return Dismissible(
              key: Key('playbar'),
              onDismissed: (direction) {
                model.playerPauseMessage(model.currentlyPlayingMessage);
                model.closePlayBar();
                model.closeNotification();
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 13.0,),
                    Center(
                      child: Container(
                        width: 30,
                        height: 5,
                        decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor.withOpacity(0.4),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                      ),
                    ),
                    _expandedPortrait(model),
                  ],
                ),
                //child: _expandedPortrait(model),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.0,
                    ),
                    bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.0,
                    ),
                  ),
                ),
              ),
            );
          }
          return SizedBox(height: 0.0,);
        }
    );
  }

  Widget _expandedPortrait(MainModel model) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () { widget.togglePanel(); },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(25.0, 60.0, 25.0, 10.0),
                      child: Text(model.currentlyPlayingMessage == null ? '' : model.currentlyPlayingMessage.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(model.currentlyPlayingMessage == null ? '' : reversedName(model.currentlyPlayingMessage.speaker),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _slider(context, model, 10.0),
              _playbackControls(context, model, 20.0, 30.0, false),
              _additionalButtons(context, model),
            ],
          ),
        )
      ],
    );
  }

  /*Widget _expandedLandscape(MainModel model) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () { widget.togglePanel(); },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
                child: Text(model.currentlyPlayingMessage.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Text(model.currentlyPlayingMessage.speaker,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () { widget.togglePanel(); },
                ),
              ),
            ],
          ),
        ),
        _slider(model, 0.0),
        _playbackControls(model, 0.0, 5.0, true),
      ],
    );
  }*/

  

  
}

Widget _favButton(BuildContext context, MainModel model) {
  IconData favIcon = model.currentlyPlayingMessage?.isfavorite == 1
    ? Icons.star
    : Icons.star_border;

  return Container(
    child: actionIconButton(model.currentlyPlayingMessage, model.toggleFavorite, favIcon, Theme.of(context).secondaryHeaderColor, false),
  );
}

Widget _slider(BuildContext context, MainModel model, double verticalPadding) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: verticalPadding),
    child: Column(
      children: <Widget>[
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).secondaryHeaderColor,
            inactiveTrackColor: Theme.of(context).secondaryHeaderColor.withOpacity(0.25),
            trackHeight: 3.0,
            thumbColor: Theme.of(context).secondaryHeaderColor,
          ),
          child: Slider(
            min: 0.0,
            max: model.currentlyPlayingMessage == null ? 0.0 : model.currentlyPlayingMessage.durationinseconds,
            value: model.currentPlayPosition == null || model.currentlyPlayingMessage?.durationinseconds == null
              ? 0
              : model.currentPlayPosition.inSeconds.toDouble() < model.currentlyPlayingMessage?.durationinseconds
                ? model.currentPlayPosition.inSeconds.toDouble()
                : 0,
            onChanged: (double val) {
              model.seekToSecond(val.toInt());
            },
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(model.currentPlayPosition == null ? '0' : durationInMinutes(model.currentPlayPosition.inSeconds.toDouble()),
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor)
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Text(durationInMinutes(model.currentlyPlayingMessage?.durationinseconds),
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor)
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
}

Widget _playbackControls(BuildContext context, MainModel model, double topPadding, double bottomPadding, bool includeExtras) {
  Function playPauseAction = model.isPlaying ? model.pauseMessage : model.playMessage;
  IconData playPauseIcon = model.isPlaying ? Icons.pause : Icons.play_arrow;

  List<Widget> _children = [
    actionRowItem(model.currentlyPlayingMessage, model.seekBackFifteen, '15 sec', Icons.fast_rewind, Theme.of(context).secondaryHeaderColor, false),
    Expanded(
      child: RawMaterialButton(
        child: Icon(playPauseIcon, color: Theme.of(context).secondaryHeaderColor, size: 50.0),
        shape: CircleBorder(
          side: BorderSide(width: 2.0, color: Theme.of(context).secondaryHeaderColor),
        ),
        padding: EdgeInsets.all(9.0),
        constraints: BoxConstraints(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashColor: Colors.transparent,
        onPressed:  () { playPauseAction(model.currentlyPlayingMessage); },
      ),
    ),
    actionRowItem(model.currentlyPlayingMessage, model.seekForwardFifteen, '15 sec', Icons.fast_forward, Theme.of(context).secondaryHeaderColor, false),
  ];

  if (includeExtras) {
    _children.add(
      Expanded(
        child: _favButton(context, model),
      ),
    );
    _children.add(
      Expanded(
        child: actionIconButton(model.currentlyPlayingMessage, _addToPlaylist, Icons.playlist_add, Theme.of(context).secondaryHeaderColor, false),
      ),
    );

    if (model.currentPlaylistId != null) {
      _children.add(
        Expanded(
          child: actionIconButton(model.currentlyPlayingMessage, model.playNextMessageInPlaylist, Icons.skip_next, Theme.of(context).secondaryHeaderColor, false)
        ),
      );
    }
  }

  return Container(
    padding: EdgeInsets.fromLTRB(0.0, topPadding, 0.0, bottomPadding),
    child: Row(
      children: _children,
    ),
  );
}

Widget _playPauseButton(BuildContext context, MainModel model) {
  Function action = model.isPlaying ? model.pauseMessage : model.playMessage;
  IconData icon = model.isPlaying ? Icons.pause : Icons.play_arrow;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.0),
    child: actionIconButton(model.currentlyPlayingMessage, action, icon, Theme.of(context).secondaryHeaderColor, true)
  );
}

Widget _additionalButtons(BuildContext context, MainModel model) {
  List<Widget> _children = [
    Expanded(
      child: _favButton(context, model),
    ),
    Expanded(
      child: RawMaterialButton(
        child: Icon(Icons.playlist_add, color: Theme.of(context).secondaryHeaderColor, size: 25.0),
        shape: CircleBorder(side: BorderSide(width: 2.0, color: Colors.transparent)),
        padding: EdgeInsets.all(4.0),
        constraints: BoxConstraints(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashColor: Colors.transparent,
        onPressed: () { _addToPlaylist(context, model.currentlyPlayingMessage); },
      )
    ),
  ];
  if (model.currentPlaylistId != null) {
    _children.add(
      Expanded(
        child: actionIconButton(model.currentlyPlayingMessage, model.playNextMessageInPlaylist, Icons.skip_next, Theme.of(context).secondaryHeaderColor, false)
      ),
    );
  }

  return Container(
    padding: EdgeInsets.only(bottom: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _children,
    ),
  );
}

void _addToPlaylist(BuildContext context, Message message) async {
  final db = MessageDB.instance;
  List<Playlist> result = await db.getAllPlaylists();

  List<Widget> _dialogOptions = [];
  for (int i = 0; i < result.length; i++) {
    _dialogOptions.add(SimpleDialogOption(
      child: Container(
        child: Text(result[i].title,
          style: TextStyle(
            fontSize: 16.0
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.0),
      ),
      onPressed: () { 
        Navigator.of(context).pop();
        db.addMessageToPlaylist(message, result[i]);
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