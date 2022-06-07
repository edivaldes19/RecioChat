import 'package:flutter/cupertino.dart';
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
  void goToHomePage() {
    Get.offNamedUntil('/home', (route) => false);
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      ResponseApi responseApi = await usersProvider.login(email, password);
      if (responseApi.success == true) {
        User user = User.fromJson(responseApi.data);
        storage.write('user', user.toJson());
        goToHomePage();
      } else {
        Get.snackbar('Error', 'Al iniciar sesión.');
      }
    } else {
      Get.snackbar('Error', 'Aún quedan campos vacíos.');
    }
  }
}
