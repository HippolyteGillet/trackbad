import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../Controller/controller.dart';
import 'dynamic_battery_icon.dart';

class SearchSensor extends StatefulWidget {
  const SearchSensor({super.key});

  @override
  State<SearchSensor> createState() => _SearchSensorState();
}

class _SearchSensorState extends State<SearchSensor> {
  String _selectedSensor = '';

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final sensors = controller.model.capteurs;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: 320,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(240, 54, 18, 1),
          width: 5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Recherche d'appareils",
                style: TextStyle(
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 15)),
              LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.black,
                size: 25,
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshSensors,
              child: sensors.isEmpty
                  ? SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: const Text(
                          "Aucun capteurs à proximité ou Bluetooth désactivé",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true, // Ajoutez cette ligne
                      itemCount: sensors.length,
                      itemBuilder: (context, index) {
                        final sensor = sensors[index];
                        final name = sensor.uuid;
                        final batteryLevel = sensor.batterie;
                        final isSelected = _selectedSensor == name;

                        return Card(
                          color: isSelected ? Colors.orange : Colors.white,
                          shadowColor: Colors.grey[200],
                          elevation: 3,
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                _selectedSensor = name;
                              });
                            },
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontFamily: 'LeagueSpartan',
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                DynamicBatteryIcon(
                                  batteryLevel: int.parse('$batteryLevel'),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Text(
                                  '$batteryLevel%',
                                  style: const TextStyle(
                                    fontFamily: 'LeagueSpartan',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Image.asset(
                              'assets/images/sensor.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshSensors() async {
    // Accéder à l'instance du contrôleur via Provider
    final controller = Provider.of<Controller>(context, listen: false);
    // Appeler la méthode pour scanner les capteurs
    await controller.getSensors();
  }

  void _startRefreshTimer() {
    // Accéder à l'instance du contrôleur via Provider
    final controller = Provider.of<Controller>(context, listen: false);
    // Démarrer le timer
    controller.startSensorRefreshTimer();
  }
}
