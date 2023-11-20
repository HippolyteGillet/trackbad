import 'package:flutter/material.dart';
import 'package:trackbad/pages/log_page.dart';
import 'package:trackbad/pages/profil_page.dart';
import 'package:trackbad/pages/training_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;
  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: [
          const LogPage(),
          const ProfilPage(),
          const TrainingPage(),
        ][_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          indicatorColor: Colors.white,

          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: const IconTheme(
                data: IconThemeData(size: 30),
                child: Icon(Icons.person_4_outlined),
              ),
              icon: Image.asset('assets/images/icons/user.png', width: 30, height: 30),
              label: 'Home',
            ),
            const NavigationDestination(
              selectedIcon: IconTheme(
                data: IconThemeData(size: 30),
                child: Icon(Icons.person_4),
              ),
              icon: Badge(child: Icon(Icons.notifications_sharp)),
              label: 'Notifications',
            ),
            const NavigationDestination(
              icon: Badge(
                label: Text('2'),
                child: Icon(Icons.messenger_sharp),
              ),
              label: 'Messages',
            ),
          ],
        ),
      ),
    );
  }
}
