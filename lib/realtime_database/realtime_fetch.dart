import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FetchRealTimeData extends StatefulWidget {
  const FetchRealTimeData({super.key});

  @override
  State<FetchRealTimeData> createState() => _FetchRealTimeDataState();
}

class _FetchRealTimeDataState extends State<FetchRealTimeData> {
  final Stream<DatabaseEvent> databaseRef = FirebaseDatabase.instance
      .ref()
      .child('/path/user/time/NSAogYMvWYDDyLZm6b0')
      .onValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer"),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: databaseRef,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('Loading...');
          } else {
            // Access the data from the snapshot object
            dynamic data = snapshot.data?.snapshot.value;

            // Do something with the data
            return Center(
                child: Text(
              '$data',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ));
          }
        },
      ),
    );
  }
}
