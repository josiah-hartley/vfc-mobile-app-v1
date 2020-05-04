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
  List<Message> _downloads = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return _downloadsList();
  }

  Widget _downloadsList() {
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
              ? Text('')
              : Text('No messages downloaded'),
          ),
        );
  }

  void loadDownloads() async {
    setState(() {
      _isLoading = true;
    });
    final db = MessageDB.instance;
    List<Message> result = await db.queryDownloads();
    setState(() {
      _downloads = result;
      _isLoading = false;
    });
  }
}