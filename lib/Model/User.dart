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

  dynamic get email => _email;
  set email(dynamic value) => _email= value;

  dynamic get password => _password;
  set password(dynamic value) => _password = value;

  bool get log => isLog;
  set SetisLog(bool value) => isLog = value;

  void display(){
    print('  Lastname: ${lastname}');
    print('  Firstname: ${firstname}');
    print('  Email: ${email}');
    print('  ID: ${id}');
  }

}