import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/models/user.dart';

class UserInfoController extends GetxController {
  User userChat = User.fromJson(Get.arguments['userChat']);
  void callNumber() async {
    if (userChat.phone != null) {
      if (userChat.phone!.length == 10) {
        await FlutterPhoneDirectCaller.callNumber(userChat.phone!);
      } else {
        Get.snackbar('Error', 'Número de teléfono inválido.');
      }
    } else {
      Get.snackbar('Error', 'El número no existe.');
    }
  }

  void goToProfileEdit() {
    Get.toNamed('/profile/edit');
  }

  void goToViewImage() {
    Get.toNamed('/view_image', arguments: {'view_user': userChat.toJson()});
  }
}
