import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/pages/home/home_page.dart';
import 'package:recio_chat/src/pages/login/login_page.dart';
import 'package:recio_chat/src/pages/messages/messages_page.dart';
import 'package:recio_chat/src/pages/profile_edit/profile_edit_page.dart';
import 'package:recio_chat/src/pages/register/register_page.dart';
import 'package:recio_chat/src/pages/user_info/user_info_page.dart';
import 'package:recio_chat/src/view_user_image/view_image_page.dart';
import 'package:recio_chat/src/providers/push_notifications_provider.dart';
import 'package:recio_chat/src/utils/default_firebase_config.dart';
import 'package:recio_chat/src/utils/my_colors.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'src/api/environment.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBbhBsTROm4b_Lx91homqlgf3qaBtS849Y',
          appId: '1:418560497563:android:70b44e0a83a63db588b33e',
          messagingSenderId: '418560497563',
          projectId: 'reciochat'));
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initPushNotifications();
  runApp(const MyApp());
}

User myUser = User.fromJson(GetStorage().read('user') ?? {});
PushNotificationsProvider pushNotificationsProvider =
    PushNotificationsProvider();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  pushNotificationsProvider.showNotification(message);
  Socket socket = io('${Environment.API_RECIO_CHAT}chat', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });
  socket.connect();
  socket.emit('received', {
    'id_chat': message.data['id_chat'],
    'id_message': message.data['id_message'],
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'RecioChat',
        debugShowCheckedModeBanner: false,
        initialRoute: myUser.id != null ? '/home' : '/',
        getPages: [
          GetPage(name: '/', page: () => LoginPage()),
          GetPage(name: '/register', page: () => RegisterPage()),
          GetPage(name: '/home', page: () => HomePage()),
          GetPage(name: '/profile/edit', page: () => ProfileEditPage()),
          GetPage(name: '/messages', page: () => MessagesPage()),
          GetPage(name: '/user_info', page: () => UserInfoPage()),
          GetPage(name: '/view_image', page: () => ViewImagePage())
        ],
        theme: ThemeData(
            primaryColor: MyColors.primaryColor, fontFamily: 'ComicSansMS'),
        navigatorKey: Get.key);
  }

  @override
  void initState() {
    super.initState();
    pushNotificationsProvider.onMessageListener();
  }
}
