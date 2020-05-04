/*import 'package:scoped_model/scoped_model.dart';
import 'package:bluetooth/bluetooth.dart';

mixin BluetoothModel on Model {
  FlutterBlue _bluetooth;
  List<BluetoothDevice> _deviceList = [];
  BluetoothDevice _device;
  bool _connected = false;

  void initializeBluetooth() async {
    _bluetooth = FlutterBlue.instance;
    await bluetoothConnectionState();
  }

  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    var scanSubscription = _bluetooth.scan().listen((res) {
      print('Bluetooth results: $res');
    });
  }
}*/