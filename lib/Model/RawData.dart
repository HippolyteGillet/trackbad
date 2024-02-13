class RawData {
  dynamic _id;
  dynamic _acc_X;
  dynamic _acc_Y;
  dynamic _acc_Z;
  dynamic _timestamp;

  RawData(this._id, this._acc_X, this._acc_Z, this._acc_Y, this._timestamp);

  dynamic get id => _id;
  set id(dynamic value) => _id = value;

  dynamic get getX => _acc_X;
  set acc_X(dynamic value) => _acc_X = value;

  dynamic get getY => _acc_Y;
  set acc_Y(dynamic value) => _acc_Y = value;

  dynamic get getZ => _acc_Z;
  set acc_Z(dynamic value) => _acc_Z= value;

  dynamic get timestamp => _timestamp;
  set timestamp(dynamic value) => _timestamp = value;

  void display(){
    print('  Acc_X: ${getX}');
    print('  Acc_Y: ${getY}');
    print('  Acc_Z: ${getZ}');
    print('  timestamp: ${timestamp}');
    print('  ID: ${id}');
  }

}