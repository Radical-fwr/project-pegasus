//
//  subcategory.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 15/01/24.
//

import SwiftUI
import SwiftData

@Model
class SubCategory: Identifiable {
    var parentCategory: Category?
    @Attribute(.unique) var id: String
    @Attribute(.unique) var name: String
    var sessions: [Session]?
    var progress: Double {
        get {
            var progressList: [Double] = []
            var result: Double = 0
            for session in sessions! {
                if let stopDate = session.stopDate {
                    let sessionDuration: Double = stopDate.timeIntervalSince(session.startDate)
                    let progress: Double = sessionDuration / session.timeGoal
                    progressList.append(progress)
                }
            }
            result = progressList.reduce(0, +) / Double(progressList.count)
            if result.isNaN {
                return 0
            }
            return result
        }
    }
    
    init(name: String, parentCategory: Category? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.sessions = []
        if let parentCategory = parentCategory {
            setParentCategory(parentCategory)
        }
    }
    
    func setParentCategory(_ category: Category) {
        self.parentCategory = category
    }
}
