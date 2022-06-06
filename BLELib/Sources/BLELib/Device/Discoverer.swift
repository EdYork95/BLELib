//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation
import CoreBluetoothMock
import OSLog
import CoreBluetooth

class Discoverer: CBCentralManagerDelegate {
    
    @Published var connectedDevice: Device?
    
    @Published var state: CBManagerState = .poweredOff
    
    private var central: CBCentralManager
    private var discoveredPeripherals: [CBPeripheral] = []
    
    init(mockPeripheral: CBMPeripheralSpec?) {
        if let mockPeripheral = mockPeripheral {
            os_log("Creating mock instance")
            CBMCentralManagerMock.simulateInitialState(.poweredOff)
            CBMCentralManagerMock.simulatePeripherals([mockPeripheral])
            CBMCentralManagerMock.simulatePowerOn()
            central = CBCentralManagerFactory.instance(forceMock: true)
        } else {
            central = CBMCentralManagerFactory.instance()
        }
        central.delegate = self
    }
    
    func startScan() {
        central.scanForPeripherals(withServices: nil)
    }
    
    func stopScan() {
        central.stopScan()
    }
    
    func connect(to peripheral: CBPeripheral) {
        central.connect(peripheral)
    }
    
    func disconnect(from peripheral: CBPeripheral) {
        central.cancelPeripheralConnection(peripheral)
    }
    
    func centralManagerDidUpdateState(_ central: CBMCentralManager) {
        self.state = central.state
    }
    
    func centralManager(_ central: CBMCentralManager, didDiscover peripheral: CBMPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // just auto connect to first device with given manufacturer data
        let index = 0..<2
        let id = Data([0xFF, 0xFF])
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data,
           manufacturerData[index] == id {
            connect(to: peripheral)
        }
    }
    
    func centralManager(_ central: CBMCentralManager, didConnect peripheral: CBMPeripheral) {
        let transport = BLETransport(peripheral: peripheral, delegate: MyPeripheralDelegate())
        let device = Device(
            features: [
                BlinkFeature(transport: transport)
            ],
            peripheral: peripheral
        )
        self.connectedDevice = device
    }
    
    func centralManager(_ central: CBMCentralManager, didFailToConnect peripheral: CBMPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBMCentralManager, didDisconnectPeripheral peripheral: CBMPeripheral, error: Error?) {
        
    }
}
