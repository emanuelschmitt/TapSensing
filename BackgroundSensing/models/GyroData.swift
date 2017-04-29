public struct GyroData: JSONSerializable {
    public var x: Int
    public var y: Int
    public var z: Int
    public var timestamp: String
    
    public init(x: Int, y: Int, z: Int, timestamp: String) {
        self.x = x
        self.y = y
        self.z = z
        self.timestamp = timestamp;
    }
}
