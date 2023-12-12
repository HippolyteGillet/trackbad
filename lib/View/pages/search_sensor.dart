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

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    super.dispose();
    // Arrêter le timer
    final controller = Provider.of<Controller>(context, listen: false);
    controller.stopSensorRefreshTimer();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final enabledSensors = controller.model.sensorsEnable;
    final connectedSensors = controller.model.sensorsConnected.map((connectedSensor) => connectedSensor.sensor).toList();

    final combinedSensors = enabledSensors + connectedSensors;

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
              child: combinedSensors.isEmpty
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
                      itemCount: combinedSensors.length,
                      itemBuilder: (context, index) {
                        final sensor = combinedSensors[index];
                        final name = sensor.uuid;
// Check if the sensor is connected
                        final isSensorConnected = controller.model.sensorsConnected.any((s) => s.sensor.uuid == name);

                        // Get the battery level only if the sensor is connected
                        int? batteryLevel;
                        if (isSensorConnected) {
                          final connectedSensor = controller.model.sensorsConnected.firstWhere((s) => s.sensor.uuid == name);
                          batteryLevel = connectedSensor.battery;
                        }
                        return Card(
                          color: isSensorConnected ? Colors.orange : Colors.white,
                          shadowColor: Colors.grey[200],
                          elevation: 3,
                          child: ListTile(
                            onTap: () {
                              final controller = Provider.of<Controller>(context, listen: false);
                              if(!isSensorConnected){
                                controller.connectSensor(name);
                              }else {
                                controller.disconnectSensor(name);
                              }
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
                                if(isSensorConnected) ...[
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
                                ]
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
