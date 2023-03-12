import XCTest

final class DataExtensionsTests: XCTestCase {
    func test_initHexString() {
        XCTAssertEqual(Data(hexString: "0x123456"), Data([0x12, 0x34, 0x56] as [UInt8]))
        XCTAssertEqual(Data(hexString: "123456"), Data([0x12, 0x34, 0x56] as [UInt8]))
        XCTAssertEqual(Data(hexString: "0xabcdef"), Data([0xab, 0xcd, 0xef] as [UInt8]))
        XCTAssertEqual(Data(hexString: "0xabcde"), Data([0x0a, 0xbc, 0xde] as [UInt8]))
        XCTAssertEqual(Data(hexString: ""), Data())
        XCTAssertEqual(Data(hexString: "0x"), Data())
    }
}
