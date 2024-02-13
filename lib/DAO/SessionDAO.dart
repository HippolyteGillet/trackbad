import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trackbad/Model/model.dart';

class Sessions {
  List<Session> sessions = [];

  Sessions(supabase, model) {
    setSessions(supabase, model);
  }

  Future<void> setSessions(SupabaseClient supabase, ApplicationModel model) async {
    try {
      final response = await supabase.from('sessions').select('*').execute();

      for (var row in response.data) {
        Session session = Session(
          id: row['id'],
          player_id: row['player_id'],
          data_id: row['data_id'],
          type: row['type'],
        );
        sessions.add(session);
      }

      for (int i = 0; i < sessions.length; i++) {
        //model.ajouterUtilisateur(users[i].id, users[i].player_id, users[i].data_id, users[i].email, users[i].password);
      }

      displaySessions();
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  void displaySessions(){
    int index = 0;
    for (Session session in sessions){
      print('Session: ${index++}');
      session.display();
    }
  }
}

class Session {
  String player_id;
  String data_id;
  String type;
  String id;

  String get GetPlayer_id => player_id;
  String get GetData_id => data_id;
  String get GetType => type;
  String get GetID => id;

  Session({
    required this.id,
    required this.player_id,
    required this.data_id,
    required this.type,
  });

  void display(){
    print('  player_id: ${player_id}');
    print('  data_id: ${data_id}');
    print('  Type: ${type}');
    print('  ID: ${id}');
  }

}
