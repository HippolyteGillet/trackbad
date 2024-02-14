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
  bool isErasing = false;

  int currentProgress = 0;
  int totalPackets = 0;

  final ApplicationModel model;

  Controller({required this.model}) {
    initialize();
  }

  static const platform = MethodChannel('com.example.movella_dot/sensors');

  static const platformData = MethodChannel('com.example.movella_dot/data');

  void initialize() {
    platformData.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    if (call.method == 'receiveData') {
      final data = json.decode(call.arguments);
      if (data.containsKey('totalPackets')) {
        totalPackets = data['totalPackets'];
        currentProgress = 0; // Réinitialiser la progression
        print('Total packets : $totalPackets');
        notifyListeners();
        isExporting = true;
      } else if (data.containsKey('packetNumber')) {
        final packetNumber = data['packetNumber'];
        currentProgress = packetNumber + 1;
        print('Progression: $currentProgress sur $totalPackets');
        notifyListeners();
      } else if (data.containsKey('exportCompleted')) {
        currentProgress = totalPackets;
        print('fin de lexport');
        isExporting = false;
        isErasing = true;
        eraseSensorData(data['exportCompleted']);
        notifyListeners(); // Notifier les observateurs du changement
      }
    }
  }

  Widget get homeWidget => const LogPage();

  int findSmallestAvailableIndex(List<Sensor> sensors) {
    // Créer une liste pour stocker les indices existants
    List<int> existingIndices = [];

    // Extraire les indices de tous les capteurs existants
    for (Sensor sensor in sensors) {
      String? name = sensor.name;
      if (name != null && name.startsWith('Dot ')) {
        try {
          int index = int.parse(name.substring(4));
          existingIndices.add(index);
        } catch (e) {
          print('Erreur lors de la conversion du nom du capteur en entier: $e');
        }
      }
    }

    // Trier la liste des indices existants
    existingIndices.sort();

    // Trouver le plus petit index disponible
    int newIndex = 1;
    for (int index in existingIndices) {
      if (index == newIndex) {
        newIndex++;
      } else {
        break; // Nous avons trouvé un trou dans la séquence
      }
    }

    return newIndex; // Retourner le plus petit index disponible
  }

  Future<void> getSensors() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getSensors');
      final List<Sensor> fetchedSensors = result.map((e) {
        Map<String, dynamic> sensorData = Map<String, dynamic>.from(e);
        return Sensor.withUuid(sensorData['uuid']);
      }).toList();

      for (var fetchedSensor in fetchedSensors) {
        var existingSensor =
            model.sensors.firstWhereOrNull((s) => s.uuid == fetchedSensor.uuid);
        if (existingSensor != null) {
          // Update existing sensor data if necessary
        } else {
          // Ajouter un nouveau capteur
          model.sensors.add(fetchedSensor);

          int index = findSmallestAvailableIndex(model.sensors);

          fetchedSensor.name =
              "Dot $index"; // Mettre à jour le nom avec le nouvel index
        }
      }

      model.sensors.removeWhere((s) =>
          !fetchedSensors.any((fs) => fs.uuid == s.uuid) &&
          s.isConnected == false);

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
          model.sensors.firstWhereOrNull((s) => s.isConnected);
      if (currentlyConnectedSensor != null &&
          currentlyConnectedSensor.uuid != null &&
          currentlyConnectedSensor.isActif == false) {
        await disconnectSensor(currentlyConnectedSensor);
      }

      final Map<dynamic, dynamic> result =
          await platform.invokeMethod('connectSensor', sensorUuid);

      model.sensors
          .where((element) => element.uuid == sensorUuid)
          .first
          .macAdress = result['macAddress'];

      String batteryDescription =
          result['battery'] ?? "Battery:(Uncharged, 100%)";
      int batteryLevel = parseBatteryLevel(batteryDescription);

      model.sensors
          .where((element) => element.uuid == sensorUuid)
          .first
          .battery = batteryLevel;
      model.sensors
          .where((element) => element.uuid == sensorUuid)
          .first
          .batteryIsCharging = batteryDescription.contains("Charging");
      model.sensors
          .where((element) => element.uuid == sensorUuid)
          .first
          .totalSpace = result['totalSpace'];
      model.sensors
          .where((element) => element.uuid == sensorUuid)
          .first
          .usedSpace = result['usedSpace'];
      model.sensors
          .where((element) => element.uuid == sensorUuid)
          .first
          .isConnected = true;

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

  Future<void> disconnectSensor(Sensor sensor) async {
    try {
      final bool result =
          await platform.invokeMethod('disconnectSensor', sensor.uuid);
      if (result) {
        sensor.isConnected = false;
        sensor.isActif = false;
        if (sensor.player != null) {
          model.users
              .where((element) => element.id == sensor.player?.id)
              .first
              .isActif = false;
        }
        sensor.player = null;
        sensor.seanceType = null;
        sensor.macAdress = null;
        sensor.battery = null;
        sensor.batteryIsCharging = false;
        sensor.totalSpace = null;
        sensor.usedSpace = null;
        model.removeSensorWithUuid(sensor.uuid!);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print("Failed to disconnect the sensor: '${e.message}'");
    }
  }

  Future<void> addActiveSensor(
      String uuid, String player, typeSeance seanceType) async {
    var sensor = model.sensors.firstWhereOrNull((s) => s.uuid == uuid);
    if (sensor != null) {
      sensor.player = model.users.firstWhereOrNull((u) => u.id == player);
      sensor.seanceType = seanceType;
      sensor.isActif = true;
      notifyListeners();
    }
  }

  Future<void> startTraining() async {
    try {
      var activeSensor = model.sensors.firstWhereOrNull((s) => s.isActif);
      if (activeSensor != null) {
        await platform.invokeMethod('startRecording', activeSensor.uuid);
        print("Started recording for sensor: ${activeSensor.uuid}");
      }
    } on PlatformException catch (e) {
      print("Failed to start recording: '${e.message}'");
    }
  }

  Future<void> stopTraining() async {
    try {
      var activeSensor = model.sensors.firstWhereOrNull((s) => s.isActif);
      if (activeSensor != null) {
        isExporting = true;
        notifyListeners();

        await platform.invokeMethod(
            'stopRecordingAndExportData', activeSensor.uuid);
      }
    } on PlatformException catch (e) {
      print("Failed to stop recording: '${e.message}'");
    }
  }

  Future<void> eraseSensorData(String sensorUuid) async {
    try {
      final bool result =
          await platform.invokeMethod('eraseSensorData', sensorUuid);
      if (result) {
        print("Data erased successfully for sensor: $sensorUuid");
        isErasing = false;
        notifyListeners();
      } else {
        print("Failed to erase data for sensor: $sensorUuid");
        isErasing = false;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print("Failed to erase sensor data: '${e.message}'");
      isErasing = false;
      notifyListeners();
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