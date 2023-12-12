import '../Model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final List<Sensor> nouveauxCapteurs = result.map((e) {
        Map<String, dynamic> sensorData = Map<String, dynamic>.from(e);
        return Sensor(
          sensorData['uuid'],
          sensorData['batterie'],
        );
      }).toList();

      model.rebuildSensorListEnable(nouveauxCapteurs);
      notifyListeners(); // Notifie les changements

    } on PlatformException catch (e) {
      print("Failed to get sensors: '${e.message}'");
    }
  }

  Future<void> connectSensor(String sensorUuid) async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('connectSensor', sensorUuid);

      // Extract the battery level from the result
      String batteryDescription = result['battery'] ?? "Battery:(Uncharged, 100%)";
      int batteryLevel = parseBatteryLevel(batteryDescription);

      model.removeSensorEnable(sensorUuid);
      model.addSensorConnected(sensorUuid, batteryLevel, true);
      notifyListeners();
    } on PlatformException catch (e) {
      print("Failed to connect the sensor: '${e.message}'");
    }
  }

// Function to parse the battery level from the description string
  int parseBatteryLevel(String batteryDescription) {
    RegExp regExp = RegExp(r"(\d+)%");
    Match? match = regExp.firstMatch(batteryDescription);

    if (match != null && match.groupCount > 0) {
      return int.parse(match.group(1) ?? "0");
    } else {
      return 100; // Default value if parsing fails
    }
  }

  Future<void> disconnectSensor(String sensorUuid) async {
    try {
      final bool result = await platform.invokeMethod('disconnectSensor', sensorUuid);
      if (result) {
        model.removeSensorConnected(sensorUuid);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print("Failed to disconnect the sensor: '${e.message}'");
    }
  }



}