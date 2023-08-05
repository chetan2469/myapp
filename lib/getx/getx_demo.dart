import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/getx/home_controller.dart';

class GetxDemo extends StatefulWidget {
  const GetxDemo({super.key});

  @override
  State<GetxDemo> createState() => _GetxDemoState();
}

class _GetxDemoState extends State<GetxDemo> {
  final HomePageController controller = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Getx Demo")),
      body: Center(
        child: Column(
          children: [
            Obx(
              () => Text(
                '${controller.count.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Obx(() =>
                Text(controller.user.isEmpty ? "" : controller.user[0].name)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.increment();
          UserData u = UserData("sameer", "2");
          controller.user.add(u);
        },
        tooltip: 'Increment',
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add),
      ),
    );
  }
}
