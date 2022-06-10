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
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
      ListTile(leading: _iconBack(), title: _textRegister()),
      _imageUser(context),
      _textFieldEmail(),
      _textFieldName(),
      _textFieldLastName(),
      _textFieldPhone(),
      _textFieldPassword(),
      _textFieldConfirmPassword(),
      _buttonRegister(context)
    ]))));
  }

  Widget _buttonRegister(BuildContext ctx) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(25),
        child: ElevatedButton(
            onPressed: () => con.register(ctx),
            style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 5)),
            child: const Text('Registrarme')));
  }

  Widget _iconBack() {
    return IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back, color: MyColors.primaryColor));
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
                backgroundColor: Colors.grey[200])));
  }

  Widget _textFieldConfirmPassword() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: TextField(
            maxLength: 50,
            textInputAction: TextInputAction.done,
            controller: con.confirmPasswordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
                hintText: 'Confirmar contraseña',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.lock, color: MyColors.primaryColor))));
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

  Widget _textFieldLastName() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: TextField(
            maxLength: 50,
            textInputAction: TextInputAction.next,
            controller: con.lastnameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                hintText: 'Apellido(s)',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.person, color: MyColors.primaryColor))));
  }

  Widget _textFieldName() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: TextField(
            maxLength: 50,
            textInputAction: TextInputAction.next,
            controller: con.nameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                hintText: 'Nombre(s)',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.person, color: MyColors.primaryColor))));
  }

  Widget _textFieldPassword() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: TextField(
            maxLength: 50,
            textInputAction: TextInputAction.next,
            controller: con.passwordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
                hintText: 'Contraseña',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.lock, color: MyColors.primaryColor))));
  }

  Widget _textFieldPhone() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: TextField(
            maxLength: 10,
            textInputAction: TextInputAction.next,
            controller: con.phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                hintText: 'Teléfono',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.phone, color: MyColors.primaryColor))));
  }

  Widget _textRegister() {
    return Container(
        margin: const EdgeInsets.only(bottom: 25),
        child: const Text('Completa el formulario',
            style: TextStyle(
                color: MyColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)));
  }
}
