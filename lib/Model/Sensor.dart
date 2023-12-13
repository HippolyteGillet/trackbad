import '../Model/User.dart';

enum typeSeance { Entrainement, Match }

extension TypeSeanceExtension on typeSeance {
  String get stringValue {
    switch (this) {
      case typeSeance.Entrainement:
        return 'Entrainement';
      case typeSeance.Match:
        return 'Match';
      default:
        return ''; // Gérer d'autres cas si nécessaire
    }
  }
}

class Sensor {
  String? uuid;
  String? macAdress;
  int? battery;
  bool? batteryIsCharging;
  int? totalSpace;
  int? usedSpace;

  bool isConnected = false;
  bool isActif = false;

  User? player;

  typeSeance? seanceType;

  Sensor(this.uuid, this.macAdress, this.battery, this.batteryIsCharging, this.totalSpace, this.usedSpace);

  Sensor.withUuid(String this.uuid);


}
