import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trackbad/Model/model.dart';

class Users {
  List<User> users = [];

  Users(supabase, model) {
    setUsers(supabase, model);
  }

  Future<void> setUsers(SupabaseClient supabase, ApplicationModel model) async {
    try {
      final response = await supabase.from('players').select('*').execute();

      for (var row in response.data) {
        User user = User(
          id: row['id'],
          lastname: row['lastname'],
          firstname: row['firstname'],
          email: row['email'],
          password: row['password'],
        );
        users.add(user);
      }


      for (int i = 0; i < users.length; i++) {
        model.ajouterUtilisateur(users[i].id, users[i].lastname, users[i].firstname, users[i].email, users[i].password);
      }

    } catch (e) {
      print('Erreur lors de la récupération des données : $e');
    }
  }

  void displayUsers(){
    int index = 0;
    for (User user in users){
      print('Player: ${index++}');
      user.display();
    }
  }
}

class User {
  String lastname;
  String firstname;
  String email;
  String password;
  String id;

  String get GetLastname => lastname;
  String get GetFirstname => firstname;
  String get GetEmail => email;
  String get GetPassword => password;
  String get GetID => id;

  User({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.email,
    required this.password,
  });

  void display(){
    print('  Lastname: ${lastname}');
    print('  Firstname: ${firstname}');
    print('  Email: ${email}');
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
