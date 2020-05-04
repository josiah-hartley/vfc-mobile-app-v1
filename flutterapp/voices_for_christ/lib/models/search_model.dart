import 'package:scoped_model/scoped_model.dart';
import 'package:voices_for_christ/data/database.dart';
import 'package:voices_for_christ/data/message_class.dart';
import 'package:voices_for_christ/widgets/search_window/motm_scraper.dart';

mixin SearchModel on Model {
  final db = MessageDB.instance;
  List<Message> _messages = [];
  String _searchString = '';
  int _searchResultCount = 0;
  int _currentlyLoadedMessageCount = 0;
  int _messageLoadingBatchSize = 50;
  bool _reachedEndOfList = false;
  Message _messageOfTheMonth;

  List<Message> get messages => _messages;
  String get searchString => _searchString;
  int get searchResultCount => _searchResultCount;
  bool get resultsFinished => _reachedEndOfList;
  Message get messageOfTheMonth => _messageOfTheMonth;

  void search() async {
    List<Message> result = [];

    if (_searchString != '') {
      result = await db.searchBySpeakerOrTitle(_searchString, _currentlyLoadedMessageCount, _currentlyLoadedMessageCount + _messageLoadingBatchSize);

      if (result.length < _messageLoadingBatchSize) {
        _reachedEndOfList = true;
      }
      _currentlyLoadedMessageCount += result.length;
    }
    _messages.addAll(result);
    
    notifyListeners();
  }

  void startNewSearch(String searchTerm) async {
    _messages = [];
    _searchString = searchTerm;
    _currentlyLoadedMessageCount = 0;
    _reachedEndOfList = false;
    _searchResultCount = await db.searchCountSpeakerTitle(searchTerm);
    notifyListeners();
  }

  void loadMOTM() async {
    _messageOfTheMonth = await monthlyMessage();
    notifyListeners();
  }
}