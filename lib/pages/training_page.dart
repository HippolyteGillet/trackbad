import 'package:flutter/material.dart';
import 'package:trackbad/pages/add_sensor_page.dart';
import 'navbar_event.dart';
import 'ongoing_session_page.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 80)),
        const Center(
          child: Text(
            'Nouvelle Séance',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold,
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
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const AddSensorPage()));
            },
          )
        ]),
        const Padding(padding: EdgeInsets.only(top: 350)),
        ElevatedButton(
          onPressed: () {
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
