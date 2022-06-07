import 'package:chat_udemy/src/pages/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {

  ProfileController con = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () => con.goToProfileEdit(),
            child: Icon(Icons.edit),
            backgroundColor: Colors.lightBlueAccent,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () => con.signOut(),
            child: Icon(Icons.power_settings_new),
            backgroundColor: Colors.green,
          ),
        ],
      ),
      body: Obx( () =>
         SafeArea(
          child: Column(
            children: [
              circleImageUser(),
              SizedBox(height: 20),
              userInfo(
                  'Nombre del usuario',
                  '${con.user.value.name ?? ''} ${con.user.value.lastname ?? ''}',
                  Icons.person
              ),
              userInfo(
                  'Email',
                  con.user.value.email ?? '',
                  Icons.email
              ),
              userInfo(
                  'Telefono',
                  con.user.value.phone ?? '',
                  Icons.phone
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfo(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
      ),
    );
  }

  Widget circleImageUser() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        width: 200,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                placeholder: 'assets/img/user_profile_2.png',
                image: con.user.value.image ?? 'https://devshift.biz/wp-content/uploads/2017/04/profile-icon-png-898-450x450.png'
            ),
          ),
        ),
      ),
    );
  }
}
