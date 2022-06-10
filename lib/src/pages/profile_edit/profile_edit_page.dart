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
            title: const Text('Perfil'),
            backgroundColor: MyColors.primaryColor),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          const SizedBox(height: 50),
          _imageUser(context),
          const SizedBox(height: 25),
          _textFieldName(),
          _textFieldLastName(),
          _textFieldPhone(),
          _buttonUpdateProfile(context)
        ]))));
  }

  Widget _buttonUpdateProfile(BuildContext ctx) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(25),
        child: ElevatedButton(
            onPressed: () => con.updateUser(ctx),
            style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 5)),
            child: const Text('Editar perfil')));
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
                radius: 50,
                backgroundColor: Colors.grey[300])));
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

  Widget _textFieldPhone() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: TextField(
            maxLength: 10,
            textInputAction: TextInputAction.done,
            controller: con.phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                hintText: 'Teléfono',
                prefix: Text('+52'),
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: MyColors.primaryColorDark),
                prefixIcon: Icon(Icons.phone, color: MyColors.primaryColor))));
  }
}
