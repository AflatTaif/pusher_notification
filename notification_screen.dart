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

