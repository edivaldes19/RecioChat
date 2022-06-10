import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:recio_chat/src/models/user.dart';

class ViewUserImageController extends GetxController {
  User myUser = User.fromJson(GetStorage().read('user') ?? {});
  User userView = User.fromJson(Get.arguments['view_user']);
  void saveImageToDevice() async {
    if (userView.image != null) {
      try {
        var imageId = await ImageDownloader.downloadImage(userView.image!);
        if (imageId == null) {
          return;
        }
        var fileName = await ImageDownloader.findName(imageId);
        Fluttertoast.showToast(msg: 'Imagen guardada como $fileName');
      } on PlatformException catch (error) {
        Get.snackbar('Error', error.toString());
      }
    } else {
      Get.snackbar('Error',
          '${userView.name} ${userView.lastname} no tiene foto de perfil.');
    }
  }
}
