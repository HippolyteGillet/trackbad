import 'package:flutter/material.dart';
import 'package:trackbad/View/pages/log_page.dart';
import 'package:trackbad/View/pages/profil_page.dart';
import 'package:trackbad/View/pages/stats_page.dart';
import 'package:trackbad/View/pages/training_page.dart';
import 'package:trackbad/Controller/controller.dart';
import 'package:provider/provider.dart';

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
    final controller = Provider.of<Controller>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.58),
            child: IconButton(
              icon: Image.asset(
                'assets/images/setting-black.png',
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
              ),
              onPressed: () async {
                bool result = await controller.islogged();
                if (result) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Déconnexion'),
                        content: const Text('Voulez-vous vous déconnecter ?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              controller.model.displayUsers();
                              controller.logout();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogPage()),
                              );
                            },
                            child: const Text('Oui'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Non'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LogPage()),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/images/logo-black.png',
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.width * 0.1,
            ),
          ),
        ],
      ),
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
          height: MediaQuery.of(context).size.height * 0.08,
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) async {
            // Vérifie si l'utilisateur essaie d'accéder à la page de profil et n'est pas connecté
            if (index == 0 && !(await controller.islogged())) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogPage()),
              );
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: Colors.black,
          destinations: <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Image.asset(
                  'assets/images/user.png',
                  width: MediaQuery.of(context).size.height * 0.05,
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
              icon: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Image.asset(
                  'assets/images/user_outline.png',
                  width: MediaQuery.of(context).size.height * 0.04,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Image.asset(
                  'assets/images/plus.png',
                  width: MediaQuery.of(context).size.height * 0.05,
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
              icon: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Image.asset(
                  'assets/images/plus_outline.png',
                  width: MediaQuery.of(context).size.height * 0.04,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ),
              label: '',
            ),
            NavigationDestination(
              selectedIcon: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Image.asset('assets/images/stats.png',
                    width: MediaQuery.of(context).size.height * 0.05,
                    height: MediaQuery.of(context).size.height * 0.05),
              ),
              icon: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Image.asset('assets/images/stats_outline.png',
                    width: MediaQuery.of(context).size.height * 0.04,
                    height: MediaQuery.of(context).size.height * 0.04)
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
