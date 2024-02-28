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
    
    init(category: Category? = nil, subCategory: SubCategory? = nil, startDate: Date, stopDate: Date? = nil, timeGoal: Double) {
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
    }
    
    func setCategory(_ category: Category) {
        self.category = category
    }
    
    func setSubCategory(_ subCategory: SubCategory) {
        self.subCategory = subCategory
    }
}


