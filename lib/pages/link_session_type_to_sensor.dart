import 'package:flutter/material.dart';

class LinkSessionTypeToSensor extends StatefulWidget {
  final void Function(Map<String, dynamic> sensor) onSessionTypeSelected;
  const LinkSessionTypeToSensor({Key? key, required this.onSessionTypeSelected})
      : super(key: key);

  @override
  State<LinkSessionTypeToSensor> createState() =>
      _LinkSessionTypeToSensorState();
}

class _LinkSessionTypeToSensorState extends State<LinkSessionTypeToSensor> {
  String _selectedButton = '';

  Widget buildButton(String text) {
    bool isSelected = _selectedButton == text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              isSelected ? const Color(0xFFF7D101) : const Color(0xFF222FE6),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          setState(() {
            _selectedButton = text;
          });
          widget.onSessionTypeSelected({'name': text});
        },
        child: Text(
          text.toUpperCase(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: -2.0,
          runSpacing: -6.0,
          children: [
            'Entrainement',
            'Match',
            'Physique',
          ].map((String name) => buildButton(name)).toList(),
        ),
      ),
    );
  }
}
