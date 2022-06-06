//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation

class BlinkFeature: Feature {
    
    var transport: Transport
    
    init(transport: Transport) {
        self.transport = transport
    }
}
