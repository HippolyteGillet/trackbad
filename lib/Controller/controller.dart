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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      final sensors = result.map((e) {
        Map<String, dynamic> sensorData = Map<String, dynamic>.from(e);
        return Sensor(
          sensorData['uuid'],
          sensorData['batterie'],
          sensorData['estConnecte'],
        );
      }).toList();

      for (var sensor in sensors) {
        model.ajouterCapteur(sensor.uuid, sensor.batterie, sensor.estConnecte);
      }

      notifyListeners(); // Notifie les changements
    } on PlatformException catch (e) {
      print("Failed to get sensors: '${e.message}'");
    }
  }
}