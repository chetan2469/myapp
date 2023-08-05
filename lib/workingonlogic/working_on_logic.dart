import 'dart:async';

import 'package:flutter/material.dart';

class WorkingOnLogic extends StatefulWidget {
  const WorkingOnLogic({super.key});

  @override
  State<WorkingOnLogic> createState() => _WorkingOnLogicState();
}

class _WorkingOnLogicState extends State<WorkingOnLogic> {
  // Wallet
  double _wallet = 100000;
  double get wallet => _wallet;

  // Timer for timer logic
  Timer? timer;
  Duration duration = const Duration();
  int time = 0;

  // to check reverse
  bool isReverse = false;

  // Timer for Reverse Timer of 5 secs
  Timer? timer2;
  Duration duration2 = const Duration(seconds: 5);

  // bool isReverse2
  bool isReverse2 = false;

  // milliseconds
  int milliSeconds = 0;
  // seconds
  int seconds = 0;

  //
  //
  //
  // Init State
  @override
  void initState() {
    super.initState();
    startTimer();
    startTimer2();
  }

  //
  //
  //
  //Start Timer 1
  //

  void startTimer() async {
    if (!isReverse) {
      setState(() {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            time = duration.inSeconds + 1;
            duration = Duration(seconds: time);
          });
        });
      });
    } else {
      timer?.cancel();
      isReverse = false;
      startTimer();
    }
  }

//
//
//
//  Reverse Timer 1
//
//
  void reverseTimer() async {
    if (isReverse) {
      setState(() {
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (time > 0) {
              time = duration.inSeconds - 1;
              duration = Duration(seconds: time);
            } else {
              timer.cancel();
            }
          });
        });
      });
    } else {
      timer?.cancel();
      isReverse = true;
      reverseTimer();
    }
  }

  void startTimer2() {
    setState(() {
      if (!isReverse2) {
        timer2 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
          setState(() {
            if (milliSeconds > 1000) {
              if (seconds >= 5) {
                seconds = 0;
              } else {
                seconds += 1;
              }
              milliSeconds = 0;
            } else {
              milliSeconds += 10;
            }
          });
        });
      }
    });
  }

  void reverseTimer2() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String times = duration.inSeconds.remainder(1000).toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workig on Logic"),
        actions: [Chip(label: Text("$wallet"))],
      ),
      body: ListView(
        children: [
          // Button to add chip Amount By one
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _wallet++;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Chip Amount by 1"),
          ),
          // Checking Timer Watch
          Text(times.toString()),
          // Button to Stop Timer
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                timer?.cancel();
              });
            },
            icon: const Icon(Icons.stop),
            label: const Text("Button to Stop Timer"),
          ),
          // Button to Restart Timer
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                startTimer();
              });
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text("Button to Start Timer"),
          ),
          // Button to Reverse Timer
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                reverseTimer();
              });
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            label: const Text("Button to Reverse Timer"),
          ),
          // Showing 5 seconds in different Logic
          Text("$seconds : ${(milliSeconds / 10).toStringAsFixed(0)}"),
          // Button to Reverse Timer
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                reverseTimer2();
              });
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            label: const Text("Button to Reverse Timer2"),
          ),
        ],
      ),
    );
  }
}
