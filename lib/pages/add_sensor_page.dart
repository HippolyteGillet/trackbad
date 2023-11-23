import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trackbad/pages/dynamic_battery_icon.dart';

class AddSensorPage extends StatefulWidget {
  const AddSensorPage({super.key});

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {
  final sensors = [
    {
      'name': 'Movella DOT 1',
      'batteryLevel': 75, // faire une getBattery pour chaque capteur ici
    },
    {
      'name': 'Movella DOT 2',
      'batteryLevel': 35,
    },
    {
      'name': 'Movella DOT 3',
      'batteryLevel': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.black, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text("Connectez votre capteur",
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                fontSize: 30,
              )),
          Container(
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
                const Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: 280,
                  height: 180,
                  child: ListView.builder(
                    itemCount: sensors.length,
                    itemBuilder: (context, index){
                      final sensor = sensors[index];
                      final name = sensor['name'];
                      final batteryLevel = sensor['batteryLevel'];

                      return Card(
                        color: Colors.white,
                        shadowColor: Colors.grey[200],
                        elevation: 5,
                        child: ListTile(
                          title: Text("$name",
                              style: const TextStyle(
                                  fontFamily: 'LeagueSpartan',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20)),
                          subtitle: Row(
                            children: [
                              DynamicBatteryIcon(batteryLevel: int.parse('$batteryLevel')),//batteryLevel),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text('$batteryLevel%',
                                  style: const TextStyle(
                                      fontFamily: 'LeagueSpartan',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                          trailing: Image.asset('assets/images/sensor.png',
                              width: 30, height: 30),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
