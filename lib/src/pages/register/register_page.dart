import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/pages/register/register_controller.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class RegisterPage extends StatelessWidget {
  RegisterController con = Get.put(RegisterController());
  RegisterPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            width: double.infinity,
            child: Stack(children: [
              Positioned(top: -80, left: -100, child: _circleLogin()),
              Positioned(top: 65, left: 27, child: _textRegister()),
              Positioned(top: 53, left: -5, child: _iconBack()),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 150),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    _imageUser(context),
                    const SizedBox(height: 30),
                    _textFieldEmail(),
                    _textFieldName(),
                    _textFieldLastName(),
                    _textFieldPhone(),
                    _textFieldPassword(),
                    _textFieldConfirmPassword(),
                    _buttonRegister(context)
                  ])))
            ])));
  }

  Widget _buttonRegister(BuildContext ctx) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: ElevatedButton(
            onPressed: () => con.register(ctx),
            style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text('Registrarme')));
  }

  Widget _circleLogin() {
    return Container(
        width: 240,
        height: 230,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: MyColors.primaryColor));
  }

  Widget _iconBack() {
    return IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white));
  }

  Widget _imageUser(BuildContext ctx) {
    return GestureDetector(
        onTap: () => con.showAlertDialog(ctx),
        child: GetBuilder<RegisterController>(
            builder: (value) => CircleAvatar(
                backgroundImage: con.imageFile != null
                    ? FileImage(con.imageFile!)
                    : const AssetImage('assets/img/user.png') as ImageProvider,
                radius: 60,
                backgroundColor: Colors.grey[300])));
  }

  Widget _textFieldConfirmPassword() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: TextField(
            controller: con.confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Confirmar Contraseña',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.lock, color: MyColors.primaryColor))));
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

  Widget _textFieldLastName() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: TextField(
            controller: con.lastnameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: 'Apellido',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon:
                    Icon(Icons.person_outline, color: MyColors.primaryColor))));
  }

  Widget _textFieldName() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: TextField(
            controller: con.nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: 'Nombre',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.person, color: MyColors.primaryColor))));
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

  Widget _textFieldPhone() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
        decoration: BoxDecoration(
            color: MyColors.primaryOpacityColor,
            borderRadius: BorderRadius.circular(30)),
        child: TextField(
            controller: con.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: 'Telefono',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(15),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.phone, color: MyColors.primaryColor))));
  }

  Widget _textRegister() {
    return const Text('Completa el formulario',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22));
  }
}
