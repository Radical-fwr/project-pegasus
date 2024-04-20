//
//  Project_PegasusApp.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/10/23.
//

import SwiftUI
import SwiftData

@main
struct Project_PegasusApp: App {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("displayMode") var displayMode: String = "system"
    var body: some Scene {
        WindowGroup {
          
            ContentView()
                .background(colorScheme == .dark ? .black : Color(hex: "F2EFE9"))
                .preferredColorScheme(displayMode == "system" ? nil : displayMode == "dark" ? .dark : .light)
           
               
                //.foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .modelContainer(for: [
            Category.self,
            User.self,
            Session.self,
            Activity.self
        ])
    }
}
