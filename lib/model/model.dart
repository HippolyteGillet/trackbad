
class Capteur {
  String _uuid;
  int _batterie;
  bool _estConnecte;

  Capteur(this._uuid, this._batterie, this._estConnecte);

  String get uuid => _uuid;
  set uuid(String value) => _uuid = value;

  int get nom => _batterie;
  set nom(int value) => _batterie = value;

  bool get estConnecte => _estConnecte;
  set estConnecte(bool value) => _estConnecte = value;

  void envoyerDonneesBrutes(List<dynamic> donnees) {
    // Implémenter l'envoi des données brutes
  }

  List<dynamic> chargerDonneesFiltrees() {
    // Implémenter le chargement des données filtrées
    return []; // Retourner les données filtrées
  }
}

class Utilisateur {
  int _id;
  String _nom;

  Utilisateur(this._id, this._nom);

  int get id => _id;
  set id(int value) => _id = value;

  String get nom => _nom;
  set nom(String value) => _nom = value;
}

class ApplicationModel {
  List<Capteur> _capteurs = [];
  List<Utilisateur> _utilisateurs = [];

  ApplicationModel() {
    // Initialiser la liste des utilisateurs avec les noms fournis
    ajouterUtilisateur('BOULET', 1);
    ajouterUtilisateur('BIME', 2);
    ajouterUtilisateur('GRAND', 3);
    ajouterUtilisateur('GILLET', 4);
  }

  void ajouterUtilisateur(String nom, int id) {
    // Ajouter un utilisateur à la liste avec un ID auto-généré
    _utilisateurs.add(Utilisateur(id, nom));
  }

  List<Utilisateur> get utilisateurs => _utilisateurs;
}

