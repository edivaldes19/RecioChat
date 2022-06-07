import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recio_chat/src/pages/chats/chats_page.dart';
import 'package:recio_chat/src/pages/home/home_controller.dart';
import 'package:recio_chat/src/pages/profile/profile_page.dart';
import 'package:recio_chat/src/pages/users/users_page.dart';
import 'package:recio_chat/src/utils/my_colors.dart';

class HomePage extends StatelessWidget {
  HomeController con = Get.put(HomeController());
  HomePage({Key? key}) : super(key: key);
  Widget bottomNavigationBar(BuildContext ctx) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
            height: 54,
            child: BottomNavigationBar(
                showUnselectedLabels: true,
                showSelectedLabels: true,
                onTap: con.changeTabIndex,
                currentIndex: con.tabIndex.value,
                backgroundColor: MyColors.primaryColor,
                unselectedItemColor: Colors.white.withOpacity(0.5),
                selectedItemColor: Colors.white,
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.chat, size: 20),
                      label: 'Chats',
                      backgroundColor: MyColors.primaryColor),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.person, size: 20),
                      label: 'Usuarios',
                      backgroundColor: MyColors.primaryColor),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.person_pin_rounded, size: 20),
                      label: 'Mi perfil',
                      backgroundColor: MyColors.primaryColor)
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomNavigationBar(context),
        body: Obx(() => IndexedStack(
            index: con.tabIndex.value,
            children: [ChatsPage(), UsersPage(), ProfilePage()])));
  }
}
