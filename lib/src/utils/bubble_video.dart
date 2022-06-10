import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:recio_chat/src/utils/my_colors.dart';
import 'package:video_player/video_player.dart';

class BubbleVideo extends StatefulWidget {
  final String message, time, url, status;
  final delivered, isMe;
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  Function? playVideo;
  bool isLoading = false;
  BubbleVideo(
      {Key? key,
      this.message = '',
      this.time = '',
      this.delivered,
      this.isMe,
      this.url = '',
      this.status = '',
      this.playVideo,
      this.videoController})
      : super(key: key);
  @override
  State<BubbleVideo> createState() => _BubbleVideoState();
}

class _BubbleVideoState extends State<BubbleVideo> {
  @override
  Widget build(BuildContext context) {
    final bg = widget.isMe ? MyColors.primaryColorLight : Colors.white;
    final align =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = widget.status == 'ENVIADO'
        ? Icons.done
        : widget.status == 'RECIBIDO'
            ? Icons.done_all
            : Icons.done_all;
    final radius = widget.isMe
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
            right: widget.isMe ? 3 : 70,
            left: widget.isMe ? 70 : 3,
            top: 5,
            bottom: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(blurRadius: .5, spreadRadius: 1, color: Colors.grey)
        ], color: bg, borderRadius: radius),
        child: Column(crossAxisAlignment: align, children: [
          Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                  onTap: () => playVideo(),
                  child: Stack(children: [
                    Container(
                        child:
                            widget.videoController?.value.isInitialized == true
                                ? AspectRatio(
                                    aspectRatio: widget.videoController?.value
                                        .aspectRatio as double,
                                    child: Chewie(
                                        controller: widget.chewieController!))
                                : _buildImageWait())
                  ]))),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.time,
                style: const TextStyle(color: Colors.black38, fontSize: 10)),
            widget.isMe
                ? Icon(icon,
                    size: 15,
                    color:
                        widget.status == 'VISTO' ? Colors.blue : Colors.black38)
                : Container()
          ])
        ]));
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoController?.dispose();
    widget.chewieController?.dispose();
    widget.videoController = null;
    widget.chewieController = null;
    widget.isLoading = false;
  }

  void playVideo() async {
    if (widget.videoController == null) {
      setState(() {
        widget.isLoading = true;
      });
      widget.videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((value) {
          widget.isLoading = false;
          widget.chewieController = ChewieController(
              videoPlayerController: widget.videoController!,
              autoPlay: true,
              looping: true);
          setState(() {});
        });
    } else if (widget.videoController?.value.isPlaying == true) {
      widget.videoController?.pause();
    } else {
      widget.videoController?.play();
    }
  }

  Widget _buildImageWait() {
    return widget.isLoading
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Text('Cargando video...'))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child:
                Icon(Icons.video_library, color: Colors.grey[600], size: 100));
  }
}
