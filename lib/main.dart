import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackbad/Controller/controller.dart';
import 'package:trackbad/Model/model.dart';
import 'package:trackbad/Model/User.dart';


Future<void> main() async {
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