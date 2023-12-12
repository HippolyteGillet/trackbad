
import 'package:flutter/material.dart';

class Sensor {
  String _uuid;
  int _batterie;
  bool _estConnecte;

  Sensor(this._uuid, this._batterie, this._estConnecte);

  String get uuid => _uuid;
  set uuid(String value) => _uuid = value;

  int get batterie => _batterie; // Modification ici
  set batterie(int value) => _batterie = value; // Et ici

  bool get estConnecte => _estConnecte;
  set estConnecte(bool value) => _estConnecte = value;

}