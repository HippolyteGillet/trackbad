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
            const Padding(padding: EdgeInsets.only(top: 60)),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.black, size: 40),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Text(
              "Bon Retour !",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: true,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Mot de passe oublié ?',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    )),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    bool result = await controller.login(emailController.text, passwordController.text);
                    if (result) {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const NavbarEvents()
                          )
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Erreur de connexion'),
                            content: Text('Une erreur s\'est produite lors de la tentative de connexion. Veuillez réessayer.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
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
                  minimumSize: const Size(350, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Connexion',
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Divider(
              color: Colors.grey,
              height: 40,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text("Ou se connecter avec",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                )),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              color: Colors.grey,
              width: 60,
              height: 60,
            ),
            const Padding(padding: EdgeInsets.only(top: 40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Pas encore inscrit ?',
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Créer un compte',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
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
