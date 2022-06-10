import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/api/environment.dart';
import 'package:recio_chat/src/utils/my_colors.dart';
import 'package:recio_chat/src/view_user_image/view_user_image_controller.dart';

class ViewImagePage extends StatelessWidget {
  ViewUserImageController con = Get.put(ViewUserImageController());
  ViewImagePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: con.myUser.name != null && con.userView.name != null
                ? con.myUser.id == con.userView.id
                    ? const Text('Mi foto de perfil')
                    : Text('Imagen de ${con.userView.name}')
                : const Text('Desconocido'),
            backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
            onPressed: () => con.saveImageToDevice(),
            tooltip: 'Guardar imagen en el dispositivo',
            backgroundColor: MyColors.primaryColor,
            child: const Icon(Icons.download)),
        body: SafeArea(
            child: Center(
                child: InteractiveViewer(
                    clipBehavior: Clip.none,
                    child: SizedBox(
                        width: double.infinity,
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/img/loading.png',
                            image: con.userView.image ??
                                Environment.IMAGE_URL))))));
  }
}
