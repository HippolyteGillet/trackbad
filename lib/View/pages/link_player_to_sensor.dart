import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Controller/controller.dart';


class LinkPlayerToSensor extends StatefulWidget {
  const LinkPlayerToSensor({super.key});

  @override
  State<LinkPlayerToSensor> createState() => _LinkPlayerToSensorState();
}

class _LinkPlayerToSensorState extends State<LinkPlayerToSensor> {
  String _selectedButton = '';

  Widget buildButton(String text, Controller controller) {
    bool isSelected = _selectedButton == text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.yellow : Colors.blue,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          setState(() {
            if (_selectedButton == text) {
              _selectedButton = ''; // Deselect if already selected
              //controller.setSelectedPlayer(null); // Update in controller
            } else {
              _selectedButton = text;
              controller.setSelectedPlayer(text); // Update in controller
            }
          });
        },
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.black : Colors.white),
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
