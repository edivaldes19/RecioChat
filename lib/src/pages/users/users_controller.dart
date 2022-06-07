import 'package:get/get.dart';
import 'package:recio_chat/src/models/user.dart';
import 'package:recio_chat/src/providers/users_provider.dart';

class UsersController extends GetxController {
  UsersProvider usersProvider = UsersProvider();
  Future<List<User>> getUsers() async {
    return await usersProvider.getUsers();
  }

  void goToChat(User user) {
    Get.toNamed('/messages', arguments: {'user': user.toJson()});
  }
}
