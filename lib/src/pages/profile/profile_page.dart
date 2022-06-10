import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/pages/profile/profile_controller.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class ProfilePage extends StatelessWidget {
  ProfileController con = Get.put(ProfileController());
  ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SpeedDial(
            backgroundColor: MyColors.primaryColor,
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  onTap: () => con.showAlertDialog(context),
                  child: const Icon(Icons.exit_to_app),
                  label: 'Cerrar sesión'),
              SpeedDialChild(
                  onTap: () => con.goToProfileEdit(),
                  child: const Icon(Icons.edit),
                  label: 'Editar perfil')
            ]),
        body: Obx(() => SafeArea(
                child: SingleChildScrollView(
                    child: Column(children: [
              circleImageUser(),
              const SizedBox(height: 20),
              userInfo(
                  con.user.value.name != null && con.user.value.lastname != null
                      ? '${con.user.value.name} ${con.user.value.lastname}'
                      : 'Desconocido',
                  'Nombre(s) y apellido(s)',
                  Icons.person),
              userInfo(con.user.value.email ?? 'Desconocido',
                  'Correo electrónico', Icons.email),
              userInfo(con.user.value.phone ?? 'Desconocido', 'Teléfono',
                  Icons.phone),
              userInfo(con.user.value.updatedAt ?? 'Desconocido',
                  'Última actualización', Icons.update),
              userInfo(con.user.value.createdAt ?? 'Desconocido',
                  'Fecha de creación', Icons.date_range),
              const SizedBox(height: 20)
            ])))));
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
                        image:
                            con.user.value.image ?? Environment.IMAGE_URL)))));
  }

  Widget userInfo(String title, String subtitle, IconData iconData) {
    return ListTile(
        title: Text(title), subtitle: Text(subtitle), leading: Icon(iconData));
  }
}
