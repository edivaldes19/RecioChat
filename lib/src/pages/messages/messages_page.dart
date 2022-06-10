// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/models/message.dart';
import 'package:recio_chat/src/pages/messages/messages_controller.dart';
import 'package:recio_chat/src/utils/bubble.dart';
import 'package:recio_chat/src/utils/bubble_image.dart';
import 'package:recio_chat/src/utils/bubble_video.dart';
import 'package:recio_chat/src/utils/my_colors.dart';
import 'package:recio_chat/src/utils/relative_time_util.dart';

class MessagesPage extends StatelessWidget {
  MessagesController con = Get.put(MessagesController());
  MessagesPage({Key? key}) : super(key: key);
  Widget bubbleMessage(Message message) {
    if (message.isImage == true) {
      return BubbleImage(
          message: message.message ?? 'Desconocido',
          time: RelativeTimeUtil.getRelativeTime(message.timestamp ?? 0),
          delivered: true,
          isMe: message.idSender == con.myUser.id ? true : false,
          status: message.status ?? 'ENVIADO',
          isImage: true,
          url: message.url ?? Environment.IMAGE_URL);
    }
    if (message.isVideo == true) {
      return BubbleVideo(
          message: message.message ?? 'Desconocido',
          time: RelativeTimeUtil.getRelativeTime(message.timestamp ?? 0),
          delivered: true,
          isMe: message.idSender == con.myUser.id ? true : false,
          status: message.status ?? 'ENVIADO',
          url: message.url ?? Environment.IMAGE_URL,
          videoController: message.controller);
    }
    return Bubble(
        message: message.message ?? 'Desconocido',
        delivered: true,
        isMe: message.idSender == con.myUser.id ? true : false,
        status: message.status ?? 'ENVIADO',
        time: RelativeTimeUtil.getRelativeTime(message.timestamp ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Obx(() => Column(children: [
              customAppBar(),
              Expanded(
                  flex: 1,
                  child: ListView(
                      reverse: true,
                      controller: con.scrollController,
                      children: getMessages())),
              messagesBox(context)
            ])));
  }

  Widget customAppBar() {
    return SafeArea(
        child: ListTile(
            title: Text(
                con.userChat.name != null && con.userChat.lastname != null
                    ? '${con.userChat.name} ${con.userChat.lastname}'
                    : 'Desconocido',
                style: const TextStyle(
                    fontSize: 14,
                    color: MyColors.primaryColor,
                    fontWeight: FontWeight.bold)),
            subtitle: con.isWriting.value
                ? const Text('escribiendo...',
                    style: TextStyle(color: Colors.green))
                : Text(con.isOnline.value ? 'en línea' : 'desconectado(a)',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
            leading: IconButton(
                color: MyColors.primaryColor,
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back)),
            trailing: GestureDetector(
                onTap: () => con.goToInfoUserChat(),
                child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipOval(
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/img/loading.png',
                            image: con.userChat.image ??
                                Environment.IMAGE_URL))))));
  }

  List<Widget> getMessages() {
    return con.messages.map((msg) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          alignment: msg.idSender == con.myUser.id
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: bubbleMessage(msg));
    }).toList();
  }

  Widget messagesBox(BuildContext ctx) {
    return Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        elevation: 15,
        child: Row(children: [
          Column(children: [
            IconButton(
                tooltip: 'Enviar imagen...',
                onPressed: () => con.showAlertDialogForImage(ctx),
                icon: const Icon(Icons.camera_alt)),
            IconButton(
                tooltip: 'Enviar video...',
                onPressed: () => con.showAlertDialogForVideo(ctx),
                icon: const Icon(Icons.video_call))
          ]),
          Expanded(
              flex: 10,
              child: TextField(
                  onChanged: (String text) {
                    con.emitWriting();
                  },
                  controller: con.messageController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Escribe tu mensaje...',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20)))),
          FloatingActionButton(
              onPressed: () => con.sendMessage(),
              mini: true,
              tooltip: 'Enviar mensaje',
              backgroundColor: MyColors.primaryColor,
              child: const Icon(Icons.send))
        ]));
  }
}
