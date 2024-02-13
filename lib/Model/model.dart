import 'package:flutter/cupertino.dart';
import 'Sensor.dart';
import 'User.dart';



class ApplicationModel with ChangeNotifier{
  List<Sensor?> sensors = [];
  List<User> users = [];

  void ajouterUtilisateur(dynamic id, dynamic lastname, dynamic firstname, dynamic email, dynamic password) {
    // Ajouter un utilisateur à la liste avec un ID auto-généré
    users.add(User(id, lastname, firstname, email, password));
  }

  void displayUsers(){
    int index = 0;
    for (User user in users){
      print('Player: ${index++}');
      user.display();
    }
  }

  void rebuildSensorList(List<Sensor> nouveauxCapteurs) {
    sensors = nouveauxCapteurs;
  }

  void removeSensorWithUuid(String uuid) {
    sensors.removeWhere((s) => s?.uuid == uuid);
  }


}

