import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magisterka/api/biosignal_service.dart';
import 'package:magisterka/api/secure_storage.dart';
import 'package:magisterka/theme.dart';

class BleRecordingScreen extends StatefulWidget {
  const BleRecordingScreen({super.key});

  @override
  State<BleRecordingScreen> createState() => _BleRecordingScreenState();
}

class _BleRecordingScreenState extends State<BleRecordingScreen> {
  // Stan skanowania
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;

  // Stan nagrywania
  BluetoothDevice? _connectedDevice;
  bool _isRecording = false;
  String _deviceType = '';
  final List<int> _buffer = [];
  StreamSubscription? _notifySubscription;
  StreamSubscription? _scanSubscription;

  // Skanowanie BLE 
Future<void> _startScan() async {
  setState(() {
    _scanResults = [];
    _isScanning = true;
  });

  _scanSubscription?.cancel();
  _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
    setState(() => _scanResults = results);
  });

  await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  
  // Po upływie timeout automatycznie ustaw _isScanning na false
  setState(() => _isScanning = false);
}

Future<void> _stopScan() async {
  await FlutterBluePlus.stopScan();
  await _scanSubscription?.cancel();
  _scanSubscription = null;
  setState(() => _isScanning = false);
}

  // Połączenie z urządzeniem 
  Future<void> _connect(ScanResult result) async {
    await FlutterBluePlus.stopScan();
    final device = result.device;

    // Rozpoznaj typ urządzenia po nazwie
    final name = result.device.platformName.toLowerCase();
    if (name.contains('movesense')) {
      _deviceType = 'Movesense';
    } else if (name.contains('bitalino') || name.contains('bit')) {
      _deviceType = 'BITalino';
    } else {
      _deviceType = 'Unknown';
    }

    await device.connect(timeout: const Duration(seconds: 10));
    setState(() => _connectedDevice = device);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Connect with $_deviceType")),
    );
  }

  //Start nagrywania 
  Future<void> _startRecording() async {
    if (_connectedDevice == null) return;

    _buffer.clear();
    setState(() => _isRecording = true);

    final services = await _connectedDevice!.discoverServices();

    // Subskrybuj wszystkie charakterystyki z notify
    for (final service in services) {
      for (final char in service.characteristics) {
        if (char.properties.notify) {
          await char.setNotifyValue(true);
          _notifySubscription = char.onValueReceived.listen((data) {
            _buffer.addAll(data);
          });
        }
      }
    }
  }

  //Stop i upload 
  Future<void> _stopAndUpload() async {
    setState(() => _isRecording = false);
    await _notifySubscription?.cancel();

    if (_buffer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No data to save")),
      );
      return;
    }

    try {
      final userId = await SecureStorage.getUserId();
      if (userId == null) return;

      final ext = _deviceType == 'Movesense' ? 'csv' : 'txt';
      final fileName =
          "${_deviceType}_${DateTime.now().millisecondsSinceEpoch}.$ext";

      await BioSignalService.uploadRecording(
        userId: userId,
        deviceType: _deviceType,
        fileName: fileName,
        fileBytes: Uint8List.fromList(_buffer),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Record saved!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();       // ← DODAJ
    _notifySubscription?.cancel();
    _scanSubscription?.cancel();
    _connectedDevice?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme_Colors.background1, Theme_Colors.background2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        "Recording BLE",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status połączenia
              _statusCard(),

              const SizedBox(height: 12),

              // Przyciski akcji
              _actionButtons(),

              const SizedBox(height: 12),

              // Lista urządzeń
              Expanded(child: _deviceList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard() {
    final connected = _connectedDevice != null;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(
            connected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
            color: connected ? Colors.greenAccent : Colors.white38,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              connected
                  ? "$_deviceType — ${_connectedDevice!.platformName}"
                  : "Connection error",
              style: TextStyle(
                color: connected ? Colors.white : Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
          if (_isRecording)
            const Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isScanning ? _stopScan : _startScan,
              icon: Icon(_isScanning ? Icons.stop : Icons.search),
              label: Text(_isScanning ? "Zatrzymaj" : "Skanuj"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isScanning ? Colors.red : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _connectedDevice == null
                  ? null
                  : (_isRecording ? _stopAndUpload : _startRecording),
              icon: Icon(_isRecording ? Icons.stop : Icons.fiber_manual_record),
              label: Text(_isRecording ? "Stop i zapisz" : "Nagraj"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _deviceList() {
    if (_scanResults.isEmpty) {
      return const Center(
        child: Text(
          "Tap “Scan” to find devices",
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _scanResults.length,
      itemBuilder: (_, i) {
        final r = _scanResults[i];
        final name = r.device.platformName.isEmpty
            ? r.device.remoteId.str
            : r.device.platformName;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: ListTile(
            title: Text(name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              "RSSI: ${r.rssi} dBm",
              style: const TextStyle(color: Colors.white54),
            ),
            trailing: ElevatedButton(
              onPressed: () => _connect(r),
              child: const Text("Connect"),
            ),
          ),
        );
      },
    );
  }
}