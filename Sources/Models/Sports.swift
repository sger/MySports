import Foundation

public struct SportsDTO: Codable {
    public let id: ID
    public let name: String
    public let events: [SportsDTO.EventDTO]
    
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
        
        public var image: String {
            switch self {
            case .badm:
                return "badminton"
            case .bask:
                return "basketball"
            case .esps:
                return "esports"
            case .foot:
                return "football"
            case .hand:
                return "handball"
            case .iceh:
                return "ice-hockey"
            case .snoo:
                return "pool"
            case .tabl:
                return "table-tennis"
            case .tenn:
                return "tennis"
            case .voll:
                return "volleyball"
            }
        }
    }
}

extension SportsDTO {
    public struct EventDTO: Codable {
        public let name: String
        public let id: String
        public let sportID: ID
        public let sh: String
        public let time: TimeInterval
        
        enum CodingKeys: String, CodingKey {
            case name = "d"
            case id = "i"
            case sportID = "si"
            case sh
            case time = "tt"
        }
    }
}
