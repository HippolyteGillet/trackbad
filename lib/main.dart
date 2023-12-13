import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackbad/Controller/controller.dart';
import 'package:trackbad/DAO/Connection.dart';
import 'package:trackbad/DAO/Users.dart';
import 'package:trackbad/Model/model.dart';
import 'package:trackbad/Model/User.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as Supabase;


void main() {

  Connection myConnection = Connection();
  myConnection.initializeSupabase();
  final supabase = Supabase.Supabase.instance.client;

  Users users = Users();
  users.setUserData(supabase);

  // Vous pouvez également imprimer ou utiliser ces données comme nécessaire
  for (int i = 0; i < users.lastname.length; i++) {
    print('COUCOU');
    print('Player $i:');
    print('  Lastname: ${users.lastname[i]}');
    print('  Firstname: ${users.firstname[i]}');
    print('  ID: ${users.id[i]}');
  }

  final model = ApplicationModel();
  model.ajouterUtilisateur("Elie BIME", 1);
  model.ajouterUtilisateur("Pag ZERRRR", 2);

  runApp(
    ChangeNotifierProvider(
      create: (context) => Controller(model: model),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trackbad',
      home: Provider.of<Controller>(context).homeWidget, // Exemple d'accès
    );
  }
}
