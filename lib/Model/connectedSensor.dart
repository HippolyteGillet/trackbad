import 'package:trackbad/Model/User.dart';
import 'package:trackbad/Model/Sensor.dart';

class connectedSensor{
  late Sensor _sensor;
  int _battery = 100; // Default value
  String _batteryIsCharging = 'No'; // Default value
  late User _player;
  String _typeSeance = 'Default'; // Default value

  // Constructor with all fields
  connectedSensor(this._sensor, this._battery, this._batteryIsCharging, this._player, this._typeSeance);

  // Constructor with only Sensor
  connectedSensor.withSensor(Sensor sensor) {
  _sensor = sensor;
  // Other fields are already initialized with default values
  }
  Sensor get sensor => _sensor;
  set sensor(Sensor value) => _sensor = value;

  int get battery => _battery;
  set battery(int value) => _battery = value;

  String get batteryIsCharging => _batteryIsCharging;
  set batteryIsCharging(String value) => _batteryIsCharging = value;

  User get player => _player;
  set player(User value) => _player = value;

  String get typeSeance => _typeSeance;
  set typeSeance(String value) => _typeSeance = value;

}