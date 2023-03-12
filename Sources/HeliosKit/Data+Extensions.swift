import Foundation

public extension Data {
    struct HexEncodingOptions: OptionSet {

        public static let upperCase = HexEncodingOptions(rawValue: 1 << 0)

        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }

    init(hexString: String) {
        self.init(
            sequence(
                state: hexString.hasPrefix("0x") ? String(hexString.dropFirst(2)) : hexString,
                next: { (state: inout String) -> UInt8? in
                    guard !state.isEmpty else { return nil }
                    let byte = state.suffix(Swift.min(state.count, 2))
                    state.removeLast(Swift.min(state.count, 2))
                    return UInt8(byte, radix: 16)
                }
            ).reversed()
        )
    }
}

extension Data {
    func asRustVec() -> RustVec<UInt8> {
        let vec = RustVec<UInt8>()
        for byte in self {
            vec.push(value: byte)
        }
        return vec
    }
}
