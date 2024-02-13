import 'package:flutter/cupertino.dart';
import 'Sensor.dart';
import 'User.dart';
import 'RawData.dart';


class ApplicationModel with ChangeNotifier{
  List<Sensor?> sensors = [];
  List<User> users = [];
  List<RawData> rawdata = [];

  void ajouterUtilisateur(dynamic id, dynamic lastname, dynamic firstname, dynamic email, dynamic password) {
    // Ajouter un utilisateur à la liste avec un ID auto-généré
    users.add(User(id, lastname, firstname, email, password));
  }

  void displayUsers(){
    int index = 0;
    for (User user in users){
      print('Player model: ${index++}');
      user.display();
    }
  }

  void addData(dynamic id,  double x, double y, double z, int timestamp) {
    rawdata.add(RawData(id, x, y, z, timestamp));
  }

  void displayData(){
    int index = 0;
    for (RawData data in rawdata){
      print('Player model: ${index++}');
      data.display();
    }
  }

  void rebuildSensorList(List<Sensor> nouveauxCapteurs) {
    sensors = nouveauxCapteurs;
  }

  void removeSensorWithUuid(String uuid) {
    sensors.removeWhere((s) => s?.uuid == uuid);
  }


}

