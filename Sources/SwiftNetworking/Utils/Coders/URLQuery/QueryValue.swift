import Foundation

enum QueryValue {
    
    typealias Keyed = [([String], String)]
    
    case single(String)
    case keyed([(String, QueryValue)])
    case unkeyed([QueryValue])
    
    internal static let start = "?"
    internal static let comma = ","
    internal static let separator = "&"
    internal static let setter = "="
    internal static let openKey: Character = "["
    internal static let closeKey: Character = "]"
    internal static let point: Character = "."
    
    static func separateKey(_ key: String) -> [String] {
        var result: [String] = []
        var str = ""
        for char in key {
            switch char {
            case QueryValue.openKey:
                if result.isEmpty, !str.isEmpty {
                    result.append(str)
                    str = ""
                }
            case QueryValue.closeKey:
                result.append(str)
                str = ""
            case QueryValue.point:
                result.append(str)
                str = ""
            default:
                str.append(char)
            }
        }
        if result.isEmpty, !str.isEmpty {
            result.append(str)
        }
        return result
    }
    
    var unkeyed: [QueryValue] {
        get {
            if case .unkeyed(let result) = self {
                return result
            }
            return []
        }
        set {
            self = .unkeyed(newValue)
        }
    }
    
    var keyed: [(String, QueryValue)] {
        get {
            if case .keyed(let result) = self {
                return result
            }
            return []
        }
        set {
            self = .keyed(newValue)
        }
    }

    var single: String {
        get {
            if case .single(let result) = self {
                return result
            }
            return ""
        }
        set {
            self = .single(newValue)
        }
    }
    
    enum Errors: Error {

        case noEqualSign(String), unknown, expectedKeyedValue, prohibitedNesting
    }
}
