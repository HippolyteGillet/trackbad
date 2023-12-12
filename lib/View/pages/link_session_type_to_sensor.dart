import 'package:flutter/material.dart';

class LinkSessionTypeToSensor extends StatefulWidget {
  const LinkSessionTypeToSensor({super.key});

  @override
  State<LinkSessionTypeToSensor> createState() => _LinkSessionTypeToSensorState();
}

class _LinkSessionTypeToSensorState extends State<LinkSessionTypeToSensor> {
  String _selectedButton = '';

  Widget buildButton(String text) {
    bool isSelected = _selectedButton == text;
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
        scrollDirection: Axis.vertical, // Scroll horizontally
        children: <String>['Entrainement', 'Competition']
            .map((String name) => buildButton(name))
            .toList(),
      ),
    );
  }
}
