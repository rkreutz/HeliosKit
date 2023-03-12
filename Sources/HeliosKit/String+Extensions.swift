import Foundation

extension String {
    func nilIfEmpty() -> String? {
        isEmpty ? nil : self
    }
}
