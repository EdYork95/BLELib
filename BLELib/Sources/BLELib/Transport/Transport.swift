//
//  File.swift
//  
//
//  Created by Ed York on 06/06/2022.
//

import Foundation

protocol Transport {
    
    func send()
}

class BLETransport: Transport {
    
    func send() { }
}
