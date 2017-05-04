import Foundation

extension JSONSerializable {
    public var JSONRepresentation: AnyObject {
        var representation = [String: AnyObject]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
                
            case let value as Dictionary<String, Any>:
                representation[label] = value as AnyObject
            
            case let value as Array<Any>:
                if let val = value as? [JSONSerializable] {
                    representation[label] = val.map({ $0.JSONRepresentation as AnyObject }) as AnyObject
                } else {
                    representation[label] = value as AnyObject
                }
            
            case let value:
                representation[label] = value as AnyObject

            default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
}
