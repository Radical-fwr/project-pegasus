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
    var completed: Bool
    var day: Int
    var month: Int

    init(category: Category, title: String, day: Int, month: Int) {
        self.id = UUID().uuidString
        self.category = category
        self.title = title
        self.completed = false
        self.day = day
        self.month = month
    }
}

