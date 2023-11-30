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
    
    var body: some View {
        VStack {
            Start().onAppear {
                var isFirstLoad: Bool {
                    get {
                        UserDefaults.standard.bool(forKey: "isFirstLoad")
                    }
                    set {
                        UserDefaults.standard.set(newValue, forKey: "isFirstLoad")
                    }
                }
                if !isFirstLoad {
                    print("funzione aperta")
                    let testUser: User = User(nome: "Giorgio")
                    let category1: Category = Category(name: "Studio", color: "EC8E14")
                    let category2: Category = Category(name: "Lavoro", color: "F6DE00")
                    context.insert(testUser)
                    context.insert(category1)
                    context.insert(category2)
                    
                    do {
                        try context.save()
                    } catch {
                        print("Error saving context: \(error)")
                    }
                    
                    print(categories.count)
                    
                    let twoHoursAgo: Date = Date().addingTimeInterval(-2 * 60 * 60)
                    let oneHoursAgo: Date = Date().addingTimeInterval(-1 * 60 * 60)
                    let session1: Session = Session(category: categories[0], startDate: twoHoursAgo, stopDate: oneHoursAgo, timeGoal: (1.5 * 60 * 60))
                    let session2: Session = Session(category: categories[1], startDate: twoHoursAgo,stopDate: oneHoursAgo, timeGoal: (1.3 * 60 * 60))
                    context.insert(session1)
                    context.insert(session2)
                    do {
                        try context.save()
                        print("sessioni salvate")
                    } catch {
                        print("Error saving context: \(error)")
                    }
                    
                    isFirstLoad = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
