import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'navbar_event.dart';
import 'package:provider/provider.dart';
import '../../Controller/controller.dart';

class LoadingFile extends StatefulWidget {
  const LoadingFile({super.key});

  @override
  State<LoadingFile> createState() => _LoadingFileState();
}

class _LoadingFileState extends State<LoadingFile> {
  bool hasNavigated = false; // Ajout d'un flag pour contrôler la navigation
  bool hasExported = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, controller, child) {
        // Vérifier si l'état est false et que la navigation n'a pas encore eu lieu
        if(controller.isExporting == false && hasExported == false) {
          hasExported = true;
        }
        if (hasExported && !controller.isErasing && !hasNavigated) {
          // Marquer comme ayant navigué pour éviter de multiples navigations
          hasNavigated = true;

          // Utiliser un callback pour retarder la navigation après la construction du widget
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const NavbarEvents()));
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: _buildExportOverlay(controller),
        );
      },
    );
  }

  Widget _buildExportOverlay(Controller controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Récupération des données",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(240, 54, 18, 1),
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w700,
                fontSize: 40,
              )),
          const Padding(padding: EdgeInsets.only(top: 20)),
          LinearProgressIndicator(
            value: controller.totalPackets > 0 ? controller.currentProgress / controller.totalPackets : 0.0,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(240, 54, 18, 1)),
          ),
          const Padding(padding: EdgeInsets.only(top: 50)),
          if (controller.isExporting)
            Text("Exportation en cours: ${controller.currentProgress} sur ${controller.totalPackets}")
          else if(controller.isErasing)
            const Text("Suppression des données en cours...", textAlign: TextAlign.center,)
          else
            const Text("Préparation de l'exportation..."),
        ],
      ),
    );
  }
}
