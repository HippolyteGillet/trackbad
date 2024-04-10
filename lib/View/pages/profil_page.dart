import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.12,
            backgroundImage: const AssetImage('assets/images/profil.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '$lastName $firstName',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                fontSize: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -MediaQuery.of(context).size.width * 0.02),
            child: Text(
              '$role',
              style: TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w900,
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05)),
          Container(
              margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.25,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  //Background Yellow
                  Positioned(
                      top: -MediaQuery.of(context).size.width * 0.07,
                      left: MediaQuery.of(context).size.width * 0.07,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        height: MediaQuery.of(context).size.width * 0.24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7D101),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.12),
                        ),
                      )),
                  Positioned(
                      top: -MediaQuery.of(context).size.width * 0.07,
                      left: MediaQuery.of(context).size.width * 0.33,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        height: MediaQuery.of(context).size.width * 0.24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7D101),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.12),
                        ),
                      )),
                  Positioned(
                      top: -MediaQuery.of(context).size.width * 0.07,
                      right: MediaQuery.of(context).size.width * 0.07,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        height: MediaQuery.of(context).size.width * 0.24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7D101),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.12),
                        ),
                      )),

                  //Containeur
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF03612),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.08),
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
                      top: -MediaQuery.of(context).size.width * 0.06,
                      left: MediaQuery.of(context).size.width * 0.08,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.22,
                        height: MediaQuery.of(context).size.width * 0.22,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF03612),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.12),
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
                      top: -MediaQuery.of(context).size.width * 0.06,
                      left: MediaQuery.of(context).size.width * 0.34,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.22,
                        height: MediaQuery.of(context).size.width * 0.22,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF03612),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.12),
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
                      top: -MediaQuery.of(context).size.width * 0.06,
                      right: MediaQuery.of(context).size.width * 0.08,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.22,
                        height:  MediaQuery.of(context).size.width * 0.22,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF03612),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.12),
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
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.11,
                      child: Text(
                        '15,3K',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.17,
                      left: MediaQuery.of(context).size.width * 0.08,
                      child: Text(
                        'Charge Max',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                      top: -MediaQuery.of(context).size.width * 0.03,
                      left: MediaQuery.of(context).size.width * 0.39,
                      child: Text(
                        '6,52\nG/S',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.17,
                      left: MediaQuery.of(context).size.width * 0.33,
                      child: Text(
                        'Intensité Max',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.11,
                      child: Text(
                        '1127‘',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                      top: MediaQuery.of(context).size.width * 0.17,
                      right: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'LeagueSpartan',
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.white,
                        ),
                      )),
                ],
              )),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03)),
          Text(
            "Vos dernière séances",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.27,
            child: Column(
              children: [
                SizedBox(
                  width: 370, // a changer
                  height: 200, // a changer
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
