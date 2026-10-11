import Foundation

struct Device: Codable, Identifiable {
    let id = UUID()
    let name: String
    let year: Int
    let chip: String
    let ram: String
    let storage: String
    let display: String
    let battery: String
    let faceID: Bool
    let touchID: Bool
    let dynamicIsland: Bool
    let connector: String
    let wirelessCharging: Bool
    let appleIntelligence: Bool

    enum CodingKeys: String, CodingKey {
        case name, year, chip, ram, storage, display, battery
        case faceID, touchID, dynamicIsland, connector, wirelessCharging, appleIntelligence
    }
}
