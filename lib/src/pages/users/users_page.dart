import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/pages/users/users_controller.dart';
import 'package:recio_chat/src/utils/my_colors.dart';
import 'package:recio_chat/src/widgets/no_data_widget.dart';

class UsersPage extends StatelessWidget {
  UsersController con = Get.put(UsersController());
  UsersPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Usuarios'),
            automaticallyImplyLeading: false,
            backgroundColor: MyColors.primaryColor),
        body: SafeArea(
            child: FutureBuilder(
                future: con.getUsers(),
                builder: (context, AsyncSnapshot<List<User>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.isNotEmpty == true) {
                      return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return cardUser(snapshot.data![index]);
                          });
                    } else {
                      return NoDataWidget(
                          warning: 'Actualmente eres el único usuario.');
                    }
                  } else {
                    return NoDataWidget(
                        warning: 'Actualmente eres el único usuario.');
                  }
                })));
  }

  Widget cardUser(User user) {
    return ListTile(
        onTap: () => con.goToChat(user),
        title: Text(
            user.name != null && user.lastname != null
                ? '${user.name} ${user.lastname}'
                : 'Desconocido',
            style: const TextStyle(fontSize: 14)),
        subtitle: Text(user.email ?? 'Desconocido',
            style: const TextStyle(fontSize: 12)),
        leading: AspectRatio(
            aspectRatio: 1,
            child: ClipOval(
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: 'assets/img/user.png',
                    image: user.image ?? Environment.IMAGE_URL))));
  }
}
