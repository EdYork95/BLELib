import XCTest
@testable import BLELib

final class BLELibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(BLELib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
