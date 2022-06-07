import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/pages/profile_edit/profile_edit_controller.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class ProfileEditPage extends StatelessWidget {
  ProfileEditController con = Get.put(ProfileEditController());
  ProfileEditPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Mi perfil'),
            backgroundColor: MyColors.primaryColor),
        bottomNavigationBar: _buttonRegister(context),
        body: SafeArea(
            child: Column(children: [
          const SizedBox(height: 50),
          _imageUser(context),
          const SizedBox(height: 20),
          _textFieldName(),
          _textFieldLastName(),
          _textFieldPhone()
        ])));
  }

  Widget _buttonRegister(BuildContext ctx) {
    return Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: ElevatedButton(
            onPressed: () => con.updateUser(ctx),
            style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text('Actualizar perfil')));
  }

  Widget _imageUser(BuildContext ctx) {
    return GestureDetector(
        onTap: () => con.showAlertDialog(ctx),
        child: GetBuilder<ProfileEditController>(
            builder: (value) => CircleAvatar(
                backgroundImage: con.imageFile != null
                    ? FileImage(con.imageFile!)
                    : con.user.image != null
                        ? NetworkImage(con.user.image!)
                        : const AssetImage('assets/img/user.png')
                            as ImageProvider,
                radius: 60,
                backgroundColor: Colors.grey[300])));
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
}
