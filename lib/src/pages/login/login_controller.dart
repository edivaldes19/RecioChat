import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recio_chat/src/models/response_api.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/providers/users_provider.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UsersProvider usersProvider = UsersProvider();
  GetStorage storage = GetStorage();
  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  bool isValidForm(String email, String password) {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Correo electrónico vacío.');
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Correo electrónico inválido.');
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Contraseña vacía.');
      return false;
    }
    return true;
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (isValidForm(email, password)) {
      ResponseApi responseApi = await usersProvider.login(email, password);
      if (responseApi.success == true) {
        User user = User.fromJson(responseApi.data);
        storage.write('user', user.toJson());
        Get.offNamedUntil('/home', (route) => false);
        Fluttertoast.showToast(msg: responseApi.message ?? 'Bienvenido(a)');
      } else {
        Get.snackbar('Error', responseApi.message ?? 'Error al iniciar sesión');
      }
    }
  }
}
