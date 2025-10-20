import Foundation

protocol KeychainProtocolStorage {
    func load(_ key: String) throws -> String?
    func save(_ value: String, for key: String) throws
    func delete(_ key: String) throws
}

final class KeychainStorage: KeychainProtocolStorage {
    func load(_ key: String) throws -> String? {
        guard let data = try KeychainHelper.load(key: key) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func save(_ value: String, for key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainStorageError.encodeFailed(NSError(domain: "StringEncoding", code: -1))
        }
        try KeychainHelper.save(key: key, data: data)
    }

    func delete(_ key: String) throws {
        try KeychainHelper.delete(key: key)
    }
}

enum KeychainStorageError: LocalizedError {
    case encodeFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .encodeFailed(let error): return "Encoding error: \(error.localizedDescription)"
        }
    }
}
