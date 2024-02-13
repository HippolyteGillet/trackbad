import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'navbar_event.dart';

class LoadingFile extends StatefulWidget {
  const LoadingFile({super.key});

  @override
  State<LoadingFile> createState() => _LoadingFileState();
}

class _LoadingFileState extends State<LoadingFile> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
          PageRouteBuilder(pageBuilder: (_, __, ___) => const NavbarEvents()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Récupération des données",
              style: TextStyle(
                color: Color.fromRGBO(240, 54, 18, 1),
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w700,
                fontSize: 50,
              )),
          const Padding(padding: EdgeInsets.only(top: 20)),
          LoadingAnimationWidget.staggeredDotsWave(
              color: const Color.fromRGBO(240, 54, 18, 1), size: 50),
        ],
      ),
    );
  }
}