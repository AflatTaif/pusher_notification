
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



