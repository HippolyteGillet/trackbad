import 'package:flutter/material.dart';
import 'package:trackbad/View/pages/connexion_page.dart';
import 'package:trackbad/View/pages/navbar_event.dart';

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
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15)),
          Image.asset(
            'assets/images/logo_1.png',
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Text("TrackBad",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.1,
                color: Colors.white,
              )),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2)),
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
                minimumSize: Size(MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height * 0.07),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
              ),
              child: Text(
                'Se connecter',
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03)),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const NavbarEvents()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
              minimumSize: Size(MediaQuery.of(context).size.width * 0.65,
                  MediaQuery.of(context).size.height * 0.07),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.1,
                ),
              ),
            ),
            child: Text(
              'Démarrer une session',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.055,
                color: Colors.white,
              ),
            ),
          )
        ]));
  }
}
