import Foundation

public struct Sports: Codable {
    public let id: ID
    public let name: String
    public let events: [Sports.Event]
    
    enum CodingKeys: String, CodingKey {
        case id = "i"
        case name = "d"
        case events = "e"
    }
    
    public enum ID: String, Codable {
        case badm = "BADM"
        case bask = "BASK"
        case esps = "ESPS"
        case foot = "FOOT"
        case hand = "HAND"
        case iceh = "ICEH"
        case snoo = "SNOO"
        case tabl = "TABL"
        case tenn = "TENN"
        case voll = "VOLL"
    }
}

extension Sports {
    public struct Event: Codable {
        public let name: String
        public let id: String
        public let sportID: ID
        public let sh: String
        public let time: Int
        
        enum CodingKeys: String, CodingKey {
            case name = "d"
            case id = "i"
            case sportID = "si"
            case sh
            case time = "tt"
        }
    }
}
