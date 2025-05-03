# pusher_notification

Ho to implement pusher notification and show the notification to your ui >>>>>>>>>>>>
fist you have to add two package on pubspec.yaml.

<pre>pusher_channels_flutter: ^2.4.0</pre>
 <pre>flutter_local_notifications: ^17.1.2</pre>

the firt one is for implement pusher on yur project and the second one is for showing the notification on your device.

now you have to add this line below on your **AndroidManifext.xml** file under permissions. 
the file location is: **your_project> android> app> src> main> AndroidManifest.xml.**

and the line is:
    <pre> ``` <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/> ``` </pre>



when notification shows on top you see there have a logo.
to set this logo you have to paste the logo/image on this location.
**your_project> android> app> src> main> res> drawable**
on the drawable folder paste the logo/image file.


now here is a controller class given below. you have to make the controller like this.
make sure you have rest api for this implementation. And backend developer gives you the pusher config.

**here is the controller code.**

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:list_place_new/data/models/pusher_model.dart';
import 'package:list_place_new/data/repository/pusher_repository.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../screens/pusher_services/notification_services.dart';

class PusherController extends GetxController{
  GetStorage storage = GetStorage();
  List<Map<String,dynamic>> notificationTextList = [];

  Map notificationMessageData = {} ;
  bool isLoading = false;
  String apiKey = '' ;
  String cluster = '' ;
  String channel = '' ;
  String event = '' ;
  String chattingChannel = '' ;
  String chattingEvent = '' ;
  String productQueryChannel = '' ;
  String productQueryEvent = '' ;

  String text = '';



  Future<void> getPusherNotification()async{
    isLoading = true;
    update();
    http.Response response = await PusherRepository.getPusherRepository() ;
    isLoading = false;
    update();

    if(response.statusCode == 200){
      final jsonResponse = jsonDecode(response.body);
      final model = PusherConfigModel.fromJson(jsonResponse);
      if(model.data != null){
        apiKey = model.data!.apiKey ?? "";
        cluster = model.data!.cluster?? "";
        channel = model.data!.channel?? "";
        event = model.data!.event?? "";
        chattingChannel = model.data!.chattingChannel?? "";
        chattingEvent = model.data!.chattingEvent?? "";
        productQueryChannel = model.data!.productQueryChannel?? "";
        productQueryEvent = model.data!.productQueryEvent?? "";
      }
      if(apiKey!= '' && cluster != ''){
        await getPusherConfig();
      }

    }

  }

  Future<void> getPusherConfig()async{
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onConnectionStateChange:onConnectionStateChange,
        onEvent: onEvent,
      );
      await pusher.subscribe(channelName: channel);
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  void onEvent(PusherEvent event) {

    notificationMessageData = jsonDecode(event.data);

     text = notificationMessageData['message']['description']['text'];
     // print('____________----------___________-----------------________');
     // print(jsonDecode(event.data));


    notificationTextList.add({
      'title': text,
      'description': DateFormat.yMMMMd().add_jm().format(DateTime.now()),
    });
    storage.write('notificationList', notificationTextList);

    FlutterNotificationService().showSimpleNotification(title: text.toString(), description: DateFormat.yMMMMd().add_jm().format(DateTime.now()));


  }
  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }




}




**and here is anothe file wich is help to show the notification on the top**



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




**and here is the ui where you show the notification on the screen**
 
- [Notification Screen](lib/notification_screen.dart)

remember you can make the ui screen as you want.
