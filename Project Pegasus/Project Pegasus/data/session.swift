//
//  session.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 14/11/23.
//

import SwiftUI
import SwiftData

@Model
class Session: Identifiable {
    @Attribute(.unique) var id: String
    var category: Category?
    var activity: Activity?
    var startDate: Date
    var stopDate: Date?
    var timeGoal: Double
    var rating: Int = 0
    var isCompleted: Bool = false
    var progress: Double {
        get {
            var progressCalc: Double = 0
            if let stopDate = stopDate {
                let sessionDuration: Double = stopDate.timeIntervalSince(startDate)
                progressCalc = sessionDuration / timeGoal
            }
            return progressCalc
        }
    }
    
    init(category: Category? = nil, activity: Activity? = nil, startDate: Date, stopDate: Date? = nil, timeGoal: Double) {
        self.id = UUID().uuidString
        self.startDate = startDate
        self.stopDate = stopDate
        self.timeGoal = timeGoal //secondi dell'obiettivo
        if let category = category {
            setCategory(category)
        }
        if let activity = activity {
            setActivity(activity)
        }
    }
    
    func setCategory(_ category: Category) {
        self.category = category
    }
    
    func setActivity(_ activity: Activity) {
        self.activity = activity
    }
    
    func completeSession(){
        isCompleted = true
    }
}


