//
//  activity.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 11/03/24.
//

import SwiftData
import SwiftUI

@Model
class Activity: Identifiable {
    @Attribute(.unique) var id: String
    var category: Category
    var title: String
    var sessions: [Session]
    var completed: Bool
    
    init(category: Category, title: String) {
        self.id = UUID().uuidString
        self.category = category
        self.title = title
        self.sessions = []
        self.completed = false
    }
}
