import 'package:scoped_model/scoped_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/data/message_class.dart';

mixin PlayerModel on Model {
  SharedPreferences _prefs;
  AudioPlayer _messagePlayer;
  Duration _currentPlayPosition = Duration(seconds: 0);
  Message _currentlyPlayingMessage;
  bool _isPlaying = false;
  final _db = MessageDB.instance;

  Duration get currentPlayPosition => _currentPlayPosition;
  Message get currentlyPlayingMessage => _currentlyPlayingMessage;
  bool get isPlaying => _isPlaying;

  void initializePlayer(Function onCompleted) async {
    _messagePlayer = AudioPlayer();

    _messagePlayer.onAudioPositionChanged.listen((Duration p) async {
      _currentPlayPosition = p;
      notifyListeners();

      if (p.inSeconds.toDouble() > _currentlyPlayingMessage.lastplayedposition + 15) {
        _currentlyPlayingMessage.lastplayedposition = p.inSeconds.toDouble();
        await _db.update(_currentlyPlayingMessage);
      }
    });

    _messagePlayer.onPlayerStateChanged.listen((AudioPlayerState s) async {
      if (s != AudioPlayerState.PLAYING) {
        _isPlaying = false;

        if (_currentlyPlayingMessage != null) {
          _currentlyPlayingMessage.lastplayedposition = _currentPlayPosition.inSeconds.toDouble() > 2
            ? _currentPlayPosition.inSeconds.toDouble() - 2
            : _currentPlayPosition.inSeconds.toDouble();
        }

        /*if (s == AudioPlayerState.COMPLETED) {
          _currentlyPlayingMessage.lastplayedposition = 0.0;
          _currentPlayPosition = Duration(milliseconds: 0);
        }*/
      } else {
        _isPlaying = true;
      }
      notifyListeners();
      
      if (_currentlyPlayingMessage != null) {
        await _db.update(_currentlyPlayingMessage);
      }

      if (s == AudioPlayerState.COMPLETED) {
        onCompleted();
      }

      saveLastPlayedMessage();
    });

    // get most recent message
    getLastPlayedMessage();
  }

  void closePlayBar() {
    _currentlyPlayingMessage = null;
    saveLastPlayedMessage();
    notifyListeners();
  }

  void getLastPlayedMessage() async {
    _prefs = await SharedPreferences.getInstance();
    int _currMessageID = _prefs.getInt('mostRecentMessageId');
    if (_currMessageID != null) {
      Message result = await _db.queryOne(_currMessageID);
      _currentlyPlayingMessage = result;
      _currentPlayPosition = Duration(seconds: _currentlyPlayingMessage.lastplayedposition.floor());
      
      // initiate the player
      //playerPlayMessage(_currentlyPlayingMessage);
      //playerPauseMessage(_currentlyPlayingMessage);
      //loadMessageAndSetCursor(_currentlyPlayingMessage);
      
      notifyListeners();
    }
  }

  void saveLastPlayedMessage() async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('mostRecentMessageId', _currentlyPlayingMessage?.id);
  }

  void loadMessageAndSetCursor(Message message) async {
    await _messagePlayer?.setUrl(message.filepath, isLocal: true);
    await _messagePlayer?.seek(Duration(seconds: message.lastplayedposition.floor()));
  }

  void playerPlayMessage(Message message) async {
    if (message.id == _currentlyPlayingMessage?.id) {
      if (!_isPlaying) { // play paused message
        await _messagePlayer?.play(message.filepath, isLocal: true);
        await _messagePlayer?.seek(Duration(seconds: message.lastplayedposition.floor()));
      } 
    } else { // pause previous message, switch to new message, and play
      if (_currentlyPlayingMessage != null) {
        //await _messagePlayer?.seek(Duration(seconds: _currentlyPlayingMessage.lastplayedposition.floor()));
        await _messagePlayer?.pause();
        await _db.update(_currentlyPlayingMessage);
      }
      
      _currentlyPlayingMessage = message;
      
      await _messagePlayer?.play(message.filepath, isLocal: true);
      await _messagePlayer?.seek(Duration(seconds: message.lastplayedposition.floor()));
    }
  }

  void playerPauseMessage(Message message) async {
    //await _messagePlayer.seek(Duration(seconds: message.lastplayedposition.floor()));
    await _messagePlayer.pause();
  }

  void seekToSecond(int second) async {
    await _messagePlayer.seek(Duration(seconds: second));
    _currentlyPlayingMessage.lastplayedposition = second.toDouble();
    notifyListeners();
  }

  void seekBackFifteen(Message message) {
    if (_currentPlayPosition.inSeconds >= 15) {
      seekToSecond(_currentPlayPosition.inSeconds - 15);
    } else {
      seekToSecond(0);
    }
  }

  void seekForwardFifteen(Message message) {
    if (_currentlyPlayingMessage.durationinseconds.toInt() - _currentPlayPosition.inSeconds > 15) {
      seekToSecond(_currentPlayPosition.inSeconds + 15);
    } else {
      seekToSecond(_currentlyPlayingMessage.durationinseconds.toInt());
    }
  }

  void disposeOfPlayer() {
    _messagePlayer.release();
  }
}