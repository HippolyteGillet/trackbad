import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackbad/Model/Sensor.dart';
import '../../../Controller/controller.dart';

class LinkSessionTypeToSensor extends StatefulWidget {
  const LinkSessionTypeToSensor({super.key});

  @override
  State<LinkSessionTypeToSensor> createState() => _LinkSessionTypeToSensorState();
}

class _LinkSessionTypeToSensorState extends State<LinkSessionTypeToSensor> {
  String _selectedButton = '';

  Widget buildButton(String text, Controller controller) {
    bool isSelected = _selectedButton == text;
    bool isSensorAvailable = controller.model.sensors.where((s) => s?.isConnected == true && s?.isActif == false).isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      // Add some space between buttons
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.yellow : Colors.blue, // Background color
          foregroundColor: Colors.white, // Text Color (Foreground color)
          shape: const StadiumBorder(), // Circular border
        ),
        onPressed: () {
          setState(() {
            if (!isSensorAvailable) {
              // Si aucun capteur n'est disponible, ne rien faire
              return;
            }

            if (_selectedButton == text) {
              _selectedButton = ''; // Deselect if already selected
            } else {
              _selectedButton = text;
              typeSeance type = text == typeSeance.Entrainement.stringValue ? typeSeance.Entrainement : typeSeance.Match;
              controller.setSeanceType(type); // Update in controller
            }
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? Colors.black
                : Colors.white, // Text color based on selection
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);

    return Container(
      color: Colors.yellow,
      width: 360,
      height: 100,
      child: ListView(
        scrollDirection: Axis.vertical, // Scroll horizontally
        children: <String>[typeSeance.Entrainement.stringValue, typeSeance.Match.stringValue]
            .map((String name) => buildButton(name, controller))
            .toList(),
      ),
    );
  }
}
