import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DioDemo extends StatefulWidget {
  const DioDemo({super.key});

  @override
  State<DioDemo> createState() => _DioDemoState();
}

class _DioDemoState extends State<DioDemo> {
  bool isLoading = false;
  final dio = Dio();
  dynamic res;

  User? u;

  List users = [];

  void getHttp() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/todos/1');
    if (kDebugMode) {
      print("object");
      // print(response);

      setState(() {
        Map<String, dynamic> parsedJson = json.decode(response.toString());
        res = parsedJson;
        u = User.fromJson(parsedJson);
        users.add(u);
      });
      print(res);
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getHttp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dio demo"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(users[index].id.toString()),
                  ),
                  title: Text(users[index].title.toString()),
                  trailing: users[index].completed
                      ? const Icon(
                          Icons.done,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                );
              }),
    );
  }
}

class User {
  int userId;
  int id;
  String title;
  bool completed;

  User({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
