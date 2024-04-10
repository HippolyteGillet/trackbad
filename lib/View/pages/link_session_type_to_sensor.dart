import 'package:flutter/material.dart';
import 'package:trackbad/Model/Sensor.dart';

class LinkSessionTypeToSensor extends StatefulWidget {
  final void Function(typeSeance sensor) onSessionTypeSelected;
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
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03, vertical: MediaQuery.of(context).size.width * 0.04),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              isSelected ? const Color(0xFFF7D101) : const Color(0xFF222FE6),
          textStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.bold,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: MediaQuery.of(context).size.width * 0.02),
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          setState(() {
            _selectedButton = text;
          });
          typeSeance? type = typeSeance.values
              .firstWhere((element) => element.stringValue == text);
          widget.onSessionTypeSelected(type!);
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
            typeSeance.Entrainement.stringValue,
            typeSeance.Match.stringValue,
            typeSeance.Physique.stringValue,
          ].map((type) => buildButton(type)).toList(),
        ),
      ),
    );
  }
}
