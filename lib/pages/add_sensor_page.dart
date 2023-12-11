import 'package:flutter/material.dart';
import 'package:trackbad/pages/link_player_to_sensor.dart';
import 'package:trackbad/pages/navbar_event.dart';
import 'package:trackbad/pages/search_sensor.dart';
import 'link_session_type_to_sensor.dart';

class AddSensorPage extends StatefulWidget {
  const AddSensorPage({super.key});

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 60)),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.black, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text("Connectez votre capteur",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                fontSize: 30,
              )),
          const SearchSensor(),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top:10, left: 15),
              child: Text(
                "Associer à :",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
            ),
          ),
          const LinkPlayerToSensor(),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top:10, left: 15),
              child: Text(
                "Type de séance :",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
            ),
          ),
          const LinkSessionTypeToSensor(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const NavbarEvents()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
              minimumSize: const Size(150, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: const Text(
              'Ajouter',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
