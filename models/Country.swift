
// In Country.swift, enhance the model:
// Country.swift
import Foundation

struct Country {
    let name: String
    let insects: [String]  // Changed back to string array
    let safetyTips: [String]
}

struct Insect {
    let name: String
    let scientificName: String
    let description: String
    let symptoms: [String]
    let treatmentOptions: [String]
    let imageName: String?
    let dangerLevel: DangerLevel
    let seasonalPrevalence: [Season: Prevalence]
    let habitat: [String]
}

enum DangerLevel: Int, CaseIterable {
    case low = 1
    case moderate = 2
    case high = 3
    case severe = 4
    case lethal = 5
    
    var description: String {
        switch self {
        case .low: return "Minor irritation, no medical attention needed"
        case .moderate: return "Uncomfortable symptoms, monitor closely"
        case .high: return "Significant symptoms, medical attention recommended"
        case .severe: return "Serious symptoms, medical attention required"
        case .lethal: return "Potentially life-threatening, immediate medical attention required"
        }
    }
}

enum Season: String, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"
}

enum Prevalence: String, CaseIterable {
    case rare = "Rare"
    case uncommon = "Uncommon"
    case common = "Common"
    case veryCommon = "Very Common"
}

enum RiskLevel: String, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
}
