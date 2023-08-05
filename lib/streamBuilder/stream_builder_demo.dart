// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StreamBuilderDemo extends StatefulWidget {
  const StreamBuilderDemo({Key? key}) : super(key: key);

  @override
  _StreamBuilderDemoState createState() => _StreamBuilderDemoState();
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('admission').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.requireData.docChanges.isEmpty) {
              return const Center(
                child: Text(
                  "Dont have any data",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(230, 0, 36, 87)),
                ),
              );
            }
            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                return Text(
                  data.docs[index]['name'],
                );
              },
            );
          }),
    );
  }
}
