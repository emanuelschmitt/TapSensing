public struct GyroData: JSONSerializable {
    public var x: Double
    public var y: Double
    public var z: Double
    public var timestamp: String
    
    public init(x: Double, y: Double, z: Double, timestamp: String) {
        self.x = x
        self.y = y
        self.z = z
        self.timestamp = timestamp;
    }
}
