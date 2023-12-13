import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../Controller/controller.dart';
import 'dynamic_battery_icon.dart';
import 'package:collection/collection.dart';

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
    final sensors = controller.model.sensors.where((s) => s?.isActif == false).toList();

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
                      shrinkWrap: true,
                      itemCount: sensors.length,
                      itemBuilder: (context, index) {
                      final sensor = sensors[index];
                      final name = sensor?.uuid;
                      final batteryLevel = sensor?.battery;

                        return Card(
                          color:  sensor!.isConnected? Colors.orange : Colors.white,
                          shadowColor: Colors.grey[200],
                          elevation: 3,
                          child: ListTile(
                            onTap: () {
                              final controller = Provider.of<Controller>(context, listen: false);
                              if(sensor.isConnected){
                                controller.disconnectSensor(sensor.uuid!);
                              }else{
                                controller.connectSensor(sensor.uuid!);
                              }
                            },
                            title: Text(
                              name!,
                              style: const TextStyle(
                                fontFamily: 'LeagueSpartan',
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                if(batteryLevel != null) ...[
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
