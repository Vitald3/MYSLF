//
//  User.swift
//  MYSLF
//
//  Created by Vitald3 on 27.08.2025.
//

struct User: Hashable, Codable, Identifiable {
    let id: Int
    let name: String?
    let birthDate: String?
    let height: Int?
    let startWeight: Double?
    let currentWeight: Double?
    let targetWeight: Double?
    let level: String?
    let activities: [String]?
    let focusZones: [String]?
    let programs: [String]?
    let units: String?
    let dailyWaterGoal: Int?
    let dailyCalorieGoal: Int?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case name
        case birthDate = "birth_date"
        case height
        case startWeight = "start_weight"
        case currentWeight = "current_weight"
        case targetWeight = "target_weight"
        case level
        case activities
        case focusZones = "focus_zones"
        case programs
        case units
        case dailyWaterGoal = "daily_water_goal"
        case dailyCalorieGoal = "daily_calorie_goal"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
