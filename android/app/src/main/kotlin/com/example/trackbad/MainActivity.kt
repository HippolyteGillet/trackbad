package com.example.trackbad

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.xsens.dot.android.sdk.DotSdk
import com.xsens.dot.android.sdk.events.DotData
import com.xsens.dot.android.sdk.interfaces.DotDeviceCallback
import com.xsens.dot.android.sdk.interfaces.DotScannerCallback
import com.xsens.dot.android.sdk.models.DotDevice
import com.xsens.dot.android.sdk.utils.DotScanner
import com.xsens.dot.android.sdk.models.FilterProfileInfo


import android.os.Bundle
import android.util.Log
import android.content.Context
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothDevice
import android.content.Intent


import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.os.Build
import android.bluetooth.BluetoothAdapter
import android.os.Handler
import android.os.Looper

class MainActivity : FlutterActivity(), DotScannerCallback, DotDeviceCallback {
    private lateinit var methodChannel: MethodChannel
    private var connectResult: MethodChannel.Result? = null

    private var bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    private lateinit var dotScanner: DotScanner
    private var flutterResult: MethodChannel.Result? = null
    private val deviceList = mutableListOf<BluetoothDevice>()
    private var connectedDeviceList = mutableListOf<DotDevice>()


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.movella_dot/sensors"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSensors" -> {
                    scanSensors(result)
                }

                "connectSensor" -> {
                    val sensorAddress = call.arguments as? String
                    sensorAddress?.let { address ->
                        connectToSensor(address, result)
                    } ?: run {
                        result.error("INVALID_ARGUMENTS", "Sensor address is required", null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DotSdk.setDebugEnabled(true)
        DotSdk.setReconnectEnabled(true)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.BLUETOOTH_SCAN),
                101
            )
        }

        dotScanner = DotScanner(applicationContext, this)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val requiredPermissions = mutableListOf(
                Manifest.permission.BLUETOOTH_SCAN
            )
            // Vérifiez si la permission BLUETOOTH_CONNECT est nécessaire
            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH_CONNECT
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                requiredPermissions.add(Manifest.permission.BLUETOOTH_CONNECT)
            }
            ActivityCompat.requestPermissions(this, requiredPermissions.toTypedArray(), 101)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && ActivityCompat.checkSelfPermission(
                this, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.BLUETOOTH_CONNECT), 101)
        }

    }

    private fun scanSensors(result: MethodChannel.Result) {
        if (BluetoothAdapter.getDefaultAdapter()?.isEnabled == true) {
            deviceList.clear()
            dotScanner.stopScan()
            dotScanner.startScan()

            Handler(Looper.getMainLooper()).postDelayed({
                val sensors = deviceList.map { device ->
                    mapOf("uuid" to device.getAddress())
                }
                Log.d("Scanning completed. Found sensors:", sensors.toString())
                result.success(sensors) // Passer la liste des adresses MAC à Flutter
            }, 5000)
        } else {
            Log.d("Bluetooth not enabled", "")
            result.error("BLE_NOT_ENABLED", "Bluetooth is not enabled", null)
        }
    }


    override fun onDotScanned(device: BluetoothDevice, rssi: Int) {
        deviceList.add(device)
    }


    private fun connectToSensor(sensorAddress: String, result: MethodChannel.Result) {
        val device = bluetoothAdapter?.getRemoteDevice(sensorAddress)
        device?.let { bluetoothDevice ->
            val dotDevice = DotDevice(applicationContext, bluetoothDevice, this)
            connectedDeviceList.add(dotDevice) // Ajouter le dispositif à la liste des dispositifs connectés
            connectResult = result // Stocker le résultat pour une utilisation ultérieure
            dotDevice.connect() // Tenter de se connecter
        } ?: run {
            result.error("DEVICE_NOT_FOUND", "Could not find device with address $sensorAddress", null)
        }
    }

    override fun onDotConnectionChanged(deviceAddress: String, state: Int) {
        when (state) {
            DotDevice.CONN_STATE_CONNECTED -> {
                // La connexion a réussi, informer Flutter
                connectResult?.success(mapOf("connectSensor" to deviceAddress))
                connectResult = null // Réinitialiser le résultat pour éviter les fuites de mémoire
            }
            DotDevice.CONN_STATE_DISCONNECTED -> {
                // La connexion a échoué ou a été perdue, informer Flutter
                connectResult?.error("CONNECTION_FAILED", "Failed to connect or connection lost", null)
                connectResult = null // Réinitialiser le résultat pour éviter les fuites de mémoire
            }
        }
    }


    override fun onDotServicesDiscovered(deviceAddress: String, status: Int) {
        Log.d("DotCallback", "Services discovered for $deviceAddress: $status")
    }

    override fun onDotFirmwareVersionRead(deviceAddress: String, firmwareVersion: String) {
        Log.d("DotCallback", "Firmware version for $deviceAddress: $firmwareVersion")
    }

    override fun onDotTagChanged(deviceAddress: String, tag: String) {
        Log.d("DotCallback", "Tag changed for $deviceAddress: $tag")
    }

    override fun onDotBatteryChanged(deviceAddress: String, level: Int, status: Int) {
        Log.d("DotCallback", "Battery level for $deviceAddress: $level, status: $status")
    }

    override fun onDotDataChanged(deviceAddress: String, data: DotData) {
        Log.d("DotCallback", "Data received from $deviceAddress")
    }

    override fun onDotInitDone(deviceAddress: String) {
        Log.d("DotCallback", "Device initialization done for $deviceAddress")
    }

    override fun onDotButtonClicked(deviceAddress: String, time: Long) {
        Log.d("DotCallback", "Button clicked for $deviceAddress at $time")
    }

    override fun onDotPowerSavingTriggered(deviceAddress: String) {
        Log.d("DotCallback", "Power saving triggered for $deviceAddress")
    }

    override fun onReadRemoteRssi(deviceAddress: String, rssi: Int) {
        Log.d("DotCallback", "Remote RSSI for $deviceAddress: $rssi")
    }

    override fun onDotOutputRateUpdate(deviceAddress: String, rate: Int) {
        Log.d("DotCallback", "Output rate updated for $deviceAddress: $rate")
    }

    override fun onDotFilterProfileUpdate(deviceAddress: String, profileId: Int) {
        Log.d("DotCallback", "Filter profile updated for $deviceAddress: $profileId")
    }

    override fun onDotGetFilterProfileInfo(
        deviceAddress: String,
        profiles: ArrayList<FilterProfileInfo>
    ) {
        Log.d("DotCallback", "Filter profile info received for $deviceAddress")
    }

    override fun onSyncStatusUpdate(deviceAddress: String, inSync: Boolean) {
        Log.d("DotCallback", "Sync status for $deviceAddress: $inSync")
    }

}
