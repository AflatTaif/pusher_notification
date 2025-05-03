# pusher_notification

Ho to implement pusher notification and show the notification to your ui >>>>>>>>>>>>

Remember you you need to rest(get) api from you backend developer called something like: **pusher-config**


fist you have to add two packages on pubspec.yaml.

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

- [Pusher Controller](lib/pusher_controller.dart)


**and here is anothe file wich is help to show the notification on the top**

- [Show notification on to file](lib/notification_service.dart)

**and here is the ui where you show the notification on the screen**
 
- [Notification Screen](lib/notification_screen.dart)

remember you can make the ui screen as you want.



you can also follow this notification for more details implementation pusher notification


https://medium.com/@ravipatel84184/integrating-local-notifications-in-flutter-using-flutter-local-notifications-package-3951c5fc21cd



 keywords>>>>
How to implement pushser in flutter,
pusher in flutter
pusher notification in flutter
notification in flutter
flutter notification
how to show notification in flutter project

