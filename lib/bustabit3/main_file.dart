import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

bool isCountdown = true;
int randomNumber = 0;
double wallet = 100.89;

class BustaBit3MainScreen extends StatefulWidget {
  const BustaBit3MainScreen({super.key});

  @override
  State<BustaBit3MainScreen> createState() => _BustaBit3MainScreenState();
}

class _BustaBit3MainScreenState extends State<BustaBit3MainScreen> {
  double get _wallet => wallet;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          // For App Bar
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "BaB",
                  style: TextStyle(
                    color: Colors.orange,
                    fontFamily: 'Fjalla One',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(
                Icons.person,
                color: Colors.white,
              ),
              const Text(
                "Sandesh",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .03,
              ),
              Text(
                "USDT : ${_wallet.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .03,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),

          // For the Game Screen
          Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .5,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .5,
                child: const BustaBit3GameScreen(),
              ),
            ],
          ),

          // For User Betting
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .5,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .45,
                child: const BustBit3UserScreen(),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .65,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .65,
                child: const Placeholder(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BustaBit3GameScreen extends StatefulWidget {
  const BustaBit3GameScreen({super.key});

  @override
  State<BustaBit3GameScreen> createState() => _BustaBit3GameScreenState();
}

class _BustaBit3GameScreenState extends State<BustaBit3GameScreen> {
  Timer? timer;
  Duration duration = const Duration();

  int _milliseconds = 0;
  int _seconds = 0;
  // int _minutes = 0;

  String time = "";

  final countDownDuration = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void reset() {
    setState(() {
      if (isCountdown) {
        print(time);

        setState(() {
          duration = countDownDuration;
        });
      } else {
        setState(() {
          duration = const Duration();
          _milliseconds = 0;
          _seconds = 0;
          // _minutes = 0;
        });
      }
    });
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;
    // final addMilli = isCountdown ? -1 : 1;
    setState(() {
      if (isCountdown) {
        final seconds = duration.inSeconds + addSeconds;
        if (seconds <= 0) {
          timer?.cancel();

          setState(() {
            isCountdown = false;
          });
          startTimer();
        } else {
          duration = Duration(seconds: seconds);
        }
      } else {}
    });
  }

  void startTimer({bool resets = true}) {
    setState(() {
      randomNumber = Random().nextBool()
          ? Random().nextInt(10) + 1
          : Random().nextInt(2) + 1;
    });

    if (resets) {
      reset();
    }
    // timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    if (isCountdown) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    } else {
      timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _milliseconds += 1;

          if (_milliseconds >= 100) {
            _milliseconds = 0;
            _seconds++;

            if (_seconds >= randomNumber) {
              _seconds = 0;
              timer.cancel();
              isCountdown = true;
              startTimer();
              // _minutes++;
            }
          }
        });
      });
    }
  }

  void stopTimer({bool resets = true}) {
    print(resets);
    if (resets) {
      reset();
    }
  }

  String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(1, '0');
    // final milliSeconds = twoDigits(duration.inMilliseconds.remainder(100));
    time = '${formatTime(_seconds)}:${formatTime(_milliseconds)}';
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black, width: 5),
            ),
            child: isCountdown
                ? Text(
                    "Place your Bets before $seconds",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Text(
                    " $time X",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class BustBit3UserScreen extends StatefulWidget {
  const BustBit3UserScreen({super.key});

  @override
  State<BustBit3UserScreen> createState() => _BustBit3UserScreenState();
}

class _BustBit3UserScreenState extends State<BustBit3UserScreen> {
  bool checkCountDown = true;
  double sum = 0;
  final _formKey = GlobalKey<FormState>();
  final _betController = TextEditingController();
  final _payoutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isCountdown) {
      setState(() {
        checkCountDown = true;
      });
    } else {
      setState(() {
        checkCountDown = false;
      });
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orangeAccent),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Bet",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                width: 180,
                height: 40,
                child: TextFormField(
                  controller: _betController,
                  style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  cursorColor: Colors.orange,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orangeAccent,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orangeAccent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orangeAccent,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orangeAccent,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please place your Bet';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  border: Border.all(color: Colors.orangeAccent),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "bits",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2, bottom: 2, left: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 87, 87, 87),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Payout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                width: 180,
                height: 40,
                child: TextFormField(
                  controller: _payoutController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  cursorColor: Colors.white,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Payout time';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 87, 87, 87),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "X",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                // padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("    Target Profit : "),
                        Text(
                          "$sum bits",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text("Win Chance : "),
                        Text(
                          "11%",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      wallet -= double.parse(_betController.text);
                      sum = double.parse(_betController.text) *
                          double.parse(_payoutController.text);

                      wallet += sum;

                      debugPrint(".............$sum");
                    }
                  });
                },
                child: Container(
                  height: 40,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "B E T",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
