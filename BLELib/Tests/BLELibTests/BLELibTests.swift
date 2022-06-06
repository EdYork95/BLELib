import XCTest
import Combine
@testable import BLELib

final class BLELibTests: XCTestCase {
    
    private var cancellable = Set<AnyCancellable>()
    
    func testExample() {
        
        // normally you'd want to do connection as part of setup(), but why not do both for now
        let expect = expectation(description: "didConnect")
        let mock = MockDevice.mock
        let manager = DeviceManager(mockPeripheral: mock)
        
        manager.connectedDevicePublisher.sink { device in
            if device != nil {
                if let blink: BlinkFeature = device?.feature() {
                    blink.$blinked.sink { blinked in
                        expect.fulfill()
                    }
                    .store(in: &self.cancellable)
                    blink.blink()
                }
            }
        }
        .store(in: &cancellable)
        
        manager.startScan()
        
        wait(for: [expect], timeout: 3)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
