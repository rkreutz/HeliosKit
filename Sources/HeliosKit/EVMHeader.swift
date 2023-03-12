import Foundation

public struct EVMHeader: Equatable {
    public var slot: UInt64
    public var proposerIndex: UInt64
    public var parentRoot: String
    public var stateRoot: String
    public var bodyRoot: String
}

extension EVMHeader {
    init(from header: Header) {
        self.init(
            slot: header.slot,
            proposerIndex: header.proposer_index,
            parentRoot: header.parent_root.toString(),
            stateRoot: header.state_root.toString(),
            bodyRoot: header.body_root.toString()
        )
    }
}
