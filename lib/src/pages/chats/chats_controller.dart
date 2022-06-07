import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recio_chat/src/models/chat.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/pages/home/home_controller.dart';
import 'package:recio_chat/src/providers/chats_provider.dart';

class ChatsController extends GetxController {
  ChatsProvider chatsProvider = ChatsProvider();
  User myUser = User.fromJson(GetStorage().read('user') ?? {});
  HomeController homeController = Get.find();
  List<Chat> chats = <Chat>[].obs;
  ChatsController() {
    getChats();
    listenMessage();
  }
  void getChats() async {
    var result = await chatsProvider.getChats();
    chats.clear();
    chats.addAll(result);
  }

  void goToChat(Chat chat) {
    User user = User();
    if (chat.idUser1 == myUser.id) {
      user.id = chat.idUser2;
      user.name = chat.nameUser2;
      user.lastname = chat.lastnameUser2;
      user.email = chat.emailUser2;
      user.phone = chat.phoneUser2;
      user.image = chat.imageUser2;
      user.notificationToken = chat.notificationTokenUser2;
    } else {
      user.id = chat.idUser1;
      user.name = chat.nameUser1;
      user.lastname = chat.lastnameUser1;
      user.email = chat.emailUser1;
      user.phone = chat.phoneUser1;
      user.image = chat.imageUser1;
      user.notificationToken = chat.notificationTokenUser1;
    }
    Get.toNamed('/messages', arguments: {'user': user.toJson()});
  }

  void listenMessage() {
    homeController.socket.on('message/${myUser.id}', (data) {
      getChats();
    });
  }

  @override
  void onClose() {
    super.onClose();
    homeController.socket.off('message/${myUser.id}');
  }
}
