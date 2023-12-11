import 'package:flutter/material.dart';

class LinkPlayerToSensor extends StatefulWidget {
  const LinkPlayerToSensor({super.key});

  @override
  State<LinkPlayerToSensor> createState() => _LinkPlayerToSensorState();
}

class _LinkPlayerToSensorState extends State<LinkPlayerToSensor> {
  String _selectedButton = '';

  Widget buildButton(String text) {
    bool isSelected = _selectedButton == text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      // Add some space between buttons
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.yellow : Colors.blue,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(), // Circular border
        ),
        onPressed: () {
          setState(() {
            _selectedButton = text;
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
    return Container(
      color: Colors.yellow,
      width: 360,
      height: 100,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <String>['Elie BIME', 'Paul BOULET', 'Hippolyte GILLET']
            .map((String name) => buildButton(name))
            .toList(),
      ),
    );
  }
}
