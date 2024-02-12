import 'package:flutter/material.dart';
import 'package:trackbad/pages/connexion_page.dart';
import 'package:trackbad/pages/navbar_event.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(33, 29, 29, 1),
        body: Column(children: [
          const Padding(padding: EdgeInsets.only(top: 80)),
          Image.asset('assets/images/logo_1.png', width: 300, height: 300),
          const Text("Trackbad",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                fontSize: 45,
                color: Colors.white,
              )),
          const Padding(padding: EdgeInsets.only(top: 150)),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const ConnexionPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Se connecter',
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const NavbarEvents()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text(
              'Démarrer une session',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          )
        ]));
  }
}
