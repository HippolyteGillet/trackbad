import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trackbad/Model/model.dart';

class Users {
  List<dynamic> lastname = [];
  List<dynamic> firstname = [];
  List<dynamic> email = [];
  List<dynamic> password = [];
  List<dynamic> id = [];
  late final ApplicationModel model;

  List<dynamic> get GetLastname => lastname;
  List<dynamic> get GetFirstname => firstname;
  List<dynamic> get GetEmail => email;
  List<dynamic> get GetPassword => password;
  List<dynamic> get GetID => id;

  Users(supabase, model) {
    setUserData(supabase, model);
  }

  Future<void> setUserData(SupabaseClient supabase, ApplicationModel model) async {
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
  }
}
