import 'package:flutter/cupertino.dart';
import 'Sensor.dart';
import 'User.dart';



class ApplicationModel with ChangeNotifier{
  List<Sensor> sensors = [];
  List<User> users = [];

  void ajouterUtilisateur(String nom, int id) {
    // Ajouter un utilisateur à la liste avec un ID auto-généré
    users.add(User(id, nom));
  }

  List<User> get utilisateurs => users;

  void ajouterCapteur(String uuid, int batterie, bool estConnecte) {
    // Vérifier si un capteur avec le même UUID existe déjà dans la liste
    final existingSensorIndex = sensors.indexWhere(
          (sensor) => sensor.uuid == uuid,
    );

    if (existingSensorIndex == -1) {
      // Si le capteur n'existe pas dans la liste, l'ajouter
      sensors.add(Sensor(uuid, batterie, estConnecte));
    } else {
      // Si le capteur existe déjà, mettre à jour ses informations (batterie, estConnecte)
      final existingSensor = sensors[existingSensorIndex];
      existingSensor.batterie = batterie;
      existingSensor.estConnecte = estConnecte;
    }
  }

  List<Sensor> get capteurs => sensors;
}

