import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profil Page',
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }
}