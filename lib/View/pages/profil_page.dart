import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Controller/controller.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    final loggedUsers = controller.model.users.where((element) => element.isLog == true);
    final firstName = loggedUsers.isNotEmpty ? loggedUsers.first.firstname.toString() : '';
    final lastName = loggedUsers.isNotEmpty ? loggedUsers.first.lastname.toString() : '';
    final id = loggedUsers.isNotEmpty ? loggedUsers.first.id.toString() : '';
    final role = loggedUsers.isNotEmpty ? loggedUsers.first.role.toString() : '';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/profil.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '$lastName $firstName',
              style: const TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -10),
            child: Text(
              '$role',
              style: const TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                color: Color.fromRGBO(0, 0, 0, 0.5),
                fontSize: 17,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30)),
          Container(
              margin: const EdgeInsets.only(top: 10),
              width: 350,
              height: 90,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  //Background Yellow
                  Positioned(
                      top: -36,
                      left: 15,
                      child: Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7D101),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      )),
                  Positioned(
                      top: -36,
                      left: 127.5,
                      child: Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7D101),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      )),
                  Positioned(
                      top: -36,
                      right: 15,
                      child: Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7D101),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      )),

                  //Containeur
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 350,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF03612),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.35),
                            offset: Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Circles
                  Positioned(
                      top: -30,
                      left: 20,
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF03612),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.35),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                      top: -30,
                      left: 132.5,
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF03612),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.35),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                      top: -30,
                      right: 20,
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF03612),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.35),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      )),

                  //Text
                  const Positioned(
                      top: -5,
                      left: 33,
                      child: Text(
                        '15,3K',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      )),
                  const Positioned(
                      top: 62,
                      left: 20,
                      child: Text(
                        'Charge Max',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      )),
                  const Positioned(
                      top: -15,
                      left: 155,
                      child: Text(
                        '6,52\nG/S',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )),
                  const Positioned(
                      top: 62,
                      left: 130,
                      child: Text(
                        'Intensité Max',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      )),
                  const Positioned(
                      top: -5,
                      right: 35,
                      child: Text(
                        '1127‘',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      )),
                  const Positioned(
                      top: 62,
                      right: 46,
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      )),
                ],
              )),
          const Padding(padding: EdgeInsets.only(top: 20)),
          const Text(
            "Vos dernière séances",
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),
          SizedBox(
            width: 380,
            height: 266,
            child: Column(
              children: [
                SizedBox(
                  width: 370,
                  height: 245,
                  child: ListView.builder(
                      itemCount: controller.model.rawdata.where((element) => element.player_id == id).length,
                      itemBuilder: (context, index) {
                        var item = controller.model.rawdata[index];
                        controller.dataDao.checkUpdate(controller.supabase, controller.model);
                        String type = item.type;

                        return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            margin: const EdgeInsets.only(top: 12),
                            color: const Color(0xFF222FE6),
                            elevation: 3,
                            child: ListTile(
                              onTap: () {},
                              leading: const Column(
                                children: [
                                  Padding(padding: EdgeInsets.only(top:10, left: 50)),
                                  Text(
                                    "12/12",
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 0.75),
                                      fontFamily: 'LeagueSpartan',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "1h",
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 0.75),
                                      fontFamily: 'LeagueSpartan',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              title: Text(
                                '$type',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'LeagueSpartan',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: const Text(
                                '8 Athlètes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'LeagueSpartan',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 25,
                              ),
                            ));
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
