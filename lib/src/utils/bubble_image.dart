import 'package:flutter/material.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class BubbleImage extends StatelessWidget {
  final String message, time, url, status;
  final delivered, isMe, isImage;
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
    final bg = isMe ? Colors.white : MyColors.primaryColorLight;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = status == 'ENVIADO'
        ? Icons.done
        : status == 'RECIBIDO'
            ? Icons.done_all
            : Icons.done_all;
    final radius = isMe
        ? const BorderRadius.only(
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(5))
        : const BorderRadius.only(
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(10));
    return Column(crossAxisAlignment: align, children: <Widget>[
      Container(
          margin: EdgeInsets.only(
              right: isMe == true ? 3 : 70,
              left: isMe == true ? 70 : 3,
              top: 5,
              bottom: 5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurRadius: .5,
                spreadRadius: 1,
                color: Colors.black.withOpacity(.12))
          ], color: bg, borderRadius: radius),
          child: Stack(children: <Widget>[
            Container(
                padding: const EdgeInsets.only(bottom: 22),
                child: isImage
                    ? FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: "assets/img/user_profile_2.png",
                        image: url)
                    : Text(message)),
            Positioned(
                bottom: 0,
                right: 0,
                child: Row(children: <Widget>[
                  Text(time,
                      style:
                          const TextStyle(color: Colors.black38, fontSize: 10)),
                  const SizedBox(width: 3),
                  isMe == true
                      ? Icon(icon,
                          size: 12,
                          color:
                              status == 'VISTO' ? Colors.blue : Colors.black38)
                      : Container()
                ]))
          ]))
    ]);
  }
}
