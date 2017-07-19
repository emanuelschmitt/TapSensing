import Foundation

extension JSONSerializable {
    public func toJSON() -> Data? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            return try JSONSerialization.data(withJSONObject: representation, options: [])
        } catch {
            return nil
        }
    }
}
