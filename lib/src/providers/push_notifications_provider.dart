import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/providers/users_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PushNotificationsProvider extends GetConnect {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  void initPushNotifications() async {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  void onMessageListener() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  void saveToken(String idUser) async {
    String? token = await FirebaseMessaging.instance.getToken();
    UsersProvider usersProvider = UsersProvider();
    if (token != null) {
      await usersProvider.updateNotificationToken(idUser, token);
    }
  }

  Future<Response> sendMessage(String token, Map<String, dynamic> data) async {
    Response response = await post('https://fcm.googleapis.com/fcm/send', {
      'priority': 'high',
      'ttl': '4500s',
      'data': data,
      'to': token
    }, headers: {
      'Content-type': 'application/json',
      'Authorization':
          'key=AAAAYXQmV5s:APA91bHFJ6NODsYOTpJ5drNy0m_pi7p_x-0zW-2mubFhoeLBDKvbdLskGwg8fuC5akNFabmmKsO8SoR5LgZS_GQVm0W9oC6WDzySPIIekVjUjS37Zac4fWvU_PpVyDY_lKZ411Bvb0AH'
    });
    return response;
  }

  void showNotification(RemoteMessage message) async {
    AndroidNotificationDetails? androidPlatformChannelSpecifics;
    if (message.data['url'] == '') {
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channel.id, channel.name,
          icon: 'ic_launcher');
    } else {
      ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
          await _getByteArrayFromUrl(message.data['url']));
      BigPictureStyleInformation information = BigPictureStyleInformation(
          bigPicture,
          contentTitle: message.data['title'],
          htmlFormatContentTitle: true,
          summaryText: message.data['body'],
          htmlFormatSummaryText: true);
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channel.id, channel.name,
          icon: 'ic_launcher', styleInformation: information);
    }
    plugin.show(
        int.parse(message.data['id_chat']),
        message.data['title'],
        message.data['body'],
        NotificationDetails(android: androidPlatformChannelSpecifics));
    Socket socket = io('${Environment.API_RECIO_CHAT}chat', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket.connect();
    socket.emit('received', {
      'id_chat': message.data['id_chat'],
      'id_message': message.data['id_message']
    });
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
}
