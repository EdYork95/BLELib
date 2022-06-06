
# BLELib

A bare bones example of a CoreBluetooth / CoreBluetoothMock library to handle sending/receiving of data from a BLE device.

- Device manager's is used by the app layer to begin scanning / connection, passing through publishers from Discoverer
- Discoverer Implements CoreBluetooth CBCentralManager, and handles delegate callbacks for discovery, connection etc.
- Device is an abstract representation of a BLE device, contains basic info like name, the peripheral it represents and a collection of features
- Transport simply provides the ability to write to the peripheral, and post notifications back to features.
- BLETransportDelegate Implements PeripheralDelegate in a protocol specific way and is separate from transport so we can reuse Transport for multiple delegates. BLETransportDelegate is also responsible for discovery of Characteristics and Services 
- Features are used to send requests + handle notifications & responses from the device (via a transport)
- MockDevice defines a stub of all services & characteristics and builds a simulated BLE device to advertise and hnadle write/read requests.




