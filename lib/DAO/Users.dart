import 'package:supabase_flutter/supabase_flutter.dart';

class Users {
  List<dynamic> lastname = [];
  List<dynamic> firstname = [];
  List<dynamic> id = [];

  Users(supabase) {
    setUserData(supabase);
  }

  Future<void> setUserData(SupabaseClient supabase) async {
    try {
      final response = await supabase.from('players').select('*').execute();

      // Utilisez 'status' au lieu de 'error'
      if (response.status == 200) {

        // Assurez-vous que la réponse n'est pas vide
        if (response.data != null) {
          print('COUCOU');

          // Accédez aux colonnes spécifiques (lastname, firstname, id)
          this.lastname = response.data.map((e) => e['lastname']).toList();
          this.firstname = response.data.map((e) => e['firstname']).toList();
          this.id = response.data.map((e) => e['id']).toList();


          // Vous pouvez également imprimer ou utiliser ces données comme nécessaire
          for (int i = 0; i < this.lastname.length; i++) {
            print('Player $i:');
            print('  Lastname: ${this.lastname[i]}');
            print('  Firstname: ${this.firstname[i]}');
            print('  ID: ${this.id[i]}');
          }
        }
      } else {
        print("Erreur lors de la requête");
      }
    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }
}
