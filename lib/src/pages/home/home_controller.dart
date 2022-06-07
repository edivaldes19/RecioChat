import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/providers/push_notifications_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomeController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});
  PushNotificationsProvider pushNotificationsProvider =
      PushNotificationsProvider();
  var tabIndex = 0.obs;
  Socket socket = io('${Environment.API_CHAT}chat', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });
  HomeController() {
    connectAndListen();
    saveToken();
  }
  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void connectAndListen() {
    if (user.id != null) {
      socket.connect();
      socket.onConnect((data) {
        emitOnline();
      });
    }
  }

  void emitOnline() {
    socket.emit('online', {'id_user': user.id});
  }

  @override
  void onClose() {
    super.onClose();
    socket.disconnect();
  }

  void saveToken() {
    if (user.id != null) {
      pushNotificationsProvider.saveToken(user.id!);
    }
  }
}
