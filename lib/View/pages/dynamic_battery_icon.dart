import 'package:flutter/material.dart';
import 'dart:math' as math;

class DynamicBatteryIcon extends StatelessWidget {
  final int batteryLevel; // pourcentage de 0 à 100

  const DynamicBatteryIcon({super.key, required this.batteryLevel});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    if (batteryLevel == 100) {
      iconData = Icons.battery_full;
      iconColor = Colors.green[700]!;
    } else if (batteryLevel >= 75) {
      iconData = Icons.battery_5_bar;
      iconColor = Colors.green[700]!;
    } else if (batteryLevel >= 50) {
      iconData = Icons.battery_4_bar;
      iconColor = Colors.black;
    } else if (batteryLevel >= 25) {
      iconData = Icons.battery_2_bar;
      iconColor = Colors.yellow[700]!;
    } else if (batteryLevel > 5) {
      iconData = Icons.battery_1_bar;
      iconColor = Colors.orange[700]!;
    } else {
      iconData = Icons.battery_alert;
      iconColor = Colors.red;
    }

    return Transform.rotate(
        angle: math.pi / 2, child: Icon(iconData, color: iconColor));
  }
}
