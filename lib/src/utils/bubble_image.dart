import 'package:flutter/material.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class BubbleImage extends StatelessWidget {
  final String message, time, url, status;
  final delivered, isMe;
  final bool isImage;
  const BubbleImage(
      {Key? key,
      this.message = '',
      this.time = '',
      this.delivered,
      this.isMe,
      this.isImage = false,
      this.url = '',
      this.status = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bg = isMe ? MyColors.primaryColorLight : Colors.white;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = status == 'ENVIADO'
        ? Icons.done
        : status == 'RECIBIDO'
            ? Icons.done_all
            : Icons.done_all;
    final radius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10))
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(24),
            topRight: Radius.circular(24));
    return Container(
        margin: EdgeInsets.only(
            right: isMe ? 3 : 70, left: isMe ? 70 : 3, top: 5, bottom: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(blurRadius: .5, spreadRadius: 1, color: Colors.grey)
        ], color: bg, borderRadius: radius),
        child: Column(crossAxisAlignment: align, children: [
          Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: isImage
                  ? FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      placeholder: "assets/img/loading.png",
                      image: url)
                  : Text(message)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(time,
                style: const TextStyle(color: Colors.black38, fontSize: 10)),
            isMe
                ? Icon(icon,
                    size: 15,
                    color: status == 'VISTO' ? Colors.blue : Colors.black38)
                : Container()
          ])
        ]));
  }
}
