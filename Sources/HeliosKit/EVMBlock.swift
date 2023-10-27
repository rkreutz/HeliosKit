import Foundation

public enum EVMBlock {
    case latest
    case finalized
    case custom(UInt64)
}

extension EVMBlock {
    func asBlockTag() -> BlockTag {
        switch self {
        case .latest: return .Latest
        case .finalized: return .Finalized
        case .custom(let block): return .Number(block)
        }
    }
}
