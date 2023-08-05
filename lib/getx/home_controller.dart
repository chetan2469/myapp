import 'package:get/get.dart';

class HomePageController extends GetxController {
  final count = 0.obs;
  increment() => count.value++;

  List<UserData> user = <UserData>[].obs;

  List<UserData> get userDataModelValue => user;
}

class UserData {
  final String name;
  final String id;
  UserData(this.name, this.id);
}
