import 'package:scoped_model/scoped_model.dart';
import 'package:phone_state_i/phone_state_i.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/data/cloud_database.dart' as cloud;
import 'package:voices_for_christ/data/playlist_class.dart';
import 'package:voices_for_christ/models/notification_model.dart';
//import 'package:voices_for_christ/models/bluetooth_model.dart';
import 'package:voices_for_christ/models/search_model.dart';
import 'package:voices_for_christ/models/player_model.dart';
import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/data/download_mp3.dart' as dl;

class MainModel extends Model with NotificationModel, SearchModel, PlayerModel {
  int _currentPlaylistId;
  int _lastViewedPlaylistId;
  final db = MessageDB.instance;

  int get currentPlaylistId => _currentPlaylistId;
  int get lastViewedPlaylistId => _lastViewedPlaylistId;

  Future onSelectNotification(String payload) async {
    if (isPlaying) {
      pauseMessage(currentlyPlayingMessage);
    } else {
      playMessage(currentlyPlayingMessage);
    }
  }

  void onCompletedPlaying() {
    setMessagePlayed(currentlyPlayingMessage);
    closeNotification();

    if (_currentPlaylistId != null) {
      playNextMessageInPlaylist(currentlyPlayingMessage);
    } else {
      closePlayBar();
    }
  }
  
  void initialize() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _currentPlaylistId = _prefs.getInt('currentPlaylistId');
    _lastViewedPlaylistId = _prefs.getInt('lastViewedPlaylistId');

    initializeNotifications(onSelectNotification);
    //initializeBluetooth();
    initializeCallListener();
    initializePlayer(onCompletedPlaying);

    loadMOTM();

    checkForUpdates();
  }

  void checkForUpdates() async {
    int lastUpdated = await db.getLastUpdatedDate();
    int now = DateTime.now().millisecondsSinceEpoch;
    int days = (now - lastUpdated) ~/ 1000 ~/ 3600 ~/ 24;

    if (days > 7) {
      // check for updates weekly
      cloud.getMessageDataFromCloud(onDataLoaded, null);
    }
  }

  void onDataLoaded(var context) {
    print('Successfully saved message data from Firestore');
  }

  void toggleFavorite(Message message) async {
    //final db = MessageDB.instance;
    await db.toggleFavorite(message);
    notifyListeners();
  }

  void setMessagePlayed(Message message) async {
    //final db = MessageDB.instance;
    await db.setPlayed(message);
    notifyListeners();
  }

  void setMessageUnplayed(Message message) async {
    //final db = MessageDB.instance;
    await db.setUnplayed(message);
    notifyListeners();
  }

  void downloadMessage(Message message) async {
    if (message.isdownloaded == 1) {
      return;
    }

    message.iscurrentlydownloading = 1;
    notifyListeners();

    try {
      Message result = await dl.downloadMessageFile(message);
      message = result;
      message.iscurrentlydownloading = 0;
      notifyListeners();
    }
    catch (error) {
      message.iscurrentlydownloading = 0;
      message.isdownloaded = 0;
      notifyListeners();
    }
  }

  void deleteMessageDownload(Message message) async {
    dl.deleteMessageFile(message);
    
    //message.lastplayedposition = 0.0;
    message.isdownloaded = 0;
    message.filepath = '';
    //message.isfavorite = 0;
    //message.isplayed = 0;
    
    await db.update(message);
    notifyListeners();
  }

  void playMessage(Message message) {
    if (message.isdownloaded == 1) {
      playerPlayMessage(message);
      closeNotification();
      showPlayNotification(message.title);
    }
  }

  void pauseMessage(Message message) {
    playerPauseMessage(message);
    closeNotification();
    showPauseNotification(message.title);
  }

  void setCurrentPlaylist(int playlistId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('currentPlaylistId', playlistId);
    _currentPlaylistId = playlistId;
    notifyListeners();
  }

  void setLastViewedPlaylist(int playlistId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('lastViewedPlaylistId', playlistId);
    _lastViewedPlaylistId = playlistId;
    notifyListeners();
  }

  void playNextMessageInPlaylist(Message previousMessage) async {
    //final db = MessageDB.instance;

    if (_currentPlaylistId != null) {
      Playlist currentPlaylist = Playlist.fromMap({'id': _currentPlaylistId});
      List<Message> messagesInPlaylist = await db.getMessagesOnPlaylist(currentPlaylist);

      int previousIndex = messagesInPlaylist.indexWhere((message) => message.id == previousMessage.id);
      int nextIndex = messagesInPlaylist.indexWhere((message) => message.isdownloaded == 1, previousIndex + 1);
      int nextNextIndex = messagesInPlaylist.indexWhere((message) => message.isdownloaded == 1, nextIndex + 1);
      
      if (nextIndex > -1) {
        playMessage(messagesInPlaylist[nextIndex]);
      } /*else {
        setCurrentPlaylist(null);
        closePlayBar();
      }*/
      if (nextNextIndex < 0) {
        setCurrentPlaylist(null);
      }
    }
  }

  // listen for incoming phone calls
  void initializeCallListener() {
    phoneStateCallEvent.listen((PhoneStateCallEvent event) {
      if (event.stateC == 'true') {
        playerPauseMessage(null);
      }
    });
  }
}