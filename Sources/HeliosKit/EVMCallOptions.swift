import Foundation

public struct EVMCallOptions: Equatable {
    public var from: String?
    public var to: String
    public var gas: String?
    public var gasPrice: String?
    public var value: String?
    public var data: String?

    public init(
        from: String? = nil,
        to: String,
        gas: String? = nil,
        gasPrice: String? = nil,
        value: String? = nil,
        data: String? = nil
    ) {
        self.from = from
        self.to = to
        self.gas = gas
        self.gasPrice = gasPrice
        self.value = value
        self.data = data
    }
}

extension EVMCallOptions {
    func asCallOpts() -> CallOpts {
        CallOpts(
            from: (from ?? "").intoRustString(),
            to: to.intoRustString(),
            gas: (gas ?? "").intoRustString(),
            gas_price: (gasPrice ?? "").intoRustString(),
            value: (value ?? "").intoRustString(),
            data: (data ?? "").intoRustString()
        )
    }
}
