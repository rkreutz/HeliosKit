import XCTest
@testable import HeliosKit

final class HeliosTests: XCTestCase {

    @available(iOS 15.0, *)
    func test_startHeliosAndCall() async throws {
        try await Helios.shared.start(rpcURL: Config.rpcUrl)

        let (data, _) = try await Helios.shared.call(method: "eth_getBalance", params: ["0x8C8D7C46219D9205f056f28fee5950aD564d7465", "latest"])
        let json = try JSONSerialization.jsonObject(with: data) as? [String: String]

        print("Response:")
        try json?.prettyPrint()
        
        XCTAssertNotNil(json?["result"])
        XCTAssert(json?["result"] != "0x")
        XCTAssert(json?["result"] != "")
    }
}

private extension Dictionary {
    func prettyPrint() throws {
        let data = try JSONSerialization.data(withJSONObject: self, options: [.sortedKeys, .prettyPrinted])
        guard let text = String(data: data, encoding: .utf8) else { return }
        print(text)
    }
}
