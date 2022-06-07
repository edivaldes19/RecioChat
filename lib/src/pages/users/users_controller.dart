import 'package:chat_udemy/src/models/user.dart';
import 'package:chat_udemy/src/providers/users_provider.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {

  UsersProvider usersProvider = UsersProvider();

  Future<List<User>> getUsers() async {
    return await usersProvider.getUsers();
  }

  void goToChat(User user) {
    Get.toNamed('/messages', arguments: {
      'user': user.toJson()
    });
  }

}