class User {
  int _id;
  String _nom;
  bool isActif = false;

  User(this._id, this._nom);

  int get id => _id;
  set id(int value) => _id = value;

  String get nom => _nom;
  set nom(String value) => _nom = value;
}