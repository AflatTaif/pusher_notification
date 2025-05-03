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
 
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:list_place_new/Themes/app_color.dart';
import 'package:list_place_new/controllers/pusher_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}


class _NotificationScreenState extends State<NotificationScreen> {
  final PusherController pusherController = Get.put(PusherController());
  final GetStorage storage = GetStorage();

  List<Map<String, dynamic>> notificationList = [];

  @override
  void initState() {
    super.initState();
    List? storedList = storage.read('notificationList');
    if (storedList != null) {
      notificationList = List<Map<String, dynamic>>.from(storedList);
    }
  }

  void clearAllNotifications() {
    setState(() {
      notificationList.clear();
      storage.write('notificationList', notificationList);
    });
  }

  void deleteNotification(int index) {
    setState(() {
      int actualIndex = notificationList.length - 1 - index;
      notificationList.removeAt(actualIndex);
      storage.write('notificationList', notificationList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? AppColor.black : AppColor.white,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? AppColor.black : AppColor.white,
        leading: const BackButton(),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: "Nunito",
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: clearAllNotifications,
            child: Text(
              'Clear all',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
      body: notificationList.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
        itemCount: notificationList.length,
        itemBuilder: (BuildContext context, int index) {
          // Show in reverse order
          var reversedList = notificationList.reversed.toList();
          var data = reversedList[index];

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Slidable(
              key: ValueKey(index),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    flex: 2,
                    borderRadius: BorderRadius.circular(32),
                    onPressed: (context) => deleteNotification(index),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                color: Colors.grey.shade100.withOpacity(0.9),
                child: Container(
                  height: 80,
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        child: Image.asset(
                          'assets/images/bell.png',
                          height: 20,
                          width: 20,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data['title']
                                  .replaceAll('\n', ' ')
                                  .replaceAll('\u00A0', ' ')
                                  .replaceAll(RegExp(r'\s+'), ' ')
                                  .trim(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data['description'].toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


remember you can make the ui screen as you want.
