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


}
