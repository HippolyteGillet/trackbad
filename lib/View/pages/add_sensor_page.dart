import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:trackbad/Model/Sensor.dart';
import 'package:trackbad/View/pages/link_player_to_sensor.dart';
import 'package:trackbad/View/pages/search_sensor.dart';
import '../../Controller/controller.dart';
import 'link_session_type_to_sensor.dart';

class AddSensorPage extends StatefulWidget {
  const AddSensorPage({Key? key}) : super(key: key);

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {
  late String selectedSensor;
  late String selectedPlayer;
  late typeSeance selectedSessionType;

  void _handleAddSensor(Controller controller) {
    controller.addActiveSensor(
        selectedSensor, selectedPlayer, selectedSessionType);
  }

  void _handleSensorSelected(String sensor) {
    selectedSensor = sensor;
  }

  void _handlePlayerSelected(String sensor) {
    selectedPlayer = sensor;
  }

  void _handleSessionTypeSelected(typeSeance typeSeance) {
    selectedSessionType = typeSeance;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.08)),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Colors.black,
                  size: MediaQuery.of(context).size.width * 0.08),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text("Connectez votre capteur",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.width * 0.07,
              )),
          SearchSensor(
            onSensorSelected: _handleSensorSelected,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.03,
                  left: MediaQuery.of(context).size.width * 0.03),
              child: Text(
                "Associer à :",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
            ),
          ),
          LinkPlayerToSensor(
            onPlayerSelected: _handlePlayerSelected,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.03,
                  left: MediaQuery.of(context).size.width * 0.03),
              child: Text(
                "Type de séance :",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
            ),
          ),
          LinkSessionTypeToSensor(
            onSessionTypeSelected: _handleSessionTypeSelected,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedSensor == null ||
                  selectedPlayer == null ||
                  selectedSessionType == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      alignment: Alignment.center,
                      title: const Text('Erreur'),
                      content: const Text(
                          'Vous n\'avez pas sélectionné tous les éléments nécessaires pour ajouter un capteur.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                _handleAddSensor(controller);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
              minimumSize: Size(MediaQuery.of(context).size.width * 0.5,
                  MediaQuery.of(context).size.height * 0.07),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.05),
              ),
            ),
            child: Text(
              'Ajouter',
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
    );
  }
}
