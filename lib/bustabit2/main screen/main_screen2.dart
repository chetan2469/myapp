import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

bool isCountdown = true;

class BustaBitMainScreen2 extends StatefulWidget {
  const BustaBitMainScreen2({super.key});

  @override
  State<BustaBitMainScreen2> createState() => _BustaBitMainScreen2State();
}

class _BustaBitMainScreen2State extends State<BustaBitMainScreen2> {
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
                margin: const EdgeInsets.all(20),
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
              SizedBox(
                width: MediaQuery.of(context).size.width * .08,
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
                width: MediaQuery.of(context).size.width * .05,
              ),
              const Text(
                "USDT : 0",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .1,
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
                height: MediaQuery.of(context).size.width * .7,
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
                height: MediaQuery.of(context).size.width * .7,
                child: const BustaBit2GameScreen(),
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
                height: MediaQuery.of(context).size.width * .7,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .7,
                child: const BustBit2UserScreen(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BustaBit2GameScreen extends StatefulWidget {
  const BustaBit2GameScreen({super.key});

  @override
  State<BustaBit2GameScreen> createState() => _BustaBit2GameScreenState();
}

class _BustaBit2GameScreenState extends State<BustaBit2GameScreen> {
  Timer? timer;
  Duration duration = const Duration();

  int _milliseconds = 0;
  int _seconds = 0;
  // int _minutes = 0;

  final countDownDuration = const Duration(seconds: 5);
  int randomNumber = 0;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void reset() {
    setState(() {
      if (isCountdown) {
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
    randomNumber = Random().nextBool()
        ? Random().nextInt(10) + 1
        : Random().nextInt(2) + 1;
    debugPrint(isCountdown.toString());
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
    String formattedTime =
        '${formatTime(_seconds)}:${formatTime(_milliseconds)}';
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
                    " $formattedTime X",
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

class BustBit2UserScreen extends StatefulWidget {
  const BustBit2UserScreen({super.key});

  @override
  State<BustBit2UserScreen> createState() => _BustBit2UserScreenState();
}

class _BustBit2UserScreenState extends State<BustBit2UserScreen> {
  int _amount = 1;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '$_amount');
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() {
      _amount = int.tryParse(_amountController.text) ?? 0;
      if (_amount < 0) {
        _amount = 0;
      }
    });
  }

  void _increaseAmount() {
    setState(() {
      _amount++;
      _amountController.text = '$_amount';
    });
  }

  void _decreaseAmount() {
    if (_amount > 0) {
      setState(() {
        _amount--;
        _amountController.text = '$_amount';
      });
    }
  }

  bool checkCountDown = true;

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.white,
                        ),
                        onPressed: _decreaseAmount,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                        onPressed: _increaseAmount,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _amountController.text = 1.toString();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "1",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _amountController.text = 2.toString();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Text(
                          "2",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _amountController.text = 3.toString();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: const Text(
                          "3",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _amountController.text = 4.toString();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: const Text(
                          "4",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {});
              },
              child: Container(
                height: 100,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orangeAccent,
                ),
                child: Text(
                  isCountdown
                      ? "Your Bet\nUSDT ${_amountController.text}"
                      : "Wait for next time",
                  style: const TextStyle(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
