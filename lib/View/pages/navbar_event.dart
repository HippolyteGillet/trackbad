import 'package:flutter/material.dart';
import 'package:trackbad/View/pages/profil_page.dart';
import 'package:trackbad/View/pages/stats_page.dart';
import 'package:trackbad/View/pages/training_page.dart';

class NavbarEvents extends StatefulWidget {
  const NavbarEvents({super.key});

  @override
  State<NavbarEvents> createState() => _NavbarEventsState();
}

class _NavbarEventsState extends State<NavbarEvents> {
  int _currentIndex = 1;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const ProfilPage(),
        const TrainingPage(),
        const StatsPage(),
      ][_currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          indicatorColor: Colors.transparent,
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.black,
          destinations: <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset('assets/images/user.png',
                    width: 50, height: 50),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Image.asset('assets/images/user_outline.png',
                    width: 40, height: 40),
              ),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset('assets/images/plus.png',
                    width: 50, height: 50),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Image.asset('assets/images/plus_outline.png',
                    width: 40, height: 40),
              ),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset('assets/images/stats.png',
                    width: 50, height: 50),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Image.asset('assets/images/stats_outline.png',
                    width: 40, height: 40),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
