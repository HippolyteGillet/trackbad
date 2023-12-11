import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dynamic_battery_icon.dart';

class SearchSensor extends StatefulWidget {
  const SearchSensor({super.key});

  @override
  State<SearchSensor> createState() => _SearchSensorState();
}

class _SearchSensorState extends State<SearchSensor> {
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

  String _selectedSensor = '';

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            width: 280,
            height: 190,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                final name = sensor['name'] as String;
                final batteryLevel = sensor['batteryLevel'];
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
                    title: Text(name,
                        style: const TextStyle(
                            fontFamily: 'LeagueSpartan',
                            fontWeight: FontWeight.w900,
                            fontSize: 20)),
                    subtitle: Row(
                      children: [
                        DynamicBatteryIcon(
                            batteryLevel: int.parse('$batteryLevel')),
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
    );
  }
}
