import 'package:flutter/cupertino.dart';
import 'Sensor.dart';
import 'User.dart';



class ApplicationModel with ChangeNotifier{
  List<Sensor?> sensors = [];
  List<User> users = [];

  void ajouterUtilisateur(String nom, int id) {
    // Ajouter un utilisateur à la liste avec un ID auto-généré
    users.add(User(id, nom));
  }

  List<User> get utilisateurs => users;

  List<Sensor?> get capteurs => sensors;

  void rebuildSensorList(List<Sensor> nouveauxCapteurs) {
    sensors = nouveauxCapteurs;
  }

  void removeSensorWithUuid(String uuid) {
    sensors.removeWhere((s) => s?.uuid == uuid);
  }


}

