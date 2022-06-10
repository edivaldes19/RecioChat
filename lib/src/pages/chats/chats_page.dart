import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/models/chat.dart';
import 'package:recio_chat/src/pages/chats/chats_controller.dart';
import 'package:recio_chat/src/utils/my_colors.dart';
import 'package:recio_chat/src/utils/relative_time_util.dart';
import 'package:recio_chat/src/widgets/no_data_widget.dart';

class ChatsPage extends StatelessWidget {
  ChatsController con = Get.put(ChatsController());
  ChatsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Chats'),
            automaticallyImplyLeading: false,
            backgroundColor: MyColors.primaryColor),
        body: Obx(() => SafeArea(
            child: getChats().isNotEmpty
                ? ListView(children: getChats())
                : NoDataWidget(
                    text:
                        'No tienes ningún Chat, dirígete a Usuarios e inicia una conversación.'))));
  }

  Widget cardChat(Chat chat) {
    return ListTile(
        onTap: () => con.goToChat(chat),
        title: Text(
            chat.idUser1 == con.myUser.id
                ? chat.nameUser2 != null && chat.lastnameUser2 != null
                    ? '${chat.nameUser2} ${chat.lastnameUser2}'
                    : 'Desconocido'
                : chat.nameUser1 != null && chat.lastnameUser1 != null
                    ? '${chat.nameUser1} ${chat.lastnameUser1}'
                    : 'Desconocido',
            style: const TextStyle(fontSize: 14, color: Colors.black)),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(chat.lastMessage ?? 'Desconocido',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(RelativeTimeUtil.getRelativeTime(chat.lastMessageTimestamp ?? 0),
              style: const TextStyle(fontSize: 10, color: Colors.blueGrey))
        ]),
        trailing: chat.unreadMessage! > 0
            ? Text('${chat.unreadMessage ?? 0}',
                style:
                    const TextStyle(fontSize: 10, color: MyColors.primaryColor))
            : const SizedBox(height: 0),
        leading: AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: 'assets/img/user.png',
                    image: chat.idUser1 == con.myUser.id
                        ? chat.imageUser2 ?? Environment.IMAGE_URL
                        : chat.imageUser1 ?? Environment.IMAGE_URL))));
  }

  List<Widget> getChats() {
    return con.chats.map((chat) {
      return Container(child: cardChat(chat));
    }).toList();
  }
}
