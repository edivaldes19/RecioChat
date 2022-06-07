import 'dart:convert';
import 'dart:io';

import 'package:chat_udemy/src/models/chat.dart';
import 'package:chat_udemy/src/models/message.dart';
import 'package:chat_udemy/src/models/response_api.dart';
import 'package:chat_udemy/src/models/user.dart';
import 'package:chat_udemy/src/pages/chats/chats_controller.dart';
import 'package:chat_udemy/src/pages/home/home_controller.dart';
import 'package:chat_udemy/src/providers/chats_provider.dart';
import 'package:chat_udemy/src/providers/messages_provider.dart';
import 'package:chat_udemy/src/providers/push_notifications_provider.dart';
import 'package:chat_udemy/src/providers/users_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class MessagesController extends GetxController {

  TextEditingController messageController = TextEditingController();

  User userChat = User.fromJson(Get.arguments['user']);
  User myUser = User.fromJson(GetStorage().read('user') ?? {});

  ChatsProvider chatsProvider = ChatsProvider();
  MessagesProvider messagesProvider = MessagesProvider();
  PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();
  UsersProvider usersProvider = UsersProvider();
  
  String idChat = '';
  List<Message> messages = <Message>[].obs; // GETX

  HomeController homeController = Get.find();
  ChatsController chatsController = Get.find();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  ScrollController scrollController =  ScrollController();
  var isWriting = false.obs;
  var isOnline = false.obs;
  String idSocket = '';

  MessagesController() {
    print('Usuario chat: ${userChat.toJson()}');
    createChat();
    checkIfIsOnline();
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

    pushNotificationsProvider.sendMessage(userChat.notificationToken ?? '', data);
  }

  void listenMessage() {
    homeController.socket.on('message/$idChat', (data) {
      print('DATA EMITIDA $data');
      getMessages();
    });
  }

  void listenOnline() {

    homeController.socket.off('online/${userChat.id}');
    homeController.socket.on('online/${userChat.id}', (data) {
      print('DATA EMITIDA $data');
      isOnline.value = true;
      idSocket = data['id_socket'];
      listenOffline();
    });
  }

  void listenOffline() async {
    if (idSocket.isNotEmpty) {
      homeController.socket.off('offline/$idSocket');
      homeController.socket.on('offline/$idSocket', (data) {
        print('INGRESO A DESCONECTADO ${data}');
        if (idSocket == data['id_socket']) {
          isOnline.value = false;
          homeController.socket.off('offline/$idSocket');
        }
      });
    }
  }

  void listenMessageSeen() {
    homeController.socket.on('seen/$idChat', (data) {
      print('DATA EMITIDA $data');
      getMessages();
    });
  }

  void listenMessageReceived() {
    homeController.socket.on('received/$idChat', (data) {
      print('DATA EMITIDA $data');
      getMessages();
    });
  }

  void listenWriting() {
    homeController.socket.on('writing/$idChat/${userChat.id}', (data) {
      print('DATA EMITIDA $data');
      isWriting.value = true;
      Future.delayed(Duration(milliseconds: 2000), () {
        isWriting.value = false;
      });
    });
  }

  void emitMessage() {
    homeController.socket.emit('message', {
      'id_chat': idChat,
      'id_user': userChat.id
    });
  }

  void emitMessageSeen() {
    homeController.socket.emit('seen', {
      'id_chat': idChat
    });
  }

  void emitWriting() {
    homeController.socket.emit('writing', {
      'id_chat': idChat,
      'id_user': myUser.id,
    });
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

    messages.forEach((m) async {
      if (m.status != 'VISTO' && m.idReceiver == myUser.id) {
        await messagesProvider.updateToSeen(m.id!);
        emitMessageSeen();
      }
    });

    getChats();

    Future.delayed(Duration(milliseconds: 100), (){
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    });
  }
  
  void checkIfIsOnline() async {
    Response response = await usersProvider.checkIfIsOnline(userChat.id!);

    if (response.body['online'] == true) {
      isOnline.value = true;
      idSocket = response.body['id_socket'];
      listenOnline();
    }
    else {
      isOnline.value = false;
    }

  }
  
  void createChat() async {
    Chat chat = Chat(
      idUser1: myUser.id,
      idUser2: userChat.id
    );

    ResponseApi responseApi = await chatsProvider.create(chat);

    if (responseApi.success == true) {
      idChat = responseApi.data as String;
      getMessages();
      listenMessage();
      listenWriting();
      listenMessageSeen();
      listenOffline();
      listenMessageReceived();
    }
    // Get.snackbar('Chat creado', responseApi.message ?? 'Error en la respuesta');
  }

  void sendMessage() async {
    String messageText = messageController.text;

    if (messageText.isEmpty) {
      Get.snackbar('Texto vacio', 'Ingresa el mensaje que quieres enviar');
      return;
    }

    if (idChat == '') {
      Get.snackbar('Error', 'No se pudo enviar el mensaje');
      return;
    }

    Message message = Message(
      message: messageText,
      idSender: myUser.id,
      idReceiver: userChat.id,
      idChat: idChat,
      isImage: false,
      isVideo: false
    );

    ResponseApi responseApi = await messagesProvider.create(message);

    if (responseApi.success == true) {
      messageController.text = '';
      emitMessage();
      sendNotification(messageText, responseApi.data as String);
    }

  }

  Future<File?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80
    );

    return result;
  }

  Future selectVideo(ImageSource imageSource, BuildContext context) async {
    final XFile? video = await picker.pickVideo(source: imageSource);

    if (video != null) {
      File videoFile = File(video.path);

      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Subiendo video...');


      Message message = Message(
          message: 'VIDEO',
          idSender: myUser.id,
          idReceiver: userChat.id,
          idChat: idChat,
          isImage: false,
          isVideo: true
      );

      Stream stream = await messagesProvider.createWithVideo(message, videoFile);
      stream.listen((res) {
        progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        if (responseApi.success == true) {
          sendNotification(
            '🎥Video',
            responseApi.data as String,
          );
          emitMessage();
        }

      });
    }
  }

  Future selectImage(ImageSource imageSource, BuildContext context) async {
    final XFile? image = await picker.pickImage(source: imageSource);

    if (image != null) {
        imageFile = File(image.path);

        final dir = await path_provider.getTemporaryDirectory();
        final targetPath = dir.absolute.path + "/temp.jpg";

        ProgressDialog progressDialog = ProgressDialog(context: context);
        progressDialog.show(max: 100, msg: 'Subiendo imagen...');
        File? compressFile = await compressAndGetFile(imageFile!, targetPath); // COMPRIMIR EL ARCHIVO

        Message message = Message(
            message: 'IMAGEN',
            idSender: myUser.id,
            idReceiver: userChat.id,
            idChat: idChat,
            isImage: true,
            isVideo: false
        );

        Stream stream = await messagesProvider.createWithImage(message, compressFile!);
        stream.listen((res) {
          progressDialog.close();
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

          if (responseApi.success == true) {
            sendNotification(
                '📷Imagen',
                responseApi.data['id'] as String,
                url: responseApi.data['url'] as String,
            );
            emitMessage();
          }

        });
    }
  }


  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery, context);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera, context);
        },
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }

  void showAlertDialogForVideo(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectVideo(ImageSource.gallery, context);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectVideo(ImageSource.camera, context);
        },
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu video'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
    homeController.socket.off('message/$idChat');
    homeController.socket.off('seen/$idChat');
    homeController.socket.off('writing/$idChat/${userChat.id}');

  }

}