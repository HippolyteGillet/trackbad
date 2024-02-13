class User {
  dynamic _id;
  dynamic _lastname;
  dynamic _firstname;
  dynamic _email;
  dynamic _password;
  bool isActif = false;
  var isLog = false;

  User(this._id, this._lastname, this._firstname, this._email, this._password);

  dynamic get id => _id;
  set id(dynamic value) => _id = value;

  dynamic get lastname => _lastname;
  set lastname(dynamic value) => _lastname = value;

  dynamic get firstname => _firstname;
  set firstname(dynamic value) => _firstname = value;

  User(this._id, this._nom);

  int get id => _id;
  set id(int value) => _id = value;

  bool get log => isLog;
  set SetisLog(bool value) => isLog = value;

  void display(){
    print('  Lastname: ${lastname}');
    print('  Firstname: ${firstname}');
    print('  Email: ${email}');
    print('  ID: ${id}');
  }

}