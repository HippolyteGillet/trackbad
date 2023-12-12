import UIKit
import Flutter
import MovellaDotSdk


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var deviceList: [DotDevice] = []
    private var plotDataList: [DotPlotData] = []
    private let dataAccessQueue = DispatchQueue(label: "com.connexion_capteur.dataAccessQueue")
    private let exportGroup = DispatchGroup()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        //FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        let sensorChannel = FlutterMethodChannel(name: "com.example.movella_dot/sensors",
                                                 binaryMessenger: controller.binaryMessenger)
        sensorChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "getSensors":
                self?.scanSensors(result: result)
            case "connectSensor":
                self?.handleConnectSensor(call: call, result: result)
            case "startRecording":
                self?.handleStartRecording(call: call, result: result)
            case "stopRecordingAndExportData":
                self?.handleStopRecordingAndExportData(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func scanSensors(result: @escaping FlutterResult) {
        if DotConnectionManager.managerStateIsPoweredOn() {
            deviceList.removeAll() // Nettoyer la liste avant de commencer le scan
            DotConnectionManager.scan()
            DotConnectionManager.setConnectionDelegate(self)

            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                // Créer la liste des capteurs à partir de la liste mise à jour
                let sensors = self.deviceList.map { device -> [String: Any] in
                    return ["uuid": device.uuid, "batterie": 100, "estConnecte": true]
                }
                print("Scanning completed. Found sensors: \(sensors)")

                DispatchQueue.main.async {
                    result(sensors)
                }
            }
        } else {
            print("Bluetooth not enabled")
            result(FlutterError(code: "BLE_NOT_ENABLED", message: "Bluetooth is not enabled", details: nil))
        }
    }


    private func handleConnectSensor(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? String, let deviceToConnect = deviceList.first(where: { $0.uuid == args }) {
            DotConnectionManager.connect(deviceToConnect)
            DotDevicePool.bindDevice(deviceToConnect)
            print("Connecting to sensor: \(deviceToConnect.uuid)")
            result(true)
        } else {
            print("Failed to connect to sensor")
            result(false)
        }
    }

    private func handleStartRecording(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? String, let device = deviceList.first(where: { $0.uuid == args }) {
            device.startRecording(0xFFFF)
            print("Starting recording for sensor: \(device.uuid)")
            result(true)
        } else {
            print("Failed to start recording")
            result(false)
        }
    }


    func handleStopRecordingAndExportData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? String,
              let device = deviceList.first(where: { $0.uuid == args }) else {
            print("Failed to stop recording: Device not found")
            result(FlutterError(code: "DEVICE_NOT_FOUND", message: "Device not found", details: nil))
            return
        }

        if device.stopRecording() {
            print("Recording stopped for sensor: \(device.uuid)")
            startDataExportSequence(device: device)
            result(true)
        } else {
            print("Failed to stop recording for sensor: \(device.uuid)")
            result(false)
        }
    }

    func startDataExportSequence(device: DotDevice) {
            configureExportDataFormat(for: device)

            guard device.getFlashInfo(), device.getExportFileInfo() else {
                print("Échec de l'initialisation du processus d'exportation.")
                return
            }

            device.setExportFileInfoDone { [weak self] success in
                guard let strongSelf = self, success else {
                    print("Échec de l'obtention des informations sur le fichier d'exportation.")
                    return
                }

                strongSelf.processExportInfo(for: device)
            }
        }


    private func processExportInfo(for device: DotDevice) {
        if device.recording.files.count > 0 {
            do {
                try setExportFileListAndStartExport(for: device, result: { exportResult in
                    // Gérez le résultat de l'exportation ici
                    // Par exemple, vous pouvez transmettre ce résultat à l'interface Flutter
                })
            } catch {
                print("Erreur pendant le processus d'exportation : \(error)")
            }
        } else {
            print("Aucun fichier d'enregistrement disponible pour l'exportation.")
        }
    }

    func setExportFileListAndStartExport(for device: DotDevice, result: @escaping FlutterResult) throws {
           guard device.recording.files.count > 0 else {
               throw ExportError.noFilesAvailable
           }

           // Configurer le format de données pour l'exportation
           configureExportDataFormat(for: device)

           // Définir la liste des fichiers à exporter
           device.recording.exportFileList = Array(0..<device.recording.files.count)

           // Démarrer l'exportation de toutes les données
           guard device.startExportFileData() else {
               print("Échec du démarrage de l'exportation des données")
               result(false)
               return
           }

           print("Démarrage de l'exportation des données")

           // Définir le bloc de rappel pour les données exportées
           device.setDidParseExportFileDataBlock { plotData in
               print("Données exportées: \(plotData)")

               //self.saveExportedDataToFirestore(plotData: plotData)
           }

           // Définir le bloc de rappel pour la vérification de l'état de l'exportation
           device.recording.exportFileDone = { index, allFilesDone in
               if allFilesDone {
                   print("Tous les fichiers ont été exportés.")
                   self.stopDataExportSequence(for: device)
                   result(true)
               } else {
                   print("Fichier à l'index \(index) exporté.")
               }
           }
       }

       func stopDataExportSequence(for device: DotDevice) {
           if device.stopExportFileData() {
               print("Arrêt de l'exportation des données pour le capteur: \(device.uuid)")
           } else {
               print("Échec de l'arrêt de l'exportation des données pour le capteur: \(device.uuid)")
           }
       }

    func shareExportedData(_ fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(activityViewController, animated: true, completion: nil)
        }
    }

    func configureExportDataFormat(for device: DotDevice) {
        // Exemple de format d'exportation : timestamp, angles d'Euler, accélération, vitesse angulaire
        let exportDataFormat: [UInt8] = [
            0x00,
            0x07
        ]
        let exportData = Data(bytes: exportDataFormat, count: exportDataFormat.count)
        device.exportDataFormat = exportData
        print("Export data format configured for sensor: \(device.uuid)")
    }

    enum ExportError: Error {
        case noFilesAvailable
        case failedToStartExport
    }

    /*func saveExportedDataToFirestore(plotData: DotPlotData) {
            // Obtenez une référence à la base de données Firestore
            let db = Firestore.firestore()

            // Créez un dictionnaire avec les données que vous souhaitez enregistrer
            let dataToSave: [String: Any] = [
                "timestamp": plotData.timeStamp,
                "accelerationX": plotData.acc0,
                "accelerationY": plotData.acc1,
                "accelerationZ": plotData.acc2,
            ]

            // Ajoutez les données à une collection (par exemple, "sensorData")
            db.collection("sensors").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("Erreur lors de l'enregistrement des données : \(error)")
                } else {
                    print("Données enregistrées avec succès")
                }
            }
        }
        */

}


extension AppDelegate: DotConnectionDelegate {
    func onDiscover(_ device: DotDevice) {
        if !deviceList.contains(where: { $0.uuid == device.uuid }) {
            deviceList.append(device)
            print("Discovered sensor: \(device.uuid)")
        }
    }

    func onConnect(_ device: DotDevice) {
        print("Sensor connected: \(device.uuid)")
        // Logic when a sensor is connected
    }

    func onDisconnect(_ device: DotDevice) {
        DotDevicePool.unbindDevice(device)
        print("Sensor disconnected: \(device.uuid)")
        // Logic when a sensor is disconnected
    }

    // Other DotConnectionDelegate methods if needed
}
