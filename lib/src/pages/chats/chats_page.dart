import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/models/chat.dart';
import 'package:recio_chat/src/pages/chats/chats_controller.dart';
import 'package:recio_chat/src/utils/my_colors.dart';
import 'package:recio_chat/src/utils/relative_time_util.dart';

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
        body: Obx(() => SafeArea(child: ListView(children: getChats()))));
  }

  Widget cardChat(Chat chat) {
    return ListTile(
        onTap: () => con.goToChat(chat),
        title: Text(chat.idUser1 == con.myUser.id
            ? chat.nameUser2 ?? ''
            : chat.nameUser1 ?? ''),
        subtitle: Text(chat.lastMessage ?? ''),
        trailing: Column(children: [
          Container(
              margin: const EdgeInsets.only(top: 7),
              child: Text(
                  RelativeTimeUtil.getRelativeTime(
                      chat.lastMessageTimestamp ?? 0),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]))),
          chat.unreadMessage! > 0
              ? circleMessageUnread(chat.unreadMessage ?? 0)
              : const SizedBox(height: 0)
        ]),
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

  Widget circleMessageUnread(int number) {
    return Container(
        margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
                height: 25,
                width: 25,
                color: MyColors.primaryColor,
                alignment: Alignment.center,
                child: Text(number.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center))));
  }

  List<Widget> getChats() {
    return con.chats.map((chat) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: cardChat(chat));
    }).toList();
  }
}
