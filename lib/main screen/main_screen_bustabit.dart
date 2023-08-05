import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

Timer? timer;
Duration duration = const Duration();
bool isCountdown = true;
// final countDownDuration = const Duration(milliseconds: 5000);
const countDownDuration = Duration(seconds: 5);
int randomNumber = 0;

class MainScreenBustaBit extends StatefulWidget {
  const MainScreenBustaBit({super.key});

  @override
  State<MainScreenBustaBit> createState() => _MainScreenBustaBitState();
}

class _MainScreenBustaBitState extends State<MainScreenBustaBit> {
  // Get Value of Width
  double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get Value of Height and divide by 2.2
  double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height / 2.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BackGround Black
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                //
                // First Part Where
                SizedBox(
                  height: getHeight(context),
                  width: getWidth(context),
                  child: const ShowGameValues(),
                ),
                Container(
                  margin: EdgeInsets.only(top: getHeight(context) - 10),
                  child: SizedBox(
                    height: getHeight(context) * 1.15,
                    width: getWidth(context),
                    child: const UserScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShowGameValues extends StatefulWidget {
  const ShowGameValues({super.key});

  @override
  State<ShowGameValues> createState() => _ShowGameValuesState();
}

//
//
//
//
// Show Game Values Class

class _ShowGameValuesState extends State<ShowGameValues> {
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
        });
      }
    });
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;
    // final addMilli = isCountdown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      // final milli = duration.inMilliseconds + addMilli;

      if (seconds > randomNumber) {
        timer?.cancel();
        isCountdown = true;
        startTimer();
      } else if (seconds < 0) {
        timer?.cancel();
        isCountdown = false;
        startTimer();
      } else {
        duration = Duration(seconds: seconds);
      }
      // if (seconds > randomNumber) {
      //   timer?.cancel();
      //   isCountdown = true;
      //   startTimer();
      // } else if (milli < 0 || seconds < 0) {
      //   timer?.cancel();
      // } else {
      //   duration = Duration(milliseconds: milli);

      // }
    });
  }

  void startTimer({bool resets = true}) {
    randomNumber = Random().nextInt(10) + 1;
    if (resets) {
      reset();
    }
    // timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(1, '0');
    // final milliSeconds = twoDigits(duration.inMilliseconds.remainder(100));
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
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: isCountdown
                ? Text(
                    "Place your Bets before $seconds",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    "$seconds X",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

//
//
//
//
//
// USer Screen
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool hasBet = false;
  bool get isCountdownGet => isCountdown;
  bool checkBet = false;
  double _sliderValue = 10;

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * .1,
          ),
          Center(
            child: Slider(
                value: _sliderValue,
                divisions: 10,
                label: _sliderValue.toString(),
                max: 100,
                onChanged: (double value) {
                  setState(() {
                    _sliderValue = value;
                  });
                }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * .1,
          ),
          Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  if (checkBet) {
                    checkBet = false;
                    hasBet = true;
                  }
                  // else if (checkBet == false &&
                  //     isCountdownGet == false &&
                  //     hasBet) {
                  //   double sumWinAmount =
                  //       _sliderValue.toDouble() * randomNumber;
                  //   debugPrint(sumWinAmount.toString());
                  // }
                  else {
                    checkBet = true;
                    hasBet = false;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black, width: 4),
                  color: Colors.black,
                ),
                child: checkBet
                    ? const Text(
                        "Payout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const Text(
                        "Bet",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * .1,
          ),
          Center(
            child: Text(
              "Your Amount of Bet is : ${_sliderValue.toInt()}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
