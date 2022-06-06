//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation
import Combine
import CoreBluetoothMock

public class BlinkFeature: Feature {
    
    @Published public var blinked = false
    
    var transport: Transport
    
    static let request = Data([0x01])
    
    private var cancellable = Set<AnyCancellable>()
    
    init(transport: Transport) {
        self.transport = transport
    }
    
    public func blink() {
        let request = Data([0x01])
        transport.isReady.sink { ready in
            if ready {
                self.transport.send(data: request, for: .fakeWriteCharacteristic)
            }
        }
        .store(in: &cancellable)
    }
    
    private func registerSubscriber() {
        transport.notifications.sink { notification in
            if notification[1] == Data([0x02]) {
                self.blinked = true
            }
        }
        .store(in: &cancellable)
    }
}
