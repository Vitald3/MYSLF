//
//  RegisterDeviceRequest.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

struct RegisterDeviceRequest: Codable, Hashable {
    let uuid: String
    var name: String?
    var age: Int?
    var sex: String?
    var bodyType: String?
    var dailyRoutine: String?
    var coach: String?
    var focusFirst: [String]?
    var lastBestShapeFeeling: String?
    var focusGoal: [String]?
    var trainings: [String]?
    var energyLevel: [String]?
    var physicallyActive: String?
    var hourSleep: String?
    var interested: [String]?
    var dietType: String?
    var goalBarriers: [String]?
    var waterPerDay: String?
    var motivation: [Int]?
    var physicalCondition: Int?
    var reachGoal: String?
    var loseWeightBefore: String?
    var besidesGoal: [String]?
    var goalDate: String?
    var birthDate: String?
    var height: Int?
    var startWeight: Double?
    var currentWeight: Double?
    var targetWeight: Double?
    var level: String?
    var activities: [String]?
    var focusZones: [String]?
    var programs: [String]?
    var stepsGoal: Int?
    var units: String?
    
    func copyWith(
        uuid: String? = nil,
        name: String? = nil,
        age: Int? = nil,
        sex: String? = nil,
        bodyType: String? = nil,
        dailyRoutine: String? = nil,
        coach: String? = nil,
        focusFirst: [String]? = nil,
        lastBestShapeFeeling: String? = nil,
        focusGoal: [String]? = nil,
        trainings: [String]? = nil,
        energyLevel: [String]? = nil,
        physicallyActive: String? = nil,
        hourSleep: String? = nil,
        interested: [String]? = nil,
        dietType: String? = nil,
        goalBarriers: [String]? = nil,
        waterPerDay: String? = nil,
        motivation: [Int]? = nil,
        physicalCondition: Int? = nil,
        reachGoal: String? = nil,
        loseWeightBefore: String? = nil,
        besidesGoal: [String]? = nil,
        goalDate: String? = nil,
        birthDate: String? = nil,
        height: Int? = nil,
        startWeight: Double? = nil,
        currentWeight: Double? = nil,
        targetWeight: Double? = nil,
        level: String? = nil,
        activities: [String]? = nil,
        focusZones: [String]? = nil,
        programs: [String]? = nil,
        stepsGoal: Int? = nil,
        units: String? = nil
    ) -> RegisterDeviceRequest {
        RegisterDeviceRequest(
            uuid: uuid ?? self.uuid,
            name: name ?? self.name,
            age: age ?? self.age,
            sex: sex ?? self.sex,
            bodyType: bodyType ?? self.bodyType,
            dailyRoutine: dailyRoutine ?? self.dailyRoutine,
            coach: coach ?? self.coach,
            focusFirst: focusFirst ?? self.focusFirst,
            lastBestShapeFeeling: lastBestShapeFeeling ?? self.lastBestShapeFeeling,
            focusGoal: focusGoal ?? self.focusGoal,
            trainings: trainings ?? self.trainings,
            energyLevel: energyLevel ?? self.energyLevel,
            physicallyActive: physicallyActive ?? self.physicallyActive,
            hourSleep: hourSleep ?? self.hourSleep,
            interested: interested ?? self.interested,
            dietType: dietType ?? self.dietType,
            goalBarriers: goalBarriers ?? self.goalBarriers,
            waterPerDay: waterPerDay ?? self.waterPerDay,
            motivation: motivation ?? self.motivation,
            physicalCondition: physicalCondition ?? self.physicalCondition,
            reachGoal: reachGoal ?? self.reachGoal,
            loseWeightBefore: loseWeightBefore ?? self.loseWeightBefore,
            besidesGoal: besidesGoal ?? self.besidesGoal,
            goalDate: goalDate ?? self.goalDate,
            birthDate: birthDate ?? self.birthDate,
            height: height ?? self.height,
            startWeight: startWeight ?? self.startWeight,
            currentWeight: currentWeight ?? self.currentWeight,
            targetWeight: targetWeight ?? self.targetWeight,
            level: level ?? self.level,
            activities: activities ?? self.activities,
            focusZones: focusZones ?? self.focusZones,
            programs: programs ?? self.programs,
            stepsGoal: stepsGoal ?? self.stepsGoal,
            units: units ?? self.units
        )
    }
}
