import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recio_chat/src/models/user.dart';

class ProfileController extends GetxController {
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;
  void goToProfileEdit() {
    Get.toNamed('/profile/edit');
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false);
  }
}
