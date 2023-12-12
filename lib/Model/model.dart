import 'package:flutter/cupertino.dart';
import 'package:trackbad/Model/connectedSensor.dart';
import 'Sensor.dart';
import 'User.dart';



class ApplicationModel with ChangeNotifier{
  List<Sensor> sensorsEnable = [];
  List<connectedSensor> sensorsConnected = [];
  List<User> users = [];

  void ajouterUtilisateur(String nom, int id) {
    // Ajouter un utilisateur à la liste avec un ID auto-généré
    users.add(User(id, nom));
  }

  List<User> get utilisateurs => users;

  List<Sensor> get capteurs => sensorsEnable;

  void addSensorEnable(String uuid, int batterie, bool estConnecte) {
    sensorsEnable.add(Sensor(uuid));
  }

  void removeSensorEnable(String uuid) {
    sensorsEnable.removeWhere((element) => element.uuid == uuid);
  }

  void rebuildSensorListEnable(List<Sensor> nouveauxCapteurs) {
    sensorsEnable.clear();
    sensorsEnable.addAll(nouveauxCapteurs);
    notifyListeners();
  }


  void removeSensorConnected(String uuid) {
    sensorsConnected.removeWhere((element) => element.sensor.uuid == uuid);
  }

  void addSensorConnected(connectedSensor sensor) {
    sensorsConnected.add(sensor);
  }


}

