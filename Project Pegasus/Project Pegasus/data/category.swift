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
    //add dark version of gif and color
    //the goal is to change the color of the category and the gif based on the light/dark mode of the device
    //I added two variables darkColor and darkGif, I hope they can be useful for you to implement what I asked you
    var darkColor: String
    var darkGif: String
    
    //tips: in the ColorPickerView component in the past I had manually added an array of colors, know that it will have to be modified based on how you choose to proceed
    
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
