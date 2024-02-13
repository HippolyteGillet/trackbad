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

  Future<void> newdata(SupabaseClient supabase, double x, double y, double z, int timestamp) async {
    try {
      final response = await supabase.from('data').insert({
        'acc_X': x,
        'acc_Y': y,
        'acc_Z': z,
        'timestamp': timestamp,
      }).execute();

      if (response.status == 200) {
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
  double acc_X;
  double acc_Y;
  double acc_Z;
  int timestamp;
  String id;

  double get GetX => acc_X;
  double get GetY => acc_Y;
  double get GetZ => acc_Z;
  int get GetTime => timestamp;
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

/*Future<void> setUserData(SupabaseClient supabase, ApplicationModel model) async {
    try {
      final response = await supabase.from('players').select('*').execute();

      // Utilisez 'status' au lieu de 'error'
      if (response.status == 200) {

        // Assurez-vous que la réponse n'est pas vide
        if (response.data != null) {

          // Accédez aux colonnes spécifiques (lastname, firstname, id)
          this.lastname = response.data.map((e) => e['lastname']).toList();
          this.firstname = response.data.map((e) => e['firstname']).toList();
          this.email = response.data.map((e) => e['email']).toList();
          this.password = response.data.map((e) => e['password']).toList();
          this.id = response.data.map((e) => e['id']).toList();

          // Vous pouvez également imprimer ou utiliser ces données comme nécessaire
          for (int i = 0; i < this.id.length; i++) {
            model.ajouterUtilisateur(this.id[i], this.lastname[i], this.firstname[i], this.email[i], this.password[i]);
          }
        }
      } else {
        print("Erreur lors de la requête");
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }*/
}
