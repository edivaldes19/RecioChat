import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/models/chat.dart';
import 'package:recio_chat/src/models/response_api.dart';
import 'package:recio_chat/src/models/user.dart';

class ChatsProvider extends GetConnect {
  String url = '${Environment.API_RECIO_CHAT}api/chats';
  User user = User.fromJson(GetStorage().read('user') ?? {});
  Future<ResponseApi> create(Chat chat) async {
    Response response = await post('$url/create', chat.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': user.sessionToken ?? ''
    });
    if (response.body == null) {
      Get.snackbar('Error', 'Error al crear el chat.');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> deleteChat(String idChat) async {
    Response response = await delete('$url/deleteChat/$idChat', headers: {
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

  Future<List<Chat>> getChats() async {
    Response response = await get('$url/findByIdUser/${user.id}', headers: {
      'Content-Type': 'application/json',
      'Authorization': user.sessionToken ?? ''
    });
    if (response.statusCode == 401) {
      Get.snackbar('Error', 'Sin autorización.');
      return [];
    }
    List<Chat> chats = Chat.fromJsonList(response.body);
    return chats;
  }
}
