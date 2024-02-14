class RawData {
  dynamic _id;
  List<dynamic> _acc_X;
  List<dynamic> _acc_Y;
  List<dynamic> _acc_Z;
  List<dynamic> _timestamp;

  RawData(this._id, this._acc_X, this._acc_Z, this._acc_Y, this._timestamp);

  dynamic get id => _id;
  set id(dynamic value) => _id = value;

  List<dynamic> get getX => _acc_X;
  set acc_X(List<dynamic> value) => _acc_X = value;

  List<dynamic> get getY => _acc_Y;
  set acc_Y(List<dynamic> value) => _acc_Y = value;

  List<dynamic> get getZ => _acc_Z;
  set acc_Z(List<dynamic> value) => _acc_Z= value;

  List<dynamic> get timestamp => _timestamp;
  set timestamp(dynamic value) => _timestamp = value;

  void display(){
    print('  Acc_X: ${getX}');
    print('  Acc_Y: ${getY}');
    print('  Acc_Z: ${getZ}');
    print('  timestamp: ${timestamp}');
    print('  ID: ${id}');
  }

}