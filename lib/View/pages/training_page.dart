import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackbad/View/pages/add_sensor_page.dart';
import '../../Controller/controller.dart';
import 'ongoing_session_page.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final sensors = controller.model.sensors.where((s) => s?.isActif == true).toList();

    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 80)),
        const Center(
          child: Text(
            'Nouvelle Séance',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(240, 54, 18, 1),
              fontSize: 40,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 50)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Ajouter un capteur',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          IconButton(
            icon: const Icon(Icons.add_circle,
                color: Color.fromRGBO(240, 54, 18, 1), size: 45),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSensorPage()),
              );
            },
          )
        ]),
        SizedBox(
          width: 320,
          height: 335,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 25),
            child: Wrap(
              spacing: 5.0, // Espace horizontal entre les cartes
              runSpacing: 30.0, // Espace vertical entre les lignes
              children: sensors.map((sensor) {
                return SizedBox(
                  width: 100,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // Pop-up d'informations sur le capteur
                          return AlertDialog(
                            title: Text(sensor?.name ?? "Inconnu"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Joueur : ${sensor?.player?.nom}'),
                                const SizedBox(height: 8.0),
                                Text('Capteur : ${sensor?.uuid}'),
                                const SizedBox(height: 8.0),
                                Text("Type de séance : ${sensor?.seanceType.toString()}"),
                                // Ajoutez plus d'informations ici
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Déconnecter',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  controller.disconnectSensor(sensor!);
                                },
                              ),
                              TextButton(
                                child: const Text('Fermer'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Ferme la boîte de dialogue
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      color: const Color.fromRGBO(34, 47, 230, 1),
                      elevation: 3,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          const Positioned(
                            top: -25,
                            child: CircleAvatar(
                              radius: 25, // La taille de l'avatar
                              backgroundColor: Colors.lightBlueAccent,
                              child: Icon(Icons.person, size: 25),
                            ),
                          ),
                          Column(
                            children: [
                              const Padding(padding: EdgeInsets.only(top: 25)),
                              Text(
                                sensor?.player?.nom ?? "Inconnu",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 3)),
                              Text(
                                '${sensor?.name}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 15)),
        ElevatedButton(
          onPressed: () {
            controller.startTraining();
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const OngoingSessionPage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
            minimumSize: const Size(250, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          child: const Text(
            'Commencer',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
