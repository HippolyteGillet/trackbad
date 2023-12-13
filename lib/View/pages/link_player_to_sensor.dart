import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Controller/controller.dart';
import '../../../Model/User.dart';

class LinkPlayerToSensor extends StatefulWidget {
  const LinkPlayerToSensor({Key? key}) : super(key: key);

  @override
  State<LinkPlayerToSensor> createState() => _LinkPlayerToSensorState();
}

class _LinkPlayerToSensorState extends State<LinkPlayerToSensor> {
  String _selectedButton = '';

  Widget buildButton(String text, Controller controller) {
    bool isSelected = _selectedButton == text;
    bool isSensorAvailable = controller.model.sensors.where((s) => s?.isConnected == true && s?.isActif == false).isNotEmpty;
    User? user = controller.model.users.firstWhereOrNull((u) => u.nom == text);
    bool isUserActive = user?.isActif ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isUserActive ? Colors.grey : (isSelected ? Colors.yellow : Colors.blue),
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: isUserActive ? null : () {
          setState(() {
            if (!isSensorAvailable) {
              // Si aucun capteur n'est connecté, ne rien faire
              return;
            }

            if (_selectedButton == text) {
              _selectedButton = ''; // Deselect if already selected
              controller.deselectPlayer();
            } else {
              _selectedButton = text;
              controller.setSelectedPlayer(text); // Update in controller
            }
          });
        },
        child: Text(
          text,
          style: TextStyle(color: isUserActive ? Colors.black54 : (isSelected ? Colors.black : Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final names = controller.model.users.map((user) => user.nom).toList();
    return Container(
      color: Colors.yellow,
      width: 360,
      height: 100,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: names.map((String name) => buildButton(name, controller)).toList(),
      ),
    );
  }
}
