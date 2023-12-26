import Foundation
import VDCodable
import SimpleCoders

public protocol DataDecoder: CodableDecoder where Input == Data {
}

extension JSONDecoder: DataDecoder {
}

extension VDJSONDecoder: DataDecoder {
}

extension PropertyListDecoder: DataDecoder {
}
