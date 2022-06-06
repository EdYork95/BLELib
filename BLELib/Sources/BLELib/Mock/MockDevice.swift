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

class myDeviceCBMPeripheralSpecDelegate: CBMPeripheralSpecDelegate {
    
    var responseToReturn: Data?
    
    func peripheral(_ peripheral: CBMPeripheralSpec, didReceiveReadRequestFor characteristic: CBMCharacteristicMock) -> Result<Data, Error> {
        .success(responseToReturn ?? Data())
    }
    
    func peripheral(_ peripheral: CBMPeripheralSpec, didReceiveWriteRequestFor characteristic: CBMCharacteristicMock, data: Data) -> Result<Void, Error> {
        handle(write: data, peripheralSpec: peripheral)
        return .success(())
    }
    
    private func handle(write data: Data, peripheralSpec: CBMPeripheralSpec) {
        // normally you'd have some kind of ID value / decoding to do
        // then use a switch statement, but as currently dummy this will do
        if data == BlinkFeature.request {
            responseToReturn = Data([0x02])
            peripheralSpec.simulateValueUpdate(Data([0x02]), for: .notifyCharacteristic)
        }
    }
}
