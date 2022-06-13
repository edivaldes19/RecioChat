import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:recio_chat/src/models/chat.dart';
import 'package:recio_chat/src/models/message.dart';
import 'package:recio_chat/src/models/response_api.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/pages/chats/chats_controller.dart';
import 'package:recio_chat/src/pages/home/home_controller.dart';
import 'package:recio_chat/src/providers/chats_provider.dart';
import 'package:recio_chat/src/providers/messages_provider.dart';
import 'package:recio_chat/src/providers/push_notifications_provider.dart';
import 'package:recio_chat/src/providers/users_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class MessagesController extends GetxController {
  TextEditingController messageController = TextEditingController();
  User userChat = User.fromJson(Get.arguments['user']);
  User myUser = User.fromJson(GetStorage().read('user') ?? {});
  ChatsProvider chatsProvider = ChatsProvider();
  MessagesProvider messagesProvider = MessagesProvider();
  PushNotificationsProvider pushNotificationsProvider =
      PushNotificationsProvider();
  UsersProvider usersProvider = UsersProvider();
  String idChat = '';
  List<Message> messages = <Message>[].obs;
  HomeController homeController = Get.find();
  ChatsController chatsController = Get.find();
  ImagePicker picker = ImagePicker();
  File? imageFile;
  ScrollController scrollController = ScrollController();
  var isWriting = false.obs;
  var isOnline = false.obs;
  String idSocket = '';
  MessagesController() {
    createChat();
    checkIfIsOnline();
  }
  void askToDeleteMessage(Message message, BuildContext ctx) {
    Widget cancelButton = ElevatedButton(
        onPressed: () => Get.back(), child: const Text('Cancelar'));
    Widget acceptButton = ElevatedButton(
        onPressed: () async {
          Get.back();
          if (message.id != null) {
            emitMessageDeleted(message);
          } else {
            Get.snackbar('Error', 'Mensaje inexistente.');
          }
        },
        child: const Text('Eliminar'));
    AlertDialog alertDialog = AlertDialog(
        title: const Text('¿Desea eliminar este mensaje?'),
        actions: [cancelButton, acceptButton]);
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void checkIfIsOnline() async {
    Response response = await usersProvider.checkIfIsOnline(userChat.id!);
    if (response.body['online'] == true) {
      isOnline.value = true;
      idSocket = response.body['id_socket'];
      listenOnline();
    } else {
      isOnline.value = false;
    }
  }

  Future<File?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 80);
    return result;
  }

  void createChat() async {
    Chat chat = Chat(idUser1: myUser.id, idUser2: userChat.id);
    ResponseApi responseApi = await chatsProvider.create(chat);
    if (responseApi.success == true) {
      idChat = responseApi.data as String;
      getMessages();
      listenMessage();
      listenMessageDeleted();
      listenMessageReceived();
      listenMessageSeen();
      listenOffline();
      listenWriting();
    }
  }

  void emitMessage() {
    homeController.socket
        .emit('message', {'id_chat': idChat, 'id_user': userChat.id});
  }

  void emitMessageDeleted(Message message) {
    homeController.socket
        .emit('deleted', {'id_chat': idChat, 'id_message': message.id});
  }

  void emitMessageSeen() {
    homeController.socket.emit('seen', {'id_chat': idChat});
  }

  void emitWriting() {
    homeController.socket
        .emit('writing', {'id_chat': idChat, 'id_user': myUser.id});
  }

  void getChats() async {
    var result = await chatsProvider.getChats();
    chatsController.chats.clear();
    chatsController.chats.addAll(result);
  }

  void getMessages() async {
    var result = await messagesProvider.getMessagesByChat(idChat);
    messages.clear();
    messages.addAll(result);
    for (var msg in messages) {
      if (msg.status != 'VISTO' && msg.idReceiver == myUser.id) {
        await messagesProvider.updateToSeen(msg.id!);
        emitMessageSeen();
      }
    }
    getChats();
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    });
  }

  void goToInfoUserChat() {
    Get.toNamed('/user_info', arguments: {'userChat': userChat.toJson()});
  }

  void listenMessage() {
    homeController.socket.on('message/$idChat', (data) {
      getMessages();
    });
  }

  void listenMessageDeleted() {
    homeController.socket.on('deleted/$idChat', (data) {
      getMessages();
      Fluttertoast.showToast(msg: 'Se ha eliminado un mensaje.');
    });
  }

  void listenMessageReceived() {
    homeController.socket.on('received/$idChat', (data) {
      getMessages();
    });
  }

  void listenMessageSeen() {
    homeController.socket.on('seen/$idChat', (data) {
      getMessages();
    });
  }

  void listenOffline() async {
    if (idSocket.isNotEmpty) {
      homeController.socket.off('offline/$idSocket');
      homeController.socket.on('offline/$idSocket', (data) {
        if (idSocket == data['id_socket']) {
          isOnline.value = false;
          homeController.socket.off('offline/$idSocket');
        }
      });
    }
  }

  void listenOnline() {
    homeController.socket.off('online/${userChat.id}');
    homeController.socket.on('online/${userChat.id}', (data) {
      isOnline.value = true;
      idSocket = data['id_socket'];
      listenOffline();
    });
  }

  void listenWriting() {
    homeController.socket.on('writing/$idChat/${userChat.id}', (data) {
      isWriting.value = true;
      Future.delayed(const Duration(milliseconds: 2000), () {
        isWriting.value = false;
      });
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    homeController.socket.off('message/$idChat');
    homeController.socket.off('seen/$idChat');
    homeController.socket.off('writing/$idChat/${userChat.id}');
    homeController.socket.off('deleted/$idChat');
  }

  Future selectImage(ImageSource imageSource, BuildContext context) async {
    final XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = "${dir.absolute.path}/temp.jpg";
      ProgressDialog dialog = ProgressDialog(context: context);
      dialog.show(max: 100, msg: 'Subiendo imagen...');
      File? compressFile = await compressAndGetFile(imageFile!, targetPath);
      Message message = Message(
          message: '📷 Imagen',
          idSender: myUser.id,
          idReceiver: userChat.id,
          idChat: idChat,
          isImage: true,
          isVideo: false);
      Stream stream =
          await messagesProvider.createWithImage(message, compressFile!);
      stream.listen((res) {
        dialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        if (responseApi.success == true) {
          sendNotification(
            '📷 Imagen',
            responseApi.data['id'] as String,
            url: responseApi.data['url'] as String,
          );
          emitMessage();
        }
      });
    }
  }

  Future selectVideo(ImageSource imageSource, BuildContext context) async {
    final XFile? video = await picker.pickVideo(source: imageSource);
    if (video != null) {
      File videoFile = File(video.path);
      ProgressDialog dialog = ProgressDialog(context: context);
      dialog.show(max: 100, msg: 'Subiendo video...');
      Message message = Message(
          message: '🎥 Video',
          idSender: myUser.id,
          idReceiver: userChat.id,
          idChat: idChat,
          isImage: false,
          isVideo: true);
      Stream stream =
          await messagesProvider.createWithVideo(message, videoFile);
      stream.listen((res) {
        dialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        if (responseApi.success == true) {
          sendNotification(
            '🎥 Video',
            responseApi.data as String,
          );
          emitMessage();
        }
      });
    }
  }

  void sendMessage() async {
    String messageText = messageController.text.trim();
    if (messageText.isEmpty) {
      Get.snackbar('Error', 'El mensaje no puede ser vacío.');
      return;
    }
    if (idChat.isEmpty) {
      Get.snackbar('Error', 'Al enviar el mensaje.');
      return;
    }
    Message message = Message(
        message: messageText,
        idSender: myUser.id,
        idReceiver: userChat.id,
        idChat: idChat,
        isImage: false,
        isVideo: false);
    ResponseApi responseApi = await messagesProvider.create(message);
    if (responseApi.success == true) {
      messageController.clear();
      emitMessage();
      sendNotification(messageText, responseApi.data as String);
    }
  }

  void sendNotification(String message, String idMessage, {url = ''}) {
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'title': '${myUser.name} ${myUser.lastname}',
      'body': message,
      'id_message': idMessage,
      'id_chat': idChat,
      'url': url
    };
    pushNotificationsProvider.sendMessage(
        userChat.notificationToken ?? '', data);
  }

  void showAlertDialogForImage(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery, context);
        },
        child: const Text('Galería'));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera, context);
        },
        child: const Text('Cámara'));
    AlertDialog alertDialog = AlertDialog(
        title: const Text('Selecciona una imagen'),
        actions: [galleryButton, cameraButton]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void showAlertDialogForVideo(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectVideo(ImageSource.gallery, context);
        },
        child: const Text('Galería'));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectVideo(ImageSource.camera, context);
        },
        child: const Text('Cámara'));
    AlertDialog alertDialog = AlertDialog(
        title: const Text('Selecciona un video'),
        actions: [galleryButton, cameraButton]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
