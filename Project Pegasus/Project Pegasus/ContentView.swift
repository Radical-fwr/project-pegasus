//
//  ContentView.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query let categories: [Category]
    @StateObject var timerManager = TimerManager()
    
    var body: some View {
        VStack {
            
            Home().onAppear {
                var isFirstLoad: Bool {
                    get {
                        UserDefaults.standard.bool(forKey: "isFirstLoad")
                    }
                    set {
                        UserDefaults.standard.set(newValue, forKey: "isFirstLoad")
                    }
                }
                if !isFirstLoad {
                    let timerManager = TimerManager()
                    timerManager.requestNotificationPermission()
                    let testUser: User = User(nome: "Giorgio")
                    let category1: Category = Category(name: "studio", color: "EC8E14")
                    let category2: Category = Category(name: "lavoro", color: "F6DE00")
                    let category3: Category = Category(name: "detox", color: "67CD67")
                    let category4: Category = Category(name: "sport", color: "01A0E2")
                    context.insert(testUser)
                    context.insert(category1)
                    context.insert(category2)
                    context.insert(category3)
                    context.insert(category4)
                    
                    do {
                        try context.save()
                    } catch {
                        print("Error saving context: \(error)")
                    }
                    
                    print(categories.count)
                    
                    //let twoHoursAgo: Date = Date().addingTimeInterval(-2 * 60 * 60)
                    //let oneHoursAgo: Date = Date().addingTimeInterval(-1 * 60 * 60)
                    //let session1: Session = Session(category: categories[0], startDate: twoHoursAgo, stopDate: oneHoursAgo, timeGoal: (1.5 * 60 * 60))
                    //let session2: Session = Session(category: categories[1], startDate: twoHoursAgo,stopDate: oneHoursAgo, timeGoal: (1.3 * 60 * 60))
                    //context.insert(session1)
                    //context.insert(session2)
                    //do {
                    //    try context.save()
                    //    print("sessioni salvate")
                    //} catch {
                    //    print("Error saving context: \(error)")
                    //}
                    
                    isFirstLoad = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
