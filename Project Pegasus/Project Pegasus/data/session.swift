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
    var category: Category
    var startDate: Date
    var stopDate: Date?
    var timeGoal: Float
    
    init(category: Category, startDate: Date, stopDate: Date? = nil, timeGoal: Float) {
        self.id = UUID().uuidString
        self.category = category
        self.startDate = startDate
        self.stopDate = stopDate
        self.timeGoal = timeGoal
    }
}
