//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation
import CoreBluetoothMock

extension CBMUUID {
    static let fakeService = CBMUUID(string: serviceUUID)
    static let fakeWriteCharacteristic = CBMUUID(string: writeUUID)
    static let fakeNotifyCharacteristic = CBMUUID(string: notifyUUID)
}

extension CBMServiceMock {
    static let myService = CBMServiceMock(
        type: .fakeService,
        primary: true,
        characteristics: .writeCharacteristic, .notifyCharacteristic
    )
}

extension CBMCharacteristicMock {
    
    static let writeCharacteristic = CBMCharacteristicMock(
        type: .fakeWriteCharacteristic,
        properties: [.write, .read]
    )
    
    static let notifyCharacteristic = CBMCharacteristicMock(
        type: .fakeNotifyCharacteristic,
        properties: [.read]
    )
}

public class MockDevice: CBMPeripheralSpecDelegate {
    
    // 0xFFFF company id
    private static let manufacturerData: [UInt8] = [
        0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00
    ]
    
    public static var mock: CBMPeripheralSpec {
        return CBMPeripheralSpec
            .simulatePeripheral()
            .advertising(
                advertisementData: [CBAdvertisementDataManufacturerDataKey: Data(manufacturerData)],
                withInterval: 0.25,
                alsoWhenConnected: false
            )
            .connectable(
                name: "myDevice",
                services: [.myService],
                delegate: myDeviceCBMPeripheralSpecDelegate(),
                connectionInterval: 0,
                mtu: 23
            )
            .build()
    }
}

class myDeviceCBMPeripheralSpecDelegate: CBMPeripheralSpecDelegate { }
