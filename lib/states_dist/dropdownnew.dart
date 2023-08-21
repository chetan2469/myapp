// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:convert'; // for decoding JSON
import 'package:flutter/services.dart';
import 'package:myapp/states_dist/new.dart'; // for rootBundle

// class StateCityData {
//   final String state;
//   final List<String> cities;

//   StateCityData(this.state, this.cities);
// }

class NewDrop extends StatefulWidget {
  const NewDrop({super.key});

  @override
  _NewDropState createState() => _NewDropState();
}

class _NewDropState extends State<NewDrop> {
  List<StateCityDataModel> stateCityModel = [];
  List<StateCity> stateCityData = []; // To hold state-city data
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data from local JSON file
  }

  Future<void> _loadData() async {
    String jsonString = await rootBundle.loadString('assets/state_city.json');
    List<dynamic> data = json.decode(jsonString);
    for (var jsonCategory in data) {
      stateCityModel.add(StateCityDataModel.fromJson(jsonCategory));
      print(stateCityModel.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('State and City Dropdown'),
        ),
        body: Center(
          child: Column(
            children: [
              DropdownButton<String>(
                hint: Text('Select a state'),
                value: selectedState,
                onChanged: (newValue) {
                  setState(() {
                    selectedState = newValue;
                    selectedCity = null; // Reset city when state changes
                  });
                },
                items: stateCityData.map((data) {
                  return DropdownMenuItem<String>(
                    value: data.state,
                    child: Text(data.districts!.first.toString()),
                  );
                }).toList(),
              ),
              if (selectedState != null)
                DropdownButton<String>(
                  hint: Text('Select a city'),
                  value: selectedCity,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCity = newValue;
                    });
                  },
                  items: stateCityData
                      .firstWhere((data) => data.state == selectedState)
                      .districts!
                      .map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


///
///
