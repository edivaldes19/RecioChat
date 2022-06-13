import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recio_chat/src/models/chat.dart';
import 'package:recio_chat/src/models/response_api.dart';
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
  void askToDeleteChat(Chat chat, BuildContext ctx) {
    Widget cancelButton = ElevatedButton(
        onPressed: () => Get.back(), child: const Text('Cancelar'));
    Widget acceptButton = ElevatedButton(
        onPressed: () async {
          Get.back();
          if (chat.id != null) {
            ResponseApi responseApi = await chatsProvider.deleteChat(chat.id!);
            if (responseApi.success == true) {
              getChats();
              Fluttertoast.showToast(
                  msg: responseApi.message ?? 'Chat eliminado exitosamente.');
            } else {
              Get.snackbar(
                  'Error', responseApi.message ?? 'Al eliminar el chat.');
            }
          }
        },
        child: const Text('Eliminar'));
    AlertDialog alertDialog = AlertDialog(
        title: Text(
            '¿Desea eliminar el Chat con ${chat.idUser1 == myUser.id ? '${chat.nameUser2} ${chat.lastnameUser2}' : '${chat.nameUser1} ${chat.lastnameUser1}'}?'),
        actions: [cancelButton, acceptButton]);
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return alertDialog;
        });
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
