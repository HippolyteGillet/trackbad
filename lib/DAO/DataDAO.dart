import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trackbad/Model/model.dart';

class RawData {
  List<Data> rawdata = [];

  RawData(supabase, model) {
    setRawData(supabase, model);
  }

  Future<void> setRawData(SupabaseClient supabase, ApplicationModel model) async {
    try {
      final response = await supabase.from('data').select('*').execute();

      for (var row in response.data) {
        Data data = Data(
          id: row['id'],
          acc_X: row['acc_X'],
          acc_Y: row['acc_Y'],
          acc_Z: row['acc_Z'],
          timestamp: row['timestamp'],
        );
        rawdata.add(data);
      }

      for (int i = 0; i < rawdata.length; i++) {
        model.addData(rawdata[i].id, rawdata[i].acc_X, rawdata[i].acc_Y, rawdata[i].acc_Z, rawdata[i].timestamp);
      }

    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  Future<void> newdata(SupabaseClient supabase, List<dynamic> x, List<dynamic> y, List<dynamic> z, List<dynamic> timestamp) async {
    try {
      final response = await supabase.from('data').insert({
        'acc_X': x,
        'acc_Y': y,
        'acc_Z': z,
        'timestamp': timestamp,
      }).execute();

      if (response.status >= 200 && response.status < 300) {
        print('Données ajoutées avec succès');
      } else {
        print('Erreur lors de l\'ajout des données');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout des données : $e');
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
  String id;

  List<dynamic> get GetX => acc_X;
  List<dynamic> get GetY => acc_Y;
  List<dynamic> get GetZ => acc_Z;
  List<dynamic> get GetTime => timestamp;
  String get GetID => id;

  Data({
    required this.id,
    required this.acc_X,
    required this.acc_Y,
    required this.acc_Z,
    required this.timestamp,
  });

  void display(){
    print('  Acc_X: ${acc_X}');
    print('  Acc_Y: ${acc_Y}');
    print('  Acc_Z: ${acc_Z}');
    print('  timestamp: ${timestamp}');
    print('  ID: ${id}');
  }

}
