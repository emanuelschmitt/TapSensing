public struct JSONSerializableCollection: JSONSerializable {
    public var data: [JSONSerializable]
    
    public init(data: [JSONSerializable]){
        self.data = data
    }
}
