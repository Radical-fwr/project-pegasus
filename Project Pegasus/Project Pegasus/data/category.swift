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
            if let sessions = sessions {
                for session in sessions {
                    progressList.append(session.progress)
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
