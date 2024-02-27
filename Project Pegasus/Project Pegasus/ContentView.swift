//
//  ContentView.swift
//  Project Pegasus
//
//  Created by Lorenzo Vecchio on 28/10/23.
//

import SwiftUI
import SwiftData
// import FamilyControls

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query let categories: [Category]
    @Query let sessions: [Session]
    @Query let subCategories: [SubCategory]
    @StateObject var timerManager = TimerManager()
    
    var body: some View {
        VStack {
            
            Home().onAppear {
                var isFirstLoad: Bool {
                    get {
                        UserDefaults.standard.bool(forKey: "notFirstLoad")
                    }
                    set {
                        UserDefaults.standard.set(newValue, forKey: "notFirstLoad")
                    }
                }
                if !isFirstLoad {
                    initApp()
                } else {
                    // check if sessions where left without end date
                    regularOperations()
                }
            }
        }
    }
    
    func regularOperations() {
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { notifications in
            for notification in notifications {
                if let userInfo = notification.request.content.userInfo as? [String: Any],
                   let isTimer = userInfo["isTimer"] as? Bool,
                   isTimer
                {
                    let identifier = notification.request.identifier
                    // let fetchDescriptor = FetchDescriptor<Session>()
                    do {
                        if let session = sessions.first(where: { $0.id == identifier }) {
                            if session.stopDate == nil {
                                session.stopDate = session.startDate.addingTimeInterval(session.timeGoal)
                                try context.save()
                            }
                        }
                    } catch {
                        print("Error accessing context: \(error)")
                        return
                    }
                }
            }
        }
    }
    
    func initApp() {
        var isFirstLoad: Bool {
            get {
                UserDefaults.standard.bool(forKey: "notFirstLoad")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "notFirstLoad")
            }
        }
        let timerManager = TimerManager()
        timerManager.requestNotificationPermission()
        //        let authCenter = AuthorizationCenter.shared
        //        Task {
        //            do {
        //                try await authCenter.requestAuthorization(for: .individual)
        //            } catch {
        //                handle the error
        //            }
        //        }
        let category1: Category = Category(name: "studio", color: "EC8E14")
        let category2: Category = Category(name: "lavoro", color: "F6DE00")
        let category3: Category = Category(name: "detox", color: "67CD67")
        let category4: Category = Category(name: "sport", color: "01A0E2")
        context.insert(category1)
        context.insert(category2)
        context.insert(category3)
        context.insert(category4)
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        //        let subCategory1: SubCategory = SubCategory(name: "Fotocopie", parentCategory: categories[1])
        //        context.insert(subCategory1)
        //        do {
        //            try context.save()
        //        } catch {
        //            print("Error saving context: \(error)")
        //        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let today = Date()
        let twoDaysBeforeToday = calendar.date(byAdding: .day, value: -2, to: today)!
        let oneDayBeforeToday = calendar.date(byAdding: .day, value: -1, to: today)!
        let oneDayAfterToday = calendar.date(byAdding: .day, value: +1, to: today)!
        let twoDayAfterToday = calendar.date(byAdding: .day, value: +2, to: today)!
        
        
        let session1 : Session = Session(category: categories[0],startDate: twoDaysBeforeToday, stopDate: twoDaysBeforeToday.addingTimeInterval(1800), timeGoal: 3600)
        let session2 : Session = Session(category: categories[0],startDate: oneDayBeforeToday, stopDate: oneDayBeforeToday.addingTimeInterval(800), timeGoal: 3600)
        let session3 : Session = Session(category: categories[0],startDate: today, stopDate: today.addingTimeInterval(36000), timeGoal: 36000)
        let session4 : Session = Session(category: categories[3],startDate: oneDayAfterToday, stopDate: oneDayAfterToday.addingTimeInterval(0), timeGoal: 10)
        let session5 : Session = Session(category: categories[2],startDate: twoDayAfterToday, stopDate: twoDayAfterToday.addingTimeInterval(0), timeGoal: 10)
        
        
        context.insert(session1)
        context.insert(session2)
        context.insert(session3)
        context.insert(session4)
        context.insert(session5)
        do {
            try context.save()
            print("sessioni salvate")
        } catch {
            print("Error saving context: \(error)")
        }
        
        // Dati di test per SubCategory
        
        let subC1 = SubCategory(name: "Analisi Matematica", parentCategory: categories[0])
        let subC2 = SubCategory(name: "Algebra Lineare", parentCategory: categories[0])
        let subC3 = SubCategory(name: "Programmazione", parentCategory: categories[0])
        let subC4 = SubCategory(name: "Basi di Dati", parentCategory: categories[2])
        let subC5 = SubCategory(name: "Reti di Computer", parentCategory: categories[3])
        
        
        subC1.sessions?.append(sessions[0])
        subC2.sessions?.append(sessions[2])
        subC3.sessions?.append(sessions[1])
        subC4.sessions?.append(sessions[3])
        subC5.sessions?.append(sessions[4])
        
        context.insert(subC1)
        context.insert(subC2)
        context.insert(subC3)
        context.insert(subC4)
        context.insert(subC5)
        
        do {
            try context.save()
            print("sessioni salvate")
        } catch {
            print("Error saving context: \(error)")
        }
        
        
        
        isFirstLoad = true
    }
}

