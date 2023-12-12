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

  List<Sensor> get capteurs => sensors;

  void ajouterCapteur(String uuid, int batterie, bool estConnecte) {
    sensors.add(Sensor(uuid, batterie, estConnecte));
  }

  void reconstruireListeCapteurs(List<Sensor> nouveauxCapteurs) {
    sensors.clear();
    sensors.addAll(nouveauxCapteurs);
    notifyListeners();
  }

}

