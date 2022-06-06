//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation
import CoreBluetoothMock
import Combine

/// Used as a public interface to the app layer
public class DeviceManager {
    
    public var connectedDevicePublisher: Published<Device?>.Publisher {
        return discoverer.$connectedDevice
    }
    
    private let discoverer: Discoverer
    private var cancellable = Set<AnyCancellable>()
    
    init(mockPeripheral: CBMPeripheralSpec? = nil) {
        discoverer = Discoverer(mockPeripheral: mockPeripheral)
    }
    
    public func startScan() {
        discoverer.$state.sink { state in
            if state == .poweredOn {
                self.discoverer.startScan()
            }
        }
        .store(in: &cancellable)
    }
    
    public func stopScan() {
        discoverer.stopScan()
    }
    
    
    public func disconnect() {
        guard let peripheral = discoverer.connectedDevice?.peripheral else { return }
        discoverer.disconnect(from: peripheral)
    }
}
