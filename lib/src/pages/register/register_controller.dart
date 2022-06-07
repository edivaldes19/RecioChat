import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recio_chat/src/models/response_api.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/providers/users_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  UsersProvider usersProvider = UsersProvider();
  ImagePicker picker = ImagePicker();
  File? imageFile;
  void clearForm() {
    emailController.clear();
    nameController.clear();
    lastnameController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void goToHomePage() {
    Get.offNamedUntil('/home', (route) => false);
  }

  bool isValidForm(String email, String name, String lastname, String phone,
      String password, String confirmPassword) {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Debes ingresar el correo electrónico.');
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'El email que ingresaste no es valido.');
      return false;
    }
    if (name.isEmpty) {
      Get.snackbar('Error', 'Debes ingresar tu nombre.');
      return false;
    }
    if (lastname.isEmpty) {
      Get.snackbar('Error', 'Debes ingresar tu apellido.');
      return false;
    }
    if (phone.isEmpty) {
      Get.snackbar('Error', 'Debes ingresar tu numero de telefono.');
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Debes ingresar tu contraseña.');
      return false;
    }
    if (confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Debes confirmar tu contraseña.');
      return false;
    }
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Las contraseñas no coinciden.');
      return false;
    }
    if (imageFile == null) {
      Get.snackbar('Error', 'Debes seleccionar una imagen de perfil.');
      return false;
    }
    return true;
  }

  void register(BuildContext context) async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (isValidForm(email, name, lastname, phone, password, confirmPassword)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Creando cuenta...');
      User user = User(
          email: email,
          name: name,
          lastname: lastname,
          phone: phone,
          password: password);
      Stream stream = await usersProvider.createWithImage(user, imageFile!);
      stream.listen((res) {
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        progressDialog.close();
        if (responseApi.success == true) {
          clearForm();
          User user = User.fromJson(responseApi.data);
          GetStorage().write('user', user.toJson());
          goToHomePage();
        } else {
          Get.snackbar('No se pudo crear el usuario', responseApi.message!);
        }
      });
    }
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
        actions: [galleryButton, cameraButton]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
