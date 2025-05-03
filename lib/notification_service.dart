

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:list_place_new/controllers/pusher_controller.dart';

class FlutterNotificationService{
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void initNotification(){

    var initializationSettingsAndroid =
    AndroidInitializationSettings('flutter_logo');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showSimpleNotification({required String title,required String description,}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title.toString(),
      description,
      platformChannelSpecifics,
    );
  }

}
