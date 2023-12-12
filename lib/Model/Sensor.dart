
import 'package:flutter/material.dart';

class Sensor {
  String _uuid;
  int _batterie;

  Sensor(this._uuid, this._batterie);

  String get uuid => _uuid;
  set uuid(String value) => _uuid = value;

  int get batterie => _batterie; // Modification ici
  set batterie(int value) => _batterie = value; // Et ici


}