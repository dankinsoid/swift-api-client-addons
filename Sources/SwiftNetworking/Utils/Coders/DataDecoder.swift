import Foundation
import SimpleCoders
import VDCodable

public protocol DataDecoder: CodableDecoder where Input == Data {}

extension JSONDecoder: DataDecoder {}

extension VDJSONDecoder: DataDecoder {}

extension PropertyListDecoder: DataDecoder {}
