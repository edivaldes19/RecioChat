import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recio_chat/src/models/response_api.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/pages/profile/profile_controller.dart';
import 'package:recio_chat/src/providers/users_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ProfileEditController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? imageFile;
  User user = User.fromJson(GetStorage().read('user') ?? {});
  UsersProvider usersProvider = UsersProvider();
  ProfileController profileController = Get.find();
  ProfileEditController() {
    nameController.text = user.name ?? 'Desconocido';
    lastnameController.text = user.lastname ?? 'Desconocido';
    phoneController.text = user.phone ?? 'Desconocido';
  }
  Future selectImage(ImageSource imageSource) async {
    final XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.gallery);
        },
        child: const Text('Galería'));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          selectImage(ImageSource.camera);
        },
        child: const Text('Cámara'));
    AlertDialog alertDialog = AlertDialog(
      title: const Text('Selecciona una imagen'),
      actions: [galleryButton, cameraButton],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void updateUser(BuildContext context) async {
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();
    User u = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        email: user.email,
        sessionToken: user.sessionToken,
        image: user.image);
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Actualizando perfil de usuario...');
    if (imageFile == null) {
      ResponseApi responseApi = await usersProvider.update(u);
      progressDialog.close();
      if (responseApi.success == true) {
        User userResponse = User.fromJson(responseApi.data);
        GetStorage().write('user', userResponse.toJson());
        profileController.user.value = userResponse;
        Get.snackbar('Éxito', responseApi.message!);
      } else {
        Get.snackbar('Error', responseApi.message!);
      }
    } else {
      Stream stream = await usersProvider.updateWithImage(u, imageFile!);
      stream.listen((res) {
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        progressDialog.close();
        if (responseApi.success == true) {
          User userResponse = User.fromJson(responseApi.data);
          GetStorage().write('user', userResponse.toJson());
          profileController.user.value = userResponse;
          Get.snackbar('Éxito', responseApi.message!);
        } else {
          Get.snackbar('Error', responseApi.message!);
        }
      });
    }
  }
}
