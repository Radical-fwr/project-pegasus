//
//  category.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 09/11/23.
//

import SwiftUI
import SwiftData

@Model
class Category: Identifiable {
    @Attribute(.unique) var id: String
    @Attribute(.unique) var name: String
    var color: String
    var sessions: [Session]?
    var subCategories: [SubCategory]?
    var progress: Double {
        get {
            var progressList: [Double] = []
            var result: Double = 0
            var calcSessions = sessions!
//            for subCategory in subCategories! {
//                calcSessions += subCategory.sessions!
//            }
            for session in calcSessions {
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
    
    init(name: String, color: String) {
        self.id = UUID().uuidString
        self.name = name
        self.color = color
        self.sessions = []
    }
}
