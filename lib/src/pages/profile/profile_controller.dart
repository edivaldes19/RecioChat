import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recio_chat/src/models/user.dart';

class ProfileController extends GetxController {
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;
  void goToProfileEdit() {
    Get.toNamed('/profile/edit');
  }

  void goToViewImage() {
    Get.toNamed('/view_image', arguments: {'view_user': user.toJson()});
  }

  void showAlertDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
        onPressed: () => Get.back(), child: const Text('Cancelar'));
    Widget acceptButton = ElevatedButton(
        onPressed: () {
          Get.back();
          signOut();
        },
        child: const Text('Cerrar sesión'));
    AlertDialog alertDialog = AlertDialog(
        title: const Text('¿Está seguro de realizar está acción?'),
        actions: [cancelButton, acceptButton]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
    Fluttertoast.showToast(msg: 'Nos vemos pronto...');
  }
}
