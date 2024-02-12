import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:trackbad/View/pages/link_player_to_sensor.dart';
import 'package:trackbad/View//pages/navbar_event.dart';
import 'package:trackbad/View//pages/search_sensor.dart';
import 'link_session_type_to_sensor.dart';
import 'package:provider/provider.dart';
import '../../Controller/controller.dart';

class AddSensorPage extends StatefulWidget {
  const AddSensorPage({Key? key}) : super(key: key);

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
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
              const LinkPlayerToSensor(),
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
              const LinkSessionTypeToSensor(),
              ElevatedButton(
                onPressed: () async {

                  await controller
                      .addActiveSensor(); // Appel asynchrone de addActiveSensor

                  // Vérifier si le widget est toujours dans l'arbre des widgets
                  if (!mounted) return;

                  // Vérifier l'état du capteur connecté
                  var connectedSensor = controller.model.sensors
                      .firstWhereOrNull((s) => s!.isConnected);
                  if (connectedSensor?.isActif == true) {
                    connectedSensor?.player?.isActif = true;
                    // Naviguer vers NavbarEvents si le capteur est actif
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavbarEvents()),
                          (route) => false,
                    );
                  }
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
          ..._buildLoadingOverlay(controller.isConnecting),
        ],
      ),
    );
  }

  List<Widget> _buildLoadingOverlay(bool isConnecting) {
    if (isConnecting) {
      return [
        Container(
          color: Colors.black.withOpacity(0.5),
          // Fond semi-transparent pour l'effet de flou
          child: Center(
            child: Image.asset('assets/gif/connexion.gif', width: 200),
          ),
        ),
      ];
    } else {
      return []; // Retourner une liste vide lorsque isConnecting est false
    }
  }
}
