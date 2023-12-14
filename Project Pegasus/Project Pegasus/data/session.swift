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
    var startDate: Date
    var stopDate: Date?
    var timeGoal: Double
    
    init(category: Category? = nil, startDate: Date, stopDate: Date? = nil, timeGoal: Double) {
        self.id = UUID().uuidString
        self.startDate = startDate
        self.stopDate = stopDate
        self.timeGoal = timeGoal
        if let category = category {
            setCategory(category)
        }
    }
    
    func setCategory(_ category: Category) {
        self.category = category
    }
}
