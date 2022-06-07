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
        body: SizedBox(
            width: double.infinity,
            child: Stack(children: [
              Positioned(top: -80, left: -100, child: _circleLogin()),
              Positioned(top: 60, left: 25, child: _textLogin()),
              SingleChildScrollView(
                  child: Column(children: [
                _imageBanner(context),
                _textFieldEmail(),
                _textFieldPassword(),
                _buttonLogin(),
                _textDontHaveAccount()
              ]))
            ])));
  }

  Widget _buttonLogin() {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: ElevatedButton(
            onPressed: () => con.login(),
            style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text('Iniciar sesión')));
  }

  Widget _circleLogin() {
    return Container(
        width: 240,
        height: 230,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: MyColors.primaryColor));
  }

  Widget _imageBanner(BuildContext ctx) {
    return Container(
        margin: EdgeInsets.only(
            top: 130, bottom: MediaQuery.of(ctx).size.height * 0.22),
        child: Image.asset('assets/img/chat.png', width: 200, height: 200));
  }

  Widget _textDontHaveAccount() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('¿No tienes cuenta?',
          style: TextStyle(color: MyColors.primaryColor)),
      const SizedBox(width: 7),
      GestureDetector(
          onTap: () => Get.toNamed('/register'),
          child: Text('Registrate',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: MyColors.primaryColor)))
    ]);
  }

  Widget _textFieldEmail() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: TextField(
            controller: con.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'Correo electrónico',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.email, color: MyColors.primaryColor))));
  }

  Widget _textFieldPassword() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: TextField(
            controller: con.passwordController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Contraseña',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.lock, color: MyColors.primaryColor))));
  }

  Widget _textLogin() {
    return const Text('Bienvenido(a)',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'NimbusSans'));
  }
}
