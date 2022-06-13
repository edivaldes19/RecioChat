import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/models/message.dart';
import 'package:recio_chat/src/models/response_api.dart';
import 'package:recio_chat/src/models/user.dart';

class MessagesProvider extends GetConnect {
  String url = '${Environment.API_RECIO_CHAT}api/messages';
  User user = User.fromJson(GetStorage().read('user') ?? {});
  Future<ResponseApi> create(Message message) async {
    Response response = await post('$url/create', message.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': user.sessionToken ?? ''
    });
    if (response.body == null) {
      Get.snackbar('Error', 'Al actualizar el usuario.');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<Stream> createWithImage(Message message, File image) async {
    Uri uri = Uri.parse('$url/createWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = user.sessionToken ?? '';
    request.files.add(http.MultipartFile(
        'image', http.ByteStream(image.openRead().cast()), await image.length(),
        filename: basename(image.path)));
    request.fields['message'] = json.encode(message);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<Stream> createWithVideo(Message message, File video) async {
    Uri uri = Uri.parse('$url/createWithVideo');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = user.sessionToken ?? '';
    request.files.add(http.MultipartFile(
        'video', http.ByteStream(video.openRead().cast()), await video.length(),
        filename: basename(video.path)));
    request.fields['message'] = json.encode(message);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  // Future<ResponseApi> deleteMessage(String idMessage) async {
  //   Response response = await delete('$url/deleteMessage/$idMessage', headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': user.sessionToken ?? ''
  //   });
  //   if (response.body == null) {
  //     Get.snackbar('Error', 'Servidor no disponible.');
  //     return ResponseApi();
  //   }
  //   ResponseApi responseApi = ResponseApi.fromJson(response.body);
  //   return responseApi;
  // }

  Future<List<Message>> getMessagesByChat(String idMessage) async {
    Response response = await get('$url/findByChat/$idMessage', headers: {
      'Content-Type': 'application/json',
      'Authorization': user.sessionToken ?? ''
    });
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return [];
    }
    List<Message> messages = Message.fromJsonList(response.body);
    return messages;
  }

  // Future<ResponseApi> updateToReceived(String idMessage) async {
  //   Response response = await put('$url/updateToReceived', {
  //     'id': idMessage
  //   }, headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': user.sessionToken ?? ''
  //   });
  //   if (response.body == null) {
  //     Get.snackbar('Error', 'Servidor no disponible.');
  //     return ResponseApi();
  //   }
  //   ResponseApi responseApi = ResponseApi.fromJson(response.body);
  //   return responseApi;
  // }

  Future<ResponseApi> updateToSeen(String idMessage) async {
    Response response = await put('$url/updateToSeen', {
      'id': idMessage
    }, headers: {
      'Content-Type': 'application/json',
      'Authorization': user.sessionToken ?? ''
    });
    if (response.body == null) {
      Get.snackbar('Error', 'Servidor no disponible.');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
