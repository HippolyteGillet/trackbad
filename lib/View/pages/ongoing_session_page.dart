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
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08)),
          Text("Session en cours",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.08,
                color: const Color.fromRGBO(240, 54, 18, 1),
              )),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04)),
          Image.network(
              "https://media.giphy.com/media/3HApvvXC7f8aSdAqT3/giphy.gif",
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2)),
          Center(
              child: ElevatedButton(
                onPressed: ()  {
                  controller.stopTraining();

                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const LoadingFile()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(240, 54, 18, 1),
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.05)
                  ),
                ),
                child: Text(
                  'Fin de session',
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}