import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/models/message.dart';
import 'package:recio_chat/src/pages/messages/messages_controller.dart';
import 'package:recio_chat/src/utils/bubble.dart';
import 'package:recio_chat/src/utils/bubble_image.dart';
import 'package:recio_chat/src/utils/bubble_video.dart';
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
          url: message.url ??
              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png');
    }
    if (message.isVideo == true) {
      return BubbleVideo(
          message: message.message ?? 'Desconocido',
          time: RelativeTimeUtil.getRelativeTime(message.timestamp ?? 0),
          delivered: true,
          isMe: message.idSender == con.myUser.id ? true : false,
          status: message.status ?? 'ENVIADO',
          url: message.url ??
              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
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
        backgroundColor: const Color.fromRGBO(245, 246, 248, 1),
        body: Obx(() => Column(children: [
              customAppBar(),
              Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: ListView(
                          reverse: true,
                          controller: con.scrollController,
                          children: getMessages()))),
              messagesBox(context)
            ])));
  }

  Widget customAppBar() {
    return SafeArea(
        child: ListTile(
            title: Text(
              '${con.userChat.name ?? 'Desconocido'} ${con.userChat.lastname ?? 'Desconocido'}',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
            subtitle: con.isWriting.value
                ? const Text(
                    'Escribiendo...',
                    style: TextStyle(color: Colors.green),
                  )
                : Text(con.isOnline.value ? 'en línea' : 'desconectado(a)',
                    style: const TextStyle(color: Colors.grey)),
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios)),
            trailing: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipOval(
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/img/user.png',
                            image: con.userChat.image ??
                                Environment.IMAGE_URL))))));
  }

  List<Widget> getMessages() {
    return con.messages.map((message) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: message.idSender == con.myUser.id
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: bubbleMessage(message));
    }).toList();
  }

  Widget messagesBox(BuildContext ctx) {
    return Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        elevation: 15,
        child: Row(children: [
          Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () => con.showAlertDialog(ctx),
                  icon: const Icon(Icons.image_outlined))),
          Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () => con.showAlertDialogForVideo(ctx),
                  icon: const Icon(Icons.video_call_rounded))),
          Expanded(
              flex: 10,
              child: TextField(
                  onChanged: (String text) {
                    con.emitWriting();
                  },
                  controller: con.messageController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Escribe tu mensaje...',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20)))),
          Expanded(
              flex: 2,
              child: IconButton(
                  onPressed: () => con.sendMessage(),
                  icon: const Icon(Icons.send)))
        ]));
  }
}
