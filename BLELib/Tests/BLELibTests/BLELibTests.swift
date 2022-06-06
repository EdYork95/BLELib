import XCTest
import Combine
@testable import BLELib

final class BLELibTests: XCTestCase {
    
    private var cancellable = Set<AnyCancellable>()
    
    func testExample() {
        let expect = expectation(description: "didConnect")
        let mock = MockDevice.mock
        let manager = DeviceManager(mockPeripheral: mock)
        manager.connectedDevicePublisher.sink { device in
            if device != nil {
                expect.fulfill()
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
