//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation
import CoreBluetoothMock

protocol Transport {
    
    func send(data: Data, for uuid: CBMUUID)
}

class BLETransport: Transport {
    
    var peripheral: CBPeripheral
    var peripheralDelegate: BLETransportDelegate
    var isReady = false
    
    init(peripheral: CBPeripheral, delegate: BLETransportDelegate) {
        self.peripheral = peripheral
        self.peripheralDelegate = delegate
        peripheral.delegate = delegate
    }

    func send(data: Data, for uuid: CBMUUID) {
        guard let characteristic = peripheralDelegate.characteristics.first(where: { $0.uuid == uuid }) else { return }
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }
}
