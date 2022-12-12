import Foundation

public enum Network: Hashable {
    case mainnet
    case goerli

    func asHeliosNetwork() -> HeliosNetwork {
        switch self {
        case .mainnet: return .MAINNET
        case .goerli: return .GOERLI
        }
    }
}
