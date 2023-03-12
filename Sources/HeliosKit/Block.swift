import Foundation

public enum Block {
    case latest
    case finalized
    case custom(UInt64)
}

extension Block {
    func asBlockTag() -> BlockTag {
        switch self {
        case .latest: return .Latest
        case .finalized: return .Finalized
        case .custom(let block): return .Number(block)
        }
    }
}
