import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/pages/login/login_controller.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class LoginPage extends StatelessWidget {
  LoginController con = Get.put(LoginController());
  LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
      _textLogin(),
      _imageIconApp(context),
      _textFieldEmail(),
      _textFieldPassword(),
      _buttonLogin(),
      _textDontHaveAccount()
    ]))));
  }

  Widget _buttonLogin() {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(25),
        child: ElevatedButton(
            onPressed: () => con.login(),
            style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 5)),
            child: const Text('Iniciar sesión')));
  }

  Widget _imageIconApp(BuildContext ctx) {
    return Container(
        margin: const EdgeInsets.all(25),
        child: Image.asset('assets/img/icon_app.png', width: 200, height: 200));
  }

  Widget _textDontHaveAccount() {
    return Container(
        margin: const EdgeInsets.all(25),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('¿No tienes cuenta?...',
                  style: TextStyle(color: MyColors.primaryColor)),
              const SizedBox(width: 10),
              GestureDetector(
                  onTap: () => con.goToRegisterPage(),
                  child: const Text('Registrate aquí',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor)))
            ])));
  }

  Widget _textFieldEmail() {
    return Container(
        margin: const EdgeInsets.only(left: 25, right: 25, bottom: 5, top: 25),
        child: TextField(
            maxLength: 50,
            textInputAction: TextInputAction.next,
            controller: con.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: 'Correo electrónico',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.email, color: MyColors.primaryColor))));
  }

  Widget _textFieldPassword() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: TextField(
            maxLength: 50,
            textInputAction: TextInputAction.done,
            controller: con.passwordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
                hintText: 'Contraseña',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.lock, color: MyColors.primaryColor))));
  }

  Widget _textLogin() {
    return Container(
        margin: const EdgeInsets.all(25),
        child: const Text('Bienvenido(a)',
            style: TextStyle(
                color: MyColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)));
  }
}
