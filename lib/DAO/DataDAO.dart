import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trackbad/Model/model.dart';

class RawData {
  List<Data> rawdata = [];
  DateTime lastUpdateTime = DateTime.now();
  DateTime lastAddTime = DateTime.now();

  RawData(supabase, model) {
    setRawData(supabase, model);
  }

  Future<void> setRawData(SupabaseClient supabase, ApplicationModel model) async {
    try {
      final response = await supabase.from('data').select('*').execute();

      for (var row in response.data) {
        Data data = Data(
          id: row['id'],
          acc_X: row['accx'],
          acc_Y: row['accy'],
          acc_Z: row['accz'],
          timestamp: row['timestamp'],
          player_id: row['player_id'],
          type: row['type'],
        );
        rawdata.add(data);
      }

      for (int i = 0; i < rawdata.length; i++) {
        model.addData(rawdata[i].id, rawdata[i].acc_X, rawdata[i].acc_Y, rawdata[i].acc_Z, rawdata[i].timestamp, rawdata[i].player_id, rawdata[i].type);
      }

      lastUpdateTime = DateTime.now();

    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  Future<void> newdata(SupabaseClient supabase, List<dynamic> x, List<dynamic> y, List<dynamic> z, List<dynamic> timestamp, String player, String type) async {
    try {
      final response = await supabase.from('data').insert({
        'accx': x,
        'accy': y,
        'accz': z,
        'timestamp': timestamp,
        'player_id': player,
        'type': type
      }).execute();

      if (response.status >= 200 && response.status < 300) {
        print('Données ajoutées avec succès');
      } else {
        print('Erreur lors de l\'ajout des données');
      }

      lastAddTime = DateTime.now();
    } catch (e) {
      print('Erreur lors de l\'ajout des données : $e');
    }
  }

  Future<void> checkUpdate(SupabaseClient supabase, ApplicationModel model) async {
    try {
      final response = await supabase.from('data').select('*').execute();

      if (response.data.length > rawdata.length) {
        for (var row in response.data) {
          if (rawdata.indexWhere((element) => element.id == row['id']) == -1) {
            Data data = Data(
              id: row['id'],
              acc_X: row['accx'],
              acc_Y: row['accy'],
              acc_Z: row['accz'],
              timestamp: row['timestamp'],
              player_id: row['player_id'],
              type: row['type'],
            );
            rawdata.add(data);
            model.addData(data.id, data.acc_X, data.acc_Y, data.acc_Z, data.timestamp, data.player_id, data.type);
          }
        }
        lastUpdateTime = DateTime.now();
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }


  void displayData(){
    int index = 0;
    for (Data data in rawdata){
      print('Data: ${index++}');
      data.display();
    }
  }
}

class Data {
  List<dynamic> acc_X;
  List<dynamic> acc_Y;
  List<dynamic> acc_Z;
  List<dynamic> timestamp;
  String player_id;
  String type;
  String id;

  List<dynamic> get GetX => acc_X;
  List<dynamic> get GetY => acc_Y;
  List<dynamic> get GetZ => acc_Z;
  List<dynamic> get GetTime => timestamp;
  String get GetPlayer => player_id;
  String get GetID => id;

  Data({
    required this.id,
    required this.acc_X,
    required this.acc_Y,
    required this.acc_Z,
    required this.timestamp,
    required this.player_id,
    required this.type,
  });

  void display(){
    print('  Acc_X: ${acc_X}');
    print('  Acc_Y: ${acc_Y}');
    print('  Acc_Z: ${acc_Z}');
    print('  Timestamp: ${timestamp}');
    print('  Player: ${player_id}');
    print('  Type de Session: ${type}');
    print('  ID: ${id}');
  }

}
