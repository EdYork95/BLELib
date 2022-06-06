//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation
import CoreBluetoothMock

public class BlinkFeature: Feature {
    
    var transport: Transport
    
    init(transport: Transport) {
        self.transport = transport
    }
    
    public func blink() {
        let request = Data([0x01])
        transport.send(data: request, for: .fakeWriteCharacteristic)
    }
}
