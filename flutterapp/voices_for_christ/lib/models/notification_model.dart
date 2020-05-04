import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notify;

mixin NotificationModel on Model {
  notify.FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  String _channelId = 'vfc_application';
  String _channelName = 'Voices for Christ';
  String _channelDescription = 'An audio app for playing messages from Voices for Christ';

  void initializeNotifications(Function onSelect) {
    _flutterLocalNotificationsPlugin = notify.FlutterLocalNotificationsPlugin();
    var android = notify.AndroidInitializationSettings('@mipmap/ic_stat_websitelogo');
    var ios = notify.IOSInitializationSettings();

    var initializationSettings = notify.InitializationSettings(android, ios);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelect
    );
  }

  Future showPlayNotification(String messageTitle) async {
    var androidSpecs = notify.AndroidNotificationDetails(
      _channelId, 
      _channelName, 
      _channelDescription, 
      playSound: false,
      enableVibration: false,
      importance: notify.Importance.Max,
      priority: notify.Priority.High,
    );
    var iosSpecs = notify.IOSNotificationDetails(
      presentSound: false,);
    var channelSpecs = notify.NotificationDetails(androidSpecs, iosSpecs);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Playing $messageTitle',
      'Tap to Pause',
      channelSpecs,
      payload: '$messageTitle'
    );
  }

  Future showPauseNotification(String messageTitle) async {
    var androidSpecs = notify.AndroidNotificationDetails(
      _channelId, 
      _channelName, 
      _channelDescription, 
      playSound: false,
      enableVibration: false,
      importance: notify.Importance.Max,
      priority: notify.Priority.High,
    );
    var iosSpecs = notify.IOSNotificationDetails(
      presentSound: false,);
    var channelSpecs = notify.NotificationDetails(androidSpecs, iosSpecs);

    await _flutterLocalNotificationsPlugin.show(
      0,
      '$messageTitle is paused',
      'Tap to Play',
      channelSpecs,
      payload: '$messageTitle'
    );
  }

  void closeNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}