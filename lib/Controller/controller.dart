import '../Model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import '../View/pages/log_page.dart';
import '../Model/Sensor.dart';
import 'dart:async';


class Controller with ChangeNotifier {
  final ApplicationModel model;

  Controller({required this.model});

  static const platform = MethodChannel('com.example.movella_dot/sensors');

  late Timer _timer; // Déclarez un objet Timer

  Widget get homeWidget => LogPage(model: model);

  void startSensorRefreshTimer() {
    // Créez un timer qui appelle getSensors toutes les 5 secondes
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      getSensors(); // Appelez getSensors toutes les secondes
    });
  }

  void stopSensorRefreshTimer() {
    // Arrêtez le timer lorsque vous n'en avez plus besoin (par exemple, lorsque la page est détruite)
    _timer.cancel();
  }

  Future<void> getSensors() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getSensors');
      final List<Sensor> fetchedSensors = result.map((e) {
        Map<String, dynamic> sensorData = Map<String, dynamic>.from(e);
        return Sensor.withUuid(sensorData['uuid']);
      }).toList();


      for (var fetchedSensor in fetchedSensors) {
        var existingSensor = model.sensors.firstWhereOrNull((s) => s?.uuid == fetchedSensor.uuid);
        if (existingSensor != null) {
          // Update existing sensor data if necessary
        } else {
          model.sensors.add(fetchedSensor); // Add new sensor
        }
      }

      model.sensors.removeWhere((s) => !fetchedSensors.any((fs) => fs.uuid == s?.uuid) && s?.isConnected == false);

      notifyListeners(); // Notify changes
    } on PlatformException catch (e) {
      print("Failed to get sensors: '${e.message}'");
    }
  }

  Future<void> connectSensor(String sensorUuid) async {
    stopSensorRefreshTimer();
    try {
      // Disconnect any currently connected sensor
      var currentlyConnectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
      if (currentlyConnectedSensor != null && currentlyConnectedSensor.uuid != null && currentlyConnectedSensor.isActif == false) {
        await disconnectSensor(currentlyConnectedSensor.uuid!);
      }

      final Map<dynamic, dynamic> result = await platform.invokeMethod('connectSensor', sensorUuid);

      model.sensors.where((element) => element?.uuid == sensorUuid).first?.macAdress = result['macAdress'];

      String batteryDescription = result['battery'] ?? "Battery:(Uncharged, 100%)";
      int batteryLevel = parseBatteryLevel(batteryDescription);

      model.sensors.where((element) => element?.uuid == sensorUuid).first?.battery = batteryLevel;
      model.sensors.where((element) => element?.uuid == sensorUuid).first?.batteryIsCharging = batteryDescription.contains("Charging");
      model.sensors.where((element) => element?.uuid == sensorUuid).first?.totalSpace = result['totalSpace'];
      model.sensors.where((element) => element?.uuid == sensorUuid).first?.usedSpace = result['usedSpace'];
      model.sensors.where((element) => element?.uuid == sensorUuid).first?.isConnected = true;

      notifyListeners();
    } on PlatformException catch (e) {
      print("Failed to connect the sensor: '${e.message}'");
    }
    startSensorRefreshTimer();
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
      final bool result = await platform.invokeMethod('disconnectSensor', sensorUuid);
      if (result) {
        model.removeSensorWithUuid(sensorUuid);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print("Failed to disconnect the sensor: '${e.message}'");
    }
  }

  Future<void> setSelectedPlayer(String player) async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor != null && model.sensors.firstWhereOrNull((s) => s!.isConnected)?.isActif == false) {
      model.users.firstWhereOrNull((u) => u.nom == player)?.isActif = true;
      model.sensors.firstWhereOrNull((s) => s!.isConnected)?.player = model.users.firstWhereOrNull((u) => u.nom == player);
      notifyListeners();
    }
  }

  Future<void> deselectPlayer() async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor != null && model.sensors.firstWhereOrNull((s) => s!.isConnected)?.isActif == false) {
      model.users.firstWhereOrNull((u) => u.isActif)?.isActif = false;
      model.sensors.firstWhereOrNull((s) => s!.isConnected)?.player = null;
      notifyListeners();
    }
  }

  Future<void> setSeanceType(typeSeance type) async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor != null && model.sensors.firstWhereOrNull((s) => s!.isConnected)?.isActif == false) {
      model.sensors.firstWhereOrNull((s) => s!.isConnected)?.seanceType = type;
      notifyListeners();
    }
  }

  Future<void> deselectSeanceType() async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if (connectedSensor != null && model.sensors.firstWhereOrNull((s) => s!.isConnected)?.isActif == false) {
      model.sensors.firstWhereOrNull((s) => s!.isConnected)?.seanceType = null;
      notifyListeners();
    }
  }

  Future<void> addActiveSensor() async {
    var connectedSensor = model.sensors.firstWhereOrNull((s) => s!.isConnected);
    if(connectedSensor?.seanceType != null && connectedSensor?.player != null && connectedSensor?.isActif == false){
      model.sensors.where((element) => element?.uuid == connectedSensor?.uuid).first?.isActif = true;
      notifyListeners();
    }
  }

}