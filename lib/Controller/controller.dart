import 'dart:convert';

import '../Model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import '../View/pages/log_page.dart';
import '../Model/Sensor.dart';
import 'dart:async';

class Controller with ChangeNotifier {
  bool isConnecting = false;
  bool isExporting = false;

  final ApplicationModel model;

  Controller({required this.model}){
    initialize();
  }

  static const platform = MethodChannel('com.example.movella_dot/sensors');

  static const platformData = MethodChannel('com.example.movella_dot/data');

  void initialize() {
    platformData.setMethodCallHandler(_handleMethod);
  }


  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'receiveData':
        final String dataJson = call.arguments;
        final Map<String, dynamic> dataMap = jsonDecode(dataJson);
        //print("Données reçues de iOS: $dataMap");
        // Traitez ou utilisez les données reçues ici


        isExporting = false;
        notifyListeners(); // Notifier les observateurs du changement

        break;
      default:
        print('Méthode non gérée');
    }
  }


  Widget get homeWidget => LogPage(model: model);

  Future<void> getSensors() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getSensors');
      final List<Sensor> fetchedSensors = result.map((e) {
        Map<String, dynamic> sensorData = Map<String, dynamic>.from(e);
        return Sensor.withUuid(sensorData['uuid']);
      }).toList();

      for (var fetchedSensor in fetchedSensors) {
        var existingSensor = model.sensors
            .firstWhereOrNull((s) => s?.uuid == fetchedSensor.uuid);
        if (existingSensor != null) {
          // Update existing sensor data if necessary
        } else {
          model.sensors.add(fetchedSensor); // Add new sensor
        }
      }

      model.sensors.removeWhere((s) =>
          !fetchedSensors.any((fs) => fs.uuid == s?.uuid) &&
          s?.isConnected == false);

      notifyListeners(); // Notify changes
    } on PlatformException catch (e) {
      print("Failed to get sensors: '${e.message}'");
    }
  }

  Future<void> connectSensor(String sensorUuid) async {
    isConnecting = true;
    notifyListeners();
    try {
      // Disconnect any currently connected sensor
      var currentlyConnectedSensor =
          model.sensors.firstWhereOrNull((s) => s!.isConnected);
      if (currentlyConnectedSensor != null &&
          currentlyConnectedSensor.uuid != null &&
          currentlyConnectedSensor.isActif == false) {
        await disconnectSensor(currentlyConnectedSensor.uuid!);
      }

      final Map<dynamic, dynamic> result =
          await platform.invokeMethod('connectSensor', sensorUuid);

      model.sensors
          .where((element) => element?.uuid == sensorUuid)
          .first
          ?.macAdress = result['macAddress'];

      String batteryDescription =
          result['battery'] ?? "Battery:(Uncharged, 100%)";
      int batteryLevel = parseBatteryLevel(batteryDescription);

      model.sensors
          .where((element) => element?.uuid == sensorUuid)
          .first
          ?.battery = batteryLevel;
      model.sensors
          .where((element) => element?.uuid == sensorUuid)
          .first
          ?.batteryIsCharging = batteryDescription.contains("Charging");
      model.sensors
          .where((element) => element?.uuid == sensorUuid)
          .first
          ?.totalSpace = result['totalSpace'];
      model.sensors
          .where((element) => element?.uuid == sensorUuid)
          .first
          ?.usedSpace = result['usedSpace'];
      model.sensors
          .where((element) => element?.uuid == sensorUuid)
          .first
          ?.isConnected = true;

      notifyListeners();
    } on PlatformException catch (e) {
      print("Failed to connect the sensor: '${e.message}'");
    } finally {
      isConnecting = false;
      notifyListeners();
    }
  }

// Function to parse the battery level from the description string
  int parseBatteryLevel(String batteryDescription) {
    RegExp regExp = RegExp(r"(\d+)%");
    Match? match = regExp.firstMatch(batteryDescription);

    if (match != null && match.groupCount > 0) {
      return int.parse(match.group(1) ?? "0");
    } else {
      return 0; // Default value if parsing fails
    }
  }

  Future<void> disconnectSensor(String sensorUuid) async {
    try {
      final bool result =
          await platform.invokeMethod('disconnectSensor', sensorUuid);
      if (result) {
        model.sensors
            .where((element) => element?.uuid == sensorUuid)
            .first
            ?.isConnected = false;
        model.sensors
            .where((element) => element?.uuid == sensorUuid)
            .first
            ?.isActif = false;
        model.sensors
            .where((element) => element?.uuid == sensorUuid)
            .first
            ?.player = null;
        model.sensors
            .where((element) => element?.uuid == sensorUuid)
            .first
            ?.seanceType = null;
        model.users
            .where((element) => element.isActif == true)
            .first
            .isActif = false;
        model.removeSensorWithUuid(sensorUuid);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print("Failed to disconnect the sensor: '${e.message}'");
    }
  }

  Future<void> setSelectedPlayer(String player) async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor != null &&
        model.sensors.firstWhereOrNull((s) => s!.isConnected)?.isActif ==
            false) {
      model.sensors.firstWhereOrNull((s) => s!.isConnected)?.player =
          model.users.firstWhereOrNull((u) => u.lastname == player);
      notifyListeners();
    }
  }

  Future<void> deselectPlayer() async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor != null &&
        model.sensors.firstWhereOrNull((s) => s!.isConnected)?.isActif ==
            false) {
      model.users.firstWhereOrNull((u) => u.isActif)?.isActif = false;
      model.sensors.firstWhereOrNull((s) => s!.isConnected)?.player = null;
      notifyListeners();
    }
  }

  Future<void> setSeanceType(typeSeance type) async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor != null &&
        model.sensors.firstWhereOrNull((s) => s!.isConnected)?.isActif ==
            false) {
      model.sensors.firstWhereOrNull((s) => s!.isConnected)?.seanceType = type;
      notifyListeners();
    }
  }

  Future<void> deselectSeanceType() async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor != null &&
        model.sensors.firstWhereOrNull((s) => s!.isConnected)?.isActif ==
            false) {
      model.sensors.firstWhereOrNull((s) => s!.isConnected)?.seanceType = null;
      notifyListeners();
    }
  }

  Future<void> addActiveSensor() async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor?.seanceType != null &&
        connectedSensor?.player != null &&
        connectedSensor?.isActif == false) {
      model.sensors
          .where((element) => element?.uuid == connectedSensor?.uuid)
          .first
          ?.isActif = true;
      notifyListeners();
    }
  }

  Future<void> startTraining() async {
    try {
      var activeSensor = model.sensors.firstWhereOrNull((s) => s!.isActif);
      if (activeSensor != null) {
        await platform.invokeMethod('startRecording', activeSensor.uuid);
      }
    } on PlatformException catch (e) {
      print("Failed to start recording: '${e.message}'");
    }
  }

  Future<void> stopTraining() async {
    try {
      var activeSensor = model.sensors.firstWhereOrNull((s) => s!.isActif);
      if (activeSensor != null) {
        isExporting = true;
        notifyListeners();

        await platform.invokeMethod('stopRecordingAndExportData', activeSensor.uuid);
      }
    } on PlatformException catch (e) {
      print("Failed to stop recording: '${e.message}'");
    }

  }
  //---------------------Login---------------------//
  Future<void> login(String email, String password) async {
    for (int i = 0; i < model.users.length; i++) {
      if (model.users[i].lastname == email && model.users[i].firstname == password){
        model.users[i].isLog = true;
        print('Connection');
        break;
      }
    }
    for (int i = 0; i < model.users.length; i++) {
      if (model.users[i].isLog == true){
        print('CONNECTE');
        break;
      }
    }
  }

  Future<void> Logout() async {
    model.users.where((element) => element.isLog == true).first.isLog = false;
  }


}