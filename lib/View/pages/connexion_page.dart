import 'package:flutter/material.dart';
import 'package:trackbad/Controller/controller.dart';
import 'package:provider/provider.dart';

import 'navbar_event.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.06),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.width * 0.08),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Text(
              "Bon Retour !",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.width * 0.07,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  right: MediaQuery.of(context).size.width * 0.05,
                  left: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.09,
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      contentPadding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontFamily: 'LeagueSpartan',
                        fontWeight: FontWeight.w900,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.w600,
                      fontSize:
                          MediaQuery.of(context).size.width * 0.04,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                right: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.09,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    contentPadding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.03,
                      ),
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text('Mot de passe oublié ?',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  bool result = await controller.login(
                      emailController.text, passwordController.text);
                  if (result) {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const NavbarEvents()));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Erreur de connexion'),
                          content: const Text(
                              'Une erreur s\'est produite lors de la tentative de connexion. Veuillez réessayer.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.9,
                      MediaQuery.of(context).size.height * 0.065),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.03),
                  ),
                ),
                child: Text(
                  'Connexion',
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: MediaQuery.of(context).size.width * 0.002,
              indent: MediaQuery.of(context).size.width * 0.05,
              endIndent: MediaQuery.of(context).size.width * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
            Text("Ou se connecter avec",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                )),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
            ),
            Container(
              color: Colors.grey,
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pas encore inscrit ?',
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
