import 'package:supabase_flutter/supabase_flutter.dart';


class Users {
  List<String> lastname = [];
  List<String> firstname = [];
  List<String> id = [];

  Future<void> setUserData(supabase) async {
    try {
      final response = await supabase.from('players').select('*').execute;

      print('helloz');
      // Utilisez 'status' au lieu de 'error'
      if (response.status == 200) {
        // Assurez-vous que la réponse n'est pas vide
        if (response.data != null) {
          // Accédez aux colonnes spécifiques (lastname, firstname, id)
          this.lastname = response.data.map((e) => e['lastname'].toString()).toList();
          this.firstname = response.data.map((e) => e['firstname'].toString()).toList();
          this.id = response.data.map((e) => e['id'].toString()).toList();

        }
      } else {
        print("Erreur lors de la requête");
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }
}
