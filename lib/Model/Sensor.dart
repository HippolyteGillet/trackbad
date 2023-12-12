
import 'package:flutter/material.dart';

class Sensor {
  String _uuid;

  Sensor(this._uuid);

  String get uuid => _uuid;
  set uuid(String value) => _uuid = value;

}