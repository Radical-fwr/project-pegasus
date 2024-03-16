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
    var subCategory: SubCategory?
    var startDate: Date
    var stopDate: Date?
    var timeGoal: Double
    var rating: Int = 0
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
    var activity: Activity?
    
    init(category: Category? = nil, subCategory: SubCategory? = nil, activity: Activity? = nil ,startDate: Date, stopDate: Date? = nil, timeGoal: Double) {
        self.id = UUID().uuidString
        self.startDate = startDate
        self.stopDate = stopDate
        self.timeGoal = timeGoal //secondi dell'obiettivo
        if let category = category {
            setCategory(category)
        }
        if let subCategory = subCategory {
            setSubCategory(subCategory)
        }
        if let activity = activity{
            setActivity(activity)
        }
    }
    
    func setCategory(_ category: Category) {
        self.category = category
    }
    
    func setSubCategory(_ subCategory: SubCategory) {
        self.subCategory = subCategory
    }
    
    func setActivity(_ activity: Activity){
        self.activity = activity
    }
}


