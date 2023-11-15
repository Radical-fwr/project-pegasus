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
    @Relationship(deleteRule: .cascade, inverse: \Session.category)
    
    init(name: String, color: String) {
        self.id = UUID().uuidString
        self.name = name
        self.color = color
    }
}
