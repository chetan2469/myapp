// To parse this JSON data, do
//
//     final stateCityDataModel = stateCityDataModelFromJson(jsonString);

import 'dart:convert';

StateCityDataModel stateCityDataModelFromJson(String str) =>
    StateCityDataModel.fromJson(json.decode(str));

String stateCityDataModelToJson(StateCityDataModel data) =>
    json.encode(data.toJson());

class StateCityDataModel {
  List<StateCity>? states;

  StateCityDataModel({
    this.states,
  });

  factory StateCityDataModel.fromJson(Map<String, dynamic> json) =>
      StateCityDataModel(
        states: json["states"] == null
            ? []
            : List<StateCity>.from(
                json["states"]!.map((x) => StateCity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "states": states == null
            ? []
            : List<dynamic>.from(states!.map((x) => x.toJson())),
      };
}

class StateCity {
  String? state;
  List<String>? districts;

  StateCity({
    this.state,
    this.districts,
  });

  factory StateCity.fromJson(Map<String, dynamic> json) => StateCity(
        state: json["state"],
        districts: json["districts"] == null
            ? []
            : List<String>.from(json["districts"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "state": state,
        "districts": districts == null
            ? []
            : List<dynamic>.from(districts!.map((x) => x)),
      };
}
