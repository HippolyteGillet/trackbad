import 'package:flutter/material.dart';
import 'package:trackbad/View/pages/loading_file_page.dart';
import 'package:provider/provider.dart';
import '../../Controller/controller.dart';

class OngoingSessionPage extends StatefulWidget {
  const OngoingSessionPage({super.key});

  @override
  State<OngoingSessionPage> createState() => _OngoingSessionPageState();
}

class _OngoingSessionPageState extends State<OngoingSessionPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 80)),
          const Text("Session en cours",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                fontSize: 45,
                color: Color.fromRGBO(240, 54, 18, 1),
              )),
          const Padding(padding: EdgeInsets.only(top: 60)),
          Image.network(
              "https://media.giphy.com/media/3HApvvXC7f8aSdAqT3/giphy.gif",
              width: 300,
              height: 300),
          const Padding(padding: EdgeInsets.only(top: 150)),
          Center(
              child: ElevatedButton(
            onPressed: () async {
              await controller.stopTraining();

              if (!mounted) return;

              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoadingFile()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
              minimumSize: const Size(250, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: const Text(
              'Fin de session',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Colors.white,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
