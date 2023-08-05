import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myapp/animation/animation_demo.dart';

bool isCountdown = true;
int randomNumber = 0;
double wallet = 100.00;

class BustaBit5 extends StatefulWidget {
  const BustaBit5({super.key});

  @override
  State<BustaBit5> createState() => _BustaBit5State();
}

class _BustaBit5State extends State<BustaBit5> {
  final ScrollController _controller = ScrollController();

  Timer? timer;
  Duration duration = const Duration();

  int _milliseconds = 0;
  int _seconds = 0;

  double winChance = 0.0;
  // int _minutes = 0;

  String time = "";

  final countDownDuration = const Duration(seconds: 8);

  final _formKey = GlobalKey<FormState>();
  final _betController = TextEditingController();
  final _payoutController = TextEditingController();

  double sum = 0;
  double betNumber = 0.0, payoutNumber = 0.0, profitNumber = 0.0;

  List<String> pastNumbers = [];

  List<BetHistory> betHistory = [];

  void changeWinChances() {
    if (_payoutController.text.isNotEmpty) {
      if (_payoutController.text == "1") {
        setState(() {
          winChance = 0.0;
        });
      } else {
        setState(() {
          winChance = (100 / (double.parse(_payoutController.text)));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void reset() {
    setState(() {
      if (isCountdown) {
        setState(() {
          if (time.isNotEmpty) {
            pastNumbers.add(time);

            if (payoutNumber <=
                double.parse(time.replaceAll(":", ".").toString())) {
              betHistory.add(BetHistory(
                betAmount: betNumber.toString(),
                profit: profitNumber.toString(),
                bust: time,
                time: DateTime.now(),
              ));
            } else {
              betHistory.add(BetHistory(
                betAmount: betNumber.toString(),
                profit: "-${betNumber.toString()}",
                bust: time,
                time: DateTime.now(),
              ));
            }

            betHistory.sort(
              (a, b) => b.time.compareTo(a.time),
            );

            setState(() {});
            _controller.animateTo(
              _controller.position.maxScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
            addBitAmountToWallet();
          }
          duration = countDownDuration;
        });

        setState(() {});
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

  void addBitAmountToWallet() {
    if (betNumber != 0.0 && payoutNumber != 0.0) {
      if (payoutNumber <= double.parse(time.replaceAll(":", ".").toString())) {
        setState(() {
          wallet += (sum + betNumber);
        });
      }
    }
    setState(() {
      betNumber = 0.0;
      payoutNumber = 0.0;
      profitNumber = 0.0;
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
    if (resets) {
      reset();
    }
  }

  String formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  // double get _wallet => wallet;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(115, 49, 45, 45),
          body: Column(
            children: [topBar(), bodyWidget()],
          )),
    );
  }

  Widget topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        TextButton.icon(
          onPressed: null,
          icon: const Icon(
            Icons.person,
            color: Colors.white,
          ),
          label: const Text("DEV TEAM",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              )),
        ),
        Text(
          "USDT : ${wallet.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
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
    );
  }

  Widget bodyWidget() {
    return Column(
      children: [
        topBody(),
        middelBody(),
        bottomBody(),
      ],
    );
  }

  Widget topBody() {
    String twoDigits(int n) => n.toString().padLeft(1, '0');
    // final milliSeconds = twoDigits(duration.inMilliseconds.remainder(100));
    time = '${formatTime(_seconds)}:${formatTime(_milliseconds)}';
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage("assets/bg.gif")),
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10)),
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 15,
                  child: ListView.builder(
                    controller: _controller,
                    reverse: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: pastNumbers.length,
                    itemBuilder: (context, index) {
                      return Text("${pastNumbers[index]}x  ");
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
          isCountdown ? const SizedBox() : const AnimationDemo(),
        ],
      ),
    );
  }

  Widget middelBody() {
    return Form(
      key: _formKey,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Bet",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: TextFormField(
                      controller: _betController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        if (_payoutController.text.isNotEmpty &&
                            _betController.text.isNotEmpty) {
                          setState(() {
                            sum = double.parse(_betController.text) *
                                (double.parse(_payoutController.text) - 1);
                          });
                        }
                      },
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                      cursorColor: Colors.red,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
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
                mainAxisSize: MainAxisSize.min,
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
                    height: 45,
                    child: TextFormField(
                      controller: _payoutController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: (value) {
                        changeWinChances();
                        if (_betController.text.isNotEmpty &&
                            _payoutController.text.isNotEmpty) {
                          setState(() {
                            sum = double.parse(_betController.text) *
                                (double.parse(_payoutController.text) - 1);
                          });
                        }
                      },
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                      cursorColor: Colors.white,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("Target Profit :"),
                            Text(
                              "${sum.toStringAsFixed(2)} bits",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Win Chance : "),
                            Text(
                              winChance.toStringAsFixed(2),
                              style: const TextStyle(
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
                      isCountdown
                          ? setState(() {
                              if (_formKey.currentState!.validate()) {
                                if (wallet >=
                                    double.parse(_betController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('Your bet added')),
                                  );
                                  wallet -= double.parse(_betController.text);

                                  setState(() {
                                    betNumber =
                                        double.parse(_betController.text);
                                    payoutNumber =
                                        double.parse(_payoutController.text);

                                    profitNumber = sum;

                                    profitNumber =
                                        double.parse(sum.toStringAsFixed(2));
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text('Low balance')),
                                  );
                                }
                              }
                            })
                          : null;
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
        ),
      ),
    );
  }

  bottomBody() {
    TextStyle textstyle =
        const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600);
    TextStyle textstyle2 =
        const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Bet History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FittedBox(
                child: DataTable(
                  sortColumnIndex: 3,
                  headingRowHeight: 80.0,
                  columns: [
                    DataColumn(
                        label: Text(
                      'BUST',
                      style: textstyle,
                    )),
                    DataColumn(
                        label: Text(
                      'BET',
                      style: textstyle,
                    )),
                    DataColumn(
                        label: Text(
                      'PROFIT',
                      style: textstyle,
                      overflow: TextOverflow.ellipsis,
                    )),
                    DataColumn(
                        label: Text(
                      'Time',
                      style: textstyle,
                    )),
                  ],
                  rows: betHistory.map((data) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          data.bust,
                          style: textstyle2,
                        )),
                        DataCell(data.betAmount == "0.0"
                            ? const Text("--")
                            : Text(
                                data.betAmount,
                                style: textstyle2,
                              )),
                        DataCell(data.profit == "0.0"
                            ? const Text("--")
                            : Text(
                                data.profit,
                                style: textstyle2,
                              )),
                        DataCell(Text(
                          DateFormat("dd/MM/yyyy \nhh:mm a").format(data.time),
                          style: textstyle2,
                        ))
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BetHistory {
  String betAmount, profit, bust;
  DateTime time;

  BetHistory({
    required this.betAmount,
    required this.profit,
    required this.bust,
    required this.time,
  });
}
