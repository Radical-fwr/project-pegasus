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
    var gifName:String
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
    
    var darkColor: String
    var darkGif: String
    
    init(name: String, color: String,gifName:String,darkColor:String, darkGif:String) {
        self.id = UUID().uuidString
        self.name = name
        self.color = color
        self.sessions = []
        self.gifName = gifName
        self.darkColor = darkColor
        self.darkGif = darkGif
    }
}

class AppColorDark{
    var orange: String = "FDB55D"
    var yellow: String = "FFE900"
    var deepGreen: String = "386641"
    var blue: String = "23395B"
    var red:String = "A3333D"
    var brownRed: String = "904E55"
    var green:String = "904E55"
    var deepGray: String = "2A3D45"
}

class AppColorLight{
    var orange: String = "F8A84A"
    var yellow: String = "F8E745"
    var green: String = "67CD67"
    var blue: String = "4557F8"
    var pink:String = "F84AC7"
    var cyan: String = "01A0E2"
    var lightGreen:String = "B2CD67"
    var lightOrange: String = "E2B001"
}
