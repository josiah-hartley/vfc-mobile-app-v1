import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voices_for_christ/models/main_model.dart';
import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/data/playlist_class.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/widgets/shared/message_list.dart';

class LibraryWindow extends StatefulWidget {
  const LibraryWindow({ Key key }) : super(key: key);

  @override
  _LibraryWindowState createState() => _LibraryWindowState();
}

class _LibraryWindowState extends State<LibraryWindow> {
  int _currentPlaylistIndex = 0;
  Playlist _currentPlaylist;
  List<Playlist> _playlists = [];
  //List<Message> _messagesInCurrentPlaylist = [];
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllPlaylists();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Expanded(
          child: Column(
            children: <Widget>[
              _controls(context, model),
              Expanded(
                child: ListView.builder(
                  itemCount: _currentPlaylist == null ? 0 : _currentPlaylist.messages.length,
                  itemBuilder: (context, index) {
                    return MessageDetails(message: _currentPlaylist?.messages[index], playingFromPlaylist: _currentPlaylist.id);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    
  }

  Widget _controls(BuildContext context, MainModel model) {
    List<DropdownMenuItem<int>> _dropdownItems = [];
    for (int i = 0; i < _playlists.length; i++) {
      _dropdownItems.add(DropdownMenuItem<int>(
        value: i,
        child: Text(_playlists[i].title),
      ));
    }

    List<Widget> _controls = [
      FlatButton(
        child: Text('New Playlist'),
        onPressed: createNewPlaylist,
      ),
    ];

    List<PopupMenuEntry<int>> _overflowOptions = [
      PopupMenuItem(
        value: 0,
        child: Text('Edit play order'),
      ),
      PopupMenuItem(
        value: 1,
        child: Text('Set all played'),
      ),
      PopupMenuItem(
        value: 2,
        child: Text('Set all unplayed'),
      ),
      PopupMenuItem(
        value: 3,
        child: Text('Download all'),
      ),
      PopupMenuItem(
        value: 4,
        child: Text('Delete all downloads'),
      ),
    ];
    if (_currentPlaylist?.title != 'Saved for Later' && _currentPlaylist?.title != 'Now Playing') {
      _overflowOptions.add(
        PopupMenuItem(
          value: 5,
          child: Text('Delete playlist'),
        ),
      );
    }

    _controls.add(
      PopupMenuButton<int>(
        itemBuilder: (context) => _overflowOptions,
        onSelected: (value) {
          switch (value) {
            case 0:
              openSortingDialog(context);
              break;
            case 1:
              setAllPlayed(model);
              break;
            case 2:
              setAllUnplayed(model);
              break;
            case 3:
              downloadAll(model);
              break;
            case 4:
              deleteAllDownloads(model);
              break;
            case 5:
              confirmDeletingPlaylist(context);
              break;
          }
        },
      ),
    );

    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: DropdownButton<int>(
                isExpanded: true,
                value: _currentPlaylistIndex,
                hint: Text('Saved for Later'),
                /*items: _playlists.map<DropdownMenuItem<Playlist>>((Playlist playlist) {
                  return DropdownMenuItem<Playlist>(
                    value: playlist,
                    child: Text(playlist.title),
                  );
                }).toList(),*/
                items: _dropdownItems,
                onChanged: (int newValue) {
                  loadSinglePlaylist(newValue, model);
                },
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _controls,
              ),
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }

  void setAllPlayed(MainModel model) {
    for (Message message in _currentPlaylist.messages) {
      model.setMessagePlayed(message);
    }
  }

  void setAllUnplayed(MainModel model) {
    for (Message message in _currentPlaylist.messages) {
      model.setMessageUnplayed(message);
    }
  }

  void downloadAll(MainModel model) {
    for (Message message in _currentPlaylist.messages) {
      model.downloadMessage(message);
    }
  }

  void deleteAllDownloads(MainModel model) {
    for (Message message in _currentPlaylist.messages) {
      model.deleteMessageDownload(message);
    }
  }

  void openSortingDialog(BuildContext context) async {
    final db = MessageDB.instance;

    List<Widget> _reorderableItems = [];
    for (final message in _currentPlaylist.messages) {
      _reorderableItems.add(
        ListTile(
          key: ValueKey(message),
          title: Text(message.title),
        ),
      );
    }

    final List<Message> reorderedList = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReorderDialog(messages: _currentPlaylist.messages);
      }
    );

    if (reorderedList != null) {
      setState(() {
        _currentPlaylist.messages = reorderedList;
      });
      await db.reorderAllMessagesInPlaylist(_currentPlaylist, reorderedList);
    }
    
  }

  void confirmDeletingPlaylist(BuildContext context) {
    final db = MessageDB.instance;

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Delete Playlist: ${_currentPlaylist.title}'),
          content: Text('Are you sure you want to delete this playlist?  Action cannot be undone.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await db.deletePlaylist(_currentPlaylist);
                loadAllPlaylists();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  
  }

  void loadAllPlaylists() async {
    final db = MessageDB.instance;
    List<Playlist> result = await db.getAllPlaylists();

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int lastViewedPlaylistId = _prefs.getInt('lastViewedPlaylistId');
    int lastViewedPlaylistIndex = result.indexWhere((p) => p.id == lastViewedPlaylistId);

    if (lastViewedPlaylistIndex > -1) {
      setState(() {
        _playlists = result;
        _currentPlaylistIndex = lastViewedPlaylistIndex;
      });
    } else {
      setState(() {
        _playlists = result;
        _currentPlaylistIndex = 0;
      });
    }
    
    if (result.length > 0) {
      loadSinglePlaylist(_currentPlaylistIndex);
    }
  }

  void loadSinglePlaylist(int index, [MainModel model]) async {
    final db = MessageDB.instance;
    Playlist playlist = _playlists[index];
    List<Message> result = await db.getMessagesOnPlaylist(playlist);

    setState(() {
      _currentPlaylistIndex = index;
      _currentPlaylist = playlist;
      _currentPlaylist.messages = result;
    });

    if (model != null) {
      model.setLastViewedPlaylist(playlist.id);
    }
  }

  void createNewPlaylist() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('New Playlist'),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: titleController,
                onEditingComplete: () { 
                  saveNewPlaylist(context, titleController.text);
                },
                decoration: InputDecoration(
                  fillColor: Theme.of(context).canvasColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).hoverColor,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Theme.of(context).unselectedWidgetColor,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  FlatButton(
                    child: Text('Save'),
                    onPressed: () { 
                      saveNewPlaylist(context, titleController.text);
                    },
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () { 
                      Navigator.of(context).pop();
                      titleController.text = '';
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  void saveNewPlaylist(BuildContext context, String title) async {
    final db = MessageDB.instance;
    Navigator.of(context).pop();
    await db.newPlaylist(titleController.text);
    loadAllPlaylists();
    titleController.text = '';
  }
}

class ReorderDialog extends StatefulWidget {
  const ReorderDialog({ Key key, this.messages }) : super(key: key);

  final List<Message> messages;

  @override
  _ReorderDialogState createState() => _ReorderDialogState();
}

class _ReorderDialogState extends State<ReorderDialog> {
  List<Message> _reorderedList;

  @override
  void initState() {
    super.initState();
    _reorderedList = List.from(widget.messages);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.0),
        child: Column(
          children: <Widget>[
            Text('Long Press and Drag to Reorder',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('Swipe to Delete',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              child: Container(
                child: ReorderableListView(
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final Message item = _reorderedList.removeAt(oldIndex);
                      _reorderedList.insert(newIndex, item);
                    });
                  },
                  children: List.generate(_reorderedList.length ?? 0, (index) {
                    /*return ListTile(
                      key: Key('$index'),
                      title: Text(_reorderedList[index].title),
                    );*/
                    return Dismissible(
                      key: Key('$index d'),
                      onDismissed: (direction) {
                        setState(() {
                          _reorderedList.removeAt(index);
                        });
                      },
                      child: ListTile(
                        key: Key('$index'),
                        title: Text(_reorderedList[index].title),
                        subtitle: Text(_reorderedList[index].speaker),
                      ),
                    );
                  }),
                )
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 18.0),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text('Save'),
                    onPressed: () => Navigator.of(context).pop(_reorderedList),
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(null),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}