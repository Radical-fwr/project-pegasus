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
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(.black)
                .foregroundColor(.white)
        }
        .modelContainer(for: [Category.self, User.self, Session.self])
    }
}
