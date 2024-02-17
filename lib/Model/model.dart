import 'package:flutter/cupertino.dart';
import 'Sensor.dart';
import 'User.dart';
import 'RawData.dart';


class ApplicationModel with ChangeNotifier{
  List<Sensor> sensors = [];
  List<User> users = [];
  List<RawData> rawdata = [];

  void ajouterUtilisateur(dynamic id, dynamic lastname, dynamic firstname, dynamic email, dynamic password, dynamic role) {
    // Ajouter un utilisateur à la liste avec un ID auto-généré
    users.add(User(id, lastname, firstname, email, password, role));
  }

  void displayUsers(){
    int index = 0;
    for (User user in users){
      print('Player model: ${index++}');
      user.display();
    }
  }

  void addData(dynamic id,  List<dynamic> x, List<dynamic> y, List<dynamic> z, List<dynamic> timestamp, String _player_id, String _type) {
    print('here');
    rawdata.add(RawData(id, x, y, z, timestamp, _player_id, _type));

    displayData();
  }

  void displayData(){
    print('taille de la liste: ${rawdata.length}');

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
    sensors.removeWhere((s) => s.uuid == uuid);
  }


}

