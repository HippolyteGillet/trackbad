import 'package:flutter/material.dart';
import 'package:trackbad/Model/Sensor.dart';
import 'package:trackbad/View/pages/add_sensor_page.dart';
import 'ongoing_session_page.dart';
import 'package:provider/provider.dart';
import '../../Controller/controller.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final sensors =
        controller.model.sensors.where((s) => s?.isActif == true).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.08)),
            Center(
              child: Text(
                'Nouvelle Séance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w900,
                  color: const Color.fromRGBO(240, 54, 18, 1),
                  fontSize: MediaQuery.of(context).size.width * 0.09,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.03)),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Ajouter un capteur',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03)),
              IconButton(
                icon: Icon(Icons.add_circle,
                    color: const Color.fromRGBO(240, 54, 18, 1),
                    size: MediaQuery.of(context).size.width * 0.07),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddSensorPage()),
                  );
                },
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.45,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 25),
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 30.0,
                  children: sensors.map((sensor) {
                    return SizedBox(
                      width: 110, // a modifier
                      height: 100, // a modifier
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(sensor?.name ?? "Inconnu"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'Joueur : ${sensor?.player?.lastname} ${sensor?.player?.firstname}'),
                                    const SizedBox(height: 8.0),
                                    Text("Batterie: ${sensor?.battery}%"),
                                    Text('Capteur : ${sensor?.uuid}'),
                                    const SizedBox(height: 8.0),
                                    Text(
                                        "Type de séance : ${sensor.seanceType?.stringValue}"),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Déconnecter',
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      controller.disconnectSensor(sensor!);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Fermer'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
                                  radius: 25,
                                  backgroundColor: Colors.lightBlueAccent,
                                  child: Icon(Icons.person, size: 25),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 25)),
                                  FittedBox(
                                    child: Text(
                                      sensor.player!.firstname,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      sensor.player!.lastname,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 3)),
                                  FittedBox(
                                    child: Text(
                                      '${sensor?.name}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
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
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.04)),
            ElevatedButton(
              onPressed: () async {
                await controller.startTraining();

                if (!mounted) return;
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            const OngoingSessionPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.height * 0.07),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              child: Text(
                'Commencer',
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
