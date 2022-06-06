//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation

/// A generic BLE device
public struct Device {
    
    public var name: String? {
        return peripheral.name
    }
    
    public var serial: String {
        return "1234abcd"
    }
    
    var features: [Feature]
    
    var peripheral: CBPeripheral
    
    public func feature<T>() -> T? {
        return features.first { $0 is T } as? T
    }
}
