import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/pages/user_info/user_info_controller.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class UserInfoPage extends StatelessWidget {
  UserInfoController con = Get.put(UserInfoController());
  UserInfoPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: con.userChat.name != null
                ? Text('Info. de ${con.userChat.name}')
                : const Text('Desconocido'),
            backgroundColor: MyColors.primaryColor),
        floatingActionButton: FloatingActionButton(
            onPressed: () => con.callNumber(),
            tooltip: con.userChat.phone != null
                ? 'Llamar a ${con.userChat.phone}'
                : 'Llamar',
            backgroundColor: MyColors.primaryColor,
            child: const Icon(Icons.call)),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          circleImageUser(),
          const SizedBox(height: 20),
          userInfo(
              con.userChat.name != null && con.userChat.lastname != null
                  ? '${con.userChat.name} ${con.userChat.lastname}'
                  : 'Desconocido',
              'Nombre(s) y apellido(s)',
              Icons.person),
          userInfo(con.userChat.email ?? 'Desconocido', 'Correo electrónico',
              Icons.email),
          userInfo(
              con.userChat.phone ?? 'Desconocido', 'Teléfono', Icons.phone),
          userInfo(con.userChat.updatedAt ?? 'Desconocido',
              'Última actualización', Icons.update),
          userInfo(con.userChat.createdAt ?? 'Desconocido', 'Fecha de creación',
              Icons.date_range),
          const SizedBox(height: 20)
        ]))));
  }

  Widget circleImageUser() {
    return GestureDetector(
        onTap: () => con.goToViewImage(),
        child: Container(
            margin: const EdgeInsets.only(top: 30),
            width: 200,
            child: AspectRatio(
                aspectRatio: 1,
                child: ClipOval(
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: 'assets/img/loading.png',
                        image: con.userChat.image ?? Environment.IMAGE_URL)))));
  }

  Widget userInfo(String title, String subtitle, IconData iconData) {
    return ListTile(
        title: Text(title), subtitle: Text(subtitle), leading: Icon(iconData));
  }
}
