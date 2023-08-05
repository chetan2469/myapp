// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Userdetailcalender extends StatefulWidget {
  final String id;
  final String selectedDate;
  const Userdetailcalender(
      {super.key, required this.id, required this.selectedDate});
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Userdetailcalender> {
  bool isLoading = false;

  String driverName = "";
  int driverMobile = 0;
  int openingKm = 0;
  int closingKm = 0;
  String checkInTime = "";
  String checkoutTime = "";

  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    setState(() {
      selectedDate = widget.selectedDate;
    });
    fetchDataFromApi();
  }

  fetchDataFromApi() async {
    setState(() {
      isLoading = true;
    });
    String url =
        "https://wilaton.com/api/trip/tripDate/6475d741b99d1a3604d7a9fb";
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'tripDate': selectedDate}));

    try {
      print(res.statusCode);
      if (res.statusCode == 200) {
        debugPrint(res.body);
        Map<String, dynamic> jsonMap = json.decode(res.body);

        setState(() {
          List<dynamic> dataArray = jsonMap['data'];
          for (var data in dataArray) {
            driverName = data['driverName'];
            driverMobile = data['driverMobile'];
            openingKm = data['openingUrl']['openingKm'];
            closingKm = data['closeingUrl']['closeingKm'];
            checkInTime = data["checkInTime"];
            checkoutTime = data["checkOutTime"];

            // Display values for each element
            print('Driver Name: $driverName');
            print('Driver Mobile: $driverMobile');
            print('Opening Km: $openingKm');
            print('Closing Km: $closingKm');
            print('----------------------------');
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Mobile number wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle any exceptions that occurred during the request
      print('Request error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15, left: 15, top: 0, bottom: 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              "History",
                              style: TextStyle(
                                fontSize: 19,
                                color: Color.fromRGBO(23, 14, 1, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text("",
                                style: TextStyle(
                                  color: Color.fromRGBO(23, 44, 88, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                            Text(
                              '785',
                              style: TextStyle(
                                color: Color.fromRGBO(23, 44, 88, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        const Divider(
                          thickness: 3,
                          color: Color.fromRGBO(20, 61, 121, 1.0),
                          height: 5,
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Container(
                          height: 410,
                          color: const Color.fromRGBO(235, 245, 254, 1.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 29,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Hyderabad S1",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Color.fromRGBO(23, 14, 1, 1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Divider(
                                    thickness: 3,
                                    color: Color.fromRGBO(20, 61, 121, 1.0),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 300,

                                    width: 92,
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, top: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: const [
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            "In Time:",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Out Time:",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 27,
                                          ),
                                          Text(
                                            "In km:",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Out km:",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "D Name:",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "D No:",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 27,
                                          ),
                                        ],
                                      ),
                                    ), //------------------------------------non change data
                                  ), // fixed data
                                  Container(
                                    height: 300,

                                    width: 135,

                                    color: const Color.fromRGBO(0, 0, 0, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, top: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            checkInTime,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            checkoutTime,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 27,
                                          ),
                                          const Text(
                                            "",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            "55754.55 km",
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            driverName,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            driverMobile.toString(),
                                            style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 44, 88, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 27,
                                          ),
                                        ],
                                      ),
                                    ),
                                    //-------------------------------------change data
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
