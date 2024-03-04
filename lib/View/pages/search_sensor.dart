import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../Controller/controller.dart';
import 'dynamic_battery_icon.dart';

class SearchSensor extends StatefulWidget {
  final void Function(String) onSensorSelected;
  const SearchSensor({Key? key, required this.onSensorSelected}) : super(key: key);

  @override
  State<SearchSensor> createState() => _SearchSensorState();
}

class _SearchSensorState extends State<SearchSensor> {
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _startScanTimer();
  }

  void _startScanTimer() {
    _scanTimer = Timer.periodic(const Duration(seconds: 6), (Timer t) {
      _refreshSensors();
    });
  }

  @override
  void dispose() {
    _scanTimer?.cancel(); // Arrêter le timer lorsque la page est fermée
    super.dispose();
  }

  String _selectedSensor = '';

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
              const Text("Recherche d'appareils",
                  style: TextStyle(
                    fontFamily: 'LeagueSpartan',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  )),
              const Padding(padding: EdgeInsets.only(left: 15)),
              LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black, size: 25)
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
                  final name = sensor?.name;
                  final batteryLevel = sensor?.battery;

                  return Card(
                    color:  sensor!.isConnected? Colors.orange : Colors.white,
                    shadowColor: Colors.grey[200],
                    elevation: 3,
                    child: ListTile(
                      onTap: () async{
                        if(sensor.isConnected){
                          controller.disconnectSensor(sensor);
                          setState(() {
                            _selectedSensor = '';
                          });
                        }else{
                          _scanTimer?.cancel();
                          await controller.connectSensor(sensor.uuid!);
                          _startScanTimer();
                          setState(() {
                            _selectedSensor = sensor.uuid!;
                          });
                          widget.onSensorSelected(sensor.uuid!);
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
}
