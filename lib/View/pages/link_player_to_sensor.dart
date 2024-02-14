import 'package:flutter/material.dart';

class LinkPlayerToSensor extends StatefulWidget {
  final void Function(String sensor) onPlayerSelected;
  const LinkPlayerToSensor({Key? key, required this.onPlayerSelected})
      : super(key: key);

  @override
  State<LinkPlayerToSensor> createState() => _LinkPlayerToSensorState();
}

class _LinkPlayerToSensorState extends State<LinkPlayerToSensor> {
  String _selectedButton = '';

  Widget buildButton(String text) {
    bool isSelected = _selectedButton == text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isSelected ? const Color(0xFFF7D101) : const Color(0xFF222FE6),
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
          widget.onPlayerSelected(text);
        },
        child: Text(
          text.toUpperCase(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    // Filtrer les utilisateurs inactifs avant de construire les boutons
    final inactiveUserNames = controller.model.users.where((user) => !user.isActif).map((user) => user.lastname).toList();

    return SizedBox(
      width: double.infinity,
      height: 120,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: -2.0,
          runSpacing: -6.0,
          children: inactiveUserNames.map((dynamic name) => buildButton(name, controller)).toList(),
        ),
      ),
    );
  }
}
