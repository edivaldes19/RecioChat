import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/pages/profile/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  ProfileController con = Get.put(ProfileController());
  ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              heroTag: "btn1",
              onPressed: () => con.goToProfileEdit(),
              backgroundColor: Colors.lightBlueAccent,
              child: const Icon(Icons.edit)),
          const SizedBox(height: 10),
          FloatingActionButton(
              heroTag: "btn2",
              onPressed: () => con.signOut(),
              backgroundColor: Colors.green,
              child: const Icon(Icons.power_settings_new))
        ]),
        body: Obx(() => SafeArea(
                child: Column(children: [
              circleImageUser(),
              const SizedBox(height: 20),
              userInfo(
                  'Nombre del usuario',
                  '${con.user.value.name ?? 'Desconocido'} ${con.user.value.lastname ?? 'Desconocido'}',
                  Icons.person),
              userInfo('Correo electrónico',
                  con.user.value.email ?? 'Desconocido', Icons.email),
              userInfo('Teléfono', con.user.value.phone ?? 'Desconocido',
                  Icons.phone)
            ]))));
  }

  Widget circleImageUser() {
    return Center(
        child: Container(
            margin: const EdgeInsets.only(top: 30),
            width: 200,
            child: AspectRatio(
                aspectRatio: 1,
                child: ClipOval(
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: 'assets/img/user_profile_2.png',
                        image: con.user.value.image ??
                            'https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898-450x450.png')))));
  }

  Widget userInfo(String title, String subtitle, IconData iconData) {
    return Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            leading: Icon(iconData)));
  }
}
