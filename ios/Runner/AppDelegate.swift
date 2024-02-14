import UIKit
import Flutter
import MovellaDotSdk


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate{
    private var connectionResult: FlutterResult?
    private var connectionDeviceUuid: String?
    private var deviceList: [DotDevice] = []
    private var connectedDeviceList: [DotDevice] = []
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
            case "disconnectSensor":
                self?.handleDisconnectSensor(call: call, result: result)
            case "startRecording":
                self?.handleStartRecording(call: call, result: result)
            case "stopRecordingAndExportData":
                self?.handleStopRecordingAndExportData(call: call, result: result)
            case "eraseSensorData":
                self?.handleEraseData(call: call, result: result)
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
                    return ["uuid": device.uuid]
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
            connectedDeviceList.append(deviceToConnect)
            DotConnectionManager.connect(deviceToConnect)
            DotDevicePool.bindDevice(deviceToConnect)
            print("Connecting to sensor: \(deviceToConnect.uuid)")

            // Set a listener for the connection success
            DotConnectionManager.setConnectionDelegate(self)
            self.connectionResult = result
            self.connectionDeviceUuid = deviceToConnect.uuid
        } else {
            print("Failed to connect to sensor")
            result(FlutterError(code: "UNAVAILABLE", message: "Sensor not available or connection failed", details: nil))
        }
    }
    

    
    private func handleDisconnectSensor(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? String {
            print("Received UUID to disconnect: \(args)")
            print("Available devices: \(deviceList.map { $0.uuid })")

            if let deviceToDisconnect = connectedDeviceList.first(where: { $0.uuid == args }) {
                DotConnectionManager.disconnect(deviceToDisconnect)
                DotDevicePool.unbindDevice(deviceToDisconnect)
                print("Disconnecting from sensor: \(deviceToDisconnect.uuid)")
                result(true)
            } else {
                print("No device found with UUID: \(args)")
                result(false)
            }
        } else {
            print("Invalid arguments: \(String(describing: call.arguments))")
            result(false)
        }
    }
    
    
    private func handleStartRecording(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? String, let device = connectedDeviceList.first(where: { $0.uuid == args }) {
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
              let device = connectedDeviceList.first(where: { $0.uuid == args }) else {
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
        // Informer Flutter du nombre total de paquets à exporter
        let totalPackets = device.recording.files.count
        sendDataToFlutter(data: "{\"totalPackets\": \(totalPackets)}")


           // Définir le bloc de rappel pour les données exportées
        device.setDidParseExportFileDataBlock { [weak self] plotData in
                guard let self = self else { return }
                // Sérialisation des données exportées
                let serializedData = self.serializePlotData(plotData)
                // Envoi des données sérialisées à Flutter
                self.sendDataToFlutter(data: serializedData)
           }

           // Définir le bloc de rappel pour la vérification de l'état de l'exportation
        device.recording.exportFileDone = { [weak self] index, allFilesDone in
            let totalPackets = device.recording.files.count

            if allFilesDone {
                    print("Tous les fichiers ont été exportés.")
                    self?.stopDataExportSequence(for: device)
                DispatchQueue.main.async {
                    self?.sendDataToFlutter(data: "{\"exportCompleted\": \"\(device.uuid)\"}")
                }
                } else {
                    print("Fichier à l'index \(index) exporté.")
                    DispatchQueue.main.async {
                        self?.sendDataToFlutter(data: "{\"packetNumber\": \(index)}")
                    }
                }
            }
       }

    
    func serializePlotData(_ plotData: DotPlotData) -> String {
        // Exemple de sérialisation simplifiée. Adaptez selon vos données spécifiques.
        let serialized = "{\"timeStamp\": \(plotData.timeStamp), \"accelerationX\": \(plotData.acc0), \"accelerationY\": \(plotData.acc1), \"accelerationZ\": \(plotData.acc2)}"
        return serialized
    }

    func sendDataToFlutter(data: String) {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("RootViewController is not a FlutterViewController")
            return
        }
        let channel = FlutterMethodChannel(name: "com.example.movella_dot/data", binaryMessenger: controller.binaryMessenger)
        channel.invokeMethod("receiveData", arguments: data)
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

    private func handleEraseData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? String,
              let deviceToErase = connectedDeviceList.first(where: { $0.uuid == args }) else {
            print("Device not found")
            result(FlutterError(code: "DEVICE_NOT_FOUND", message: "Device not found", details: nil))
            return
        }

        // Configurer le bloc de callback pour l'opération d'effacement
        deviceToErase.setEraseDataDoneBlock { success in
            if success == 1 { // Supposons que 'success' soit un int où 1 représente le succès
                print("Data erased successfully for sensor: \(deviceToErase.uuid)")
                DispatchQueue.main.async {
                    result(true)
                }
            } else {
                print("Failed to erase data for sensor: \(deviceToErase.uuid)")
                DispatchQueue.main.async {
                    result(false)
                }
            }
        }

        // Lancer l'effacement des données
        deviceToErase.eraseData()
    }



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

    func onDeviceConnectSucceeded(_ device: DotDevice) {
        if device.uuid == connectionDeviceUuid {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Attendre 1 seconde
                // Envoyer les détails de la connexion à Flutter
                let connectionDetails = [
                    "macAddress": device.macAddress,
                    "battery": device.battery?.description(),
                    "totalSpace": device.totalSpace,
                    "usedSpace": device.usedSpace,
                ] as [String : Any]
                self.connectionResult?(connectionDetails)
                // Réinitialiser les propriétés
                self.connectionResult = nil
                self.connectionDeviceUuid = nil
            }
        }
    }

    func onDeviceConnectFailed(_ device: DotDevice) {
        if device.uuid == connectionDeviceUuid {
            // Envoyer un message d'erreur à Flutter
            connectionResult?(FlutterError(code: "CONNECTION_FAILED", message: "Failed to connect to sensor", details: nil))
            // Réinitialiser les propriétés
            connectionResult = nil
            connectionDeviceUuid = nil
        }
    }}

