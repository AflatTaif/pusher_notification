# pusher_notification

Ho to implement pusher notification and show the notification to your ui >>>>>>>>>>>>
fist you have to add two package on pubspec.yaml.

 <p><code> ``` pusher_channels_flutter: ^2.4.0 ``` </code></p>
  flutter_local_notifications: ^17.1.2

the firt one is for implement pusher on yur project and the second one is for showing the notification on your device.

now you have to add this line below on your **AndroidManifext.xml** file under permissions. 
the file location is: **your_project> android> app> src> main> AndroidManifest.xml.**

and the line is:
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
