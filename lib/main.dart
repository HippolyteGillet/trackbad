import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackbad/Controller/controller.dart';
import 'package:trackbad/DAO/Connection.dart';
import 'package:trackbad/DAO/DataDAO.dart';
import 'package:trackbad/DAO/UsersDAO.dart';
import 'package:trackbad/DAO/DataDAO.dart';
import 'package:trackbad/Model/model.dart';
import 'package:trackbad/Model/User.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as Supabase;


void main() {

  Connection myConnection = Connection();
  myConnection.initializeSupabase();
  final supabase = Supabase.Supabase.instance.client;

  final model = ApplicationModel();

  Users usersDao = Users(supabase, model);
  RawData dataDao = RawData(supabase, model);

  //dataDao.newdata(supabase, 12.4, 12.5, 12.6, 14);

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
