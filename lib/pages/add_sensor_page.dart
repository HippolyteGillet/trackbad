import 'package:flutter/material.dart';
import 'package:trackbad/pages/link_player_to_sensor.dart';
import 'package:trackbad/pages/search_sensor.dart';
import 'link_session_type_to_sensor.dart';

class AddSensorPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddSensorPage({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {
  Map<String, dynamic>? selectedSensor;
  Map<String, dynamic>? selectedPlayer;
  Map<String, dynamic>? selectedSessionType;

  void _handleAddSensor() {
    Map<String, dynamic> newSensorData = {
      'name': selectedPlayer!['name'],
      'sensor': selectedSensor!['name'],
      'type': selectedSessionType!['name'],
    };
    Navigator.of(context).pop(newSensorData);
  }

  void _handleSensorSelected(Map<String, dynamic> sensor) {
    selectedSensor = sensor;
  }

  void _handlePlayerSelected(Map<String, dynamic> sensor) {
    selectedPlayer = sensor;
  }

  void _handleSessionTypeSelected(Map<String, dynamic> sensor) {
    selectedSessionType = sensor;
  }

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
          SearchSensor(
            onSensorSelected: _handleSensorSelected,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 15),
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
          LinkPlayerToSensor(
            onPlayerSelected: _handlePlayerSelected,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 10, left: 15),
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
          LinkSessionTypeToSensor(
            onSessionTypeSelected: _handleSessionTypeSelected,
          ),
          ElevatedButton(
            onPressed: () {
              _handleAddSensor();
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
