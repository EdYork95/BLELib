//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation
import Combine

protocol BLETransportDelegate: CBPeripheralDelegate {
    
    var isReady: Published<Bool>.Publisher { get }
    var notifications: PassthroughSubject<[Int: Data], Never> { get set }
    var characteristics: [CBCharacteristic] { get set }
}

class MyPeripheralDelegate: BLETransportDelegate {
    
    var isReady: Published<Bool>.Publisher { $CharacteristicsFound }
    
    var notifications = PassthroughSubject<[Int : Data], Never>()
    
    var characteristics: [CBCharacteristic] = []
    
    @Published private var CharacteristicsFound = false
    private var writeCharacteristic: CBCharacteristic?
    private var notifyCharacteristic: CBCharacteristic?
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            switch characteristic.uuid {
            case .fakeWriteCharacteristic:
                self.writeCharacteristic = characteristic
                self.characteristics.append(characteristic)
            case .fakeNotifyCharacteristic:
                self.notifyCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                self.characteristics.append(characteristic)
            default:
                print("unrecognised characteristic \(characteristic.uuid)")
            }
        }
        // check all characteristics are found & ready to read/write
        CharacteristicsFound = writeCharacteristic != nil && notifyCharacteristic != nil
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        print(data)
    }
}
